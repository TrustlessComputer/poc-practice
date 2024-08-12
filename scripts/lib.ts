import { getWallet, getProvider } from "./utils";
import { ethers } from "ethers";
import { utils } from "zksync-ethers";
import {HardhatRuntimeEnvironment} from "hardhat/types";
import {ZkSyncArtifact} from "@matterlabs/hardhat-zksync-deploy/src/types";
import {Address, DeploymentInfo} from "zksync-ethers/src/types";
import * as os from "os";



const PAYMASTER_ADDRESS = "0xcdbe9d69d5d9a98d85384c05b462d16a588b53fa";
const TOKEN_ADDRESS = "0xa2d4a08fA9f55BBB16BD88b9D21E940443022315"
const CONTRACT_DEPLOYER = "0x0000000000000000000000000000000000008006"

if (!PAYMASTER_ADDRESS)
    throw new Error("Contract and Paymaster addresses are required.");

export async function deploy(artifactName: string, hre: HardhatRuntimeEnvironment) {
  console.log(`Running script to interact with contract ${PAYMASTER_ADDRESS} using paymaster ${PAYMASTER_ADDRESS}`);

  const contractDeployed = await hre.artifacts.readArtifact(
      artifactName
  );
  const contractArtifact = await hre.artifacts.readArtifact(
      "ContractDeployer"
  );
  const provider = getProvider(hre);
  // Initialize contract instance for interaction
  const contract = new ethers.Contract(
    CONTRACT_DEPLOYER,
    contractArtifact.abi,
    getWallet(hre)
  );
  const paymasterArtifact = await hre.artifacts.readArtifact(
      "ApprovalFlowPaymasterTokens"
  );
  const paymasterContract = new ethers.Contract(
      PAYMASTER_ADDRESS,
      paymasterArtifact.abi,
      getWallet(hre)
  );

  const gasPrice = await paymasterContract.gasPrice(TOKEN_ADDRESS);
  const baseDeps = await extractFactoryDeps(hre, contractDeployed);
  if (baseDeps.length == 0) {
    baseDeps.push(contractDeployed.bytecode)
  }

  const saltInput = ethers.ZeroHash;
  const bytecodehash = hashBytecode(contractDeployed.bytecode);

  let gasLimit = await contract.create.estimateGas(saltInput, bytecodehash, '0x', {
    value: 0,
    customData: {
      factoryDeps: baseDeps
    }
  });
  gasLimit = gasLimit + BigInt("400000");
  // get gas price

  const paymasterParams = utils.getPaymasterParams(PAYMASTER_ADDRESS, {
    type: "ApprovalBased",
    token: TOKEN_ADDRESS,
    minimalAllowance: gasPrice * gasLimit,
    innerInput: new Uint8Array(),
  });

  const transaction = await contract.create(saltInput, bytecodehash, '0x', {
    value: 0,
    maxPriorityFeePerGas: 0,
    maxFeePerGas: await provider.getGasPrice(),
    gasLimit,
    // Pass the paymaster params as custom data
    customData: {
      gasPerPubdata: utils.DEFAULT_GAS_PER_PUBDATA_LIMIT,
      paymasterParams,
      factoryDeps: baseDeps
    },
  });
  await transaction.wait();

  const txReceipt = await provider.getTransactionReceipt(transaction.hash);

  const deployedAddresses = getDeployedContracts(txReceipt).map(
      info => info.deployedAddress
  );
  return {"hash": transaction.hash, "address": deployedAddresses};
}

export async function extractFactoryDeps(hre: HardhatRuntimeEnvironment, artifact: ZkSyncArtifact): Promise<string[]> {
  const visited = new Set<string>();
  visited.add(`${artifact.sourceName}:${artifact.contractName}`);
  return await extractFactoryDepsRecursive(hre, artifact, visited);
}

export async function extractFactoryDepsRecursive(
    hre: HardhatRuntimeEnvironment,
    artifact: ZkSyncArtifact,
    visited: Set<string>,
): Promise<string[]> {
  // Load all the dependency bytecodes.
  // We transform it into an array of bytecodes.
  const factoryDeps: string[] = [];
  for (const dependencyHash in artifact.factoryDeps) {
    if (!dependencyHash) continue;
    const dependencyContract = artifact.factoryDeps[dependencyHash];
    if (!visited.has(dependencyContract)) {
      const dependencyArtifact = await loadArtifact(hre, dependencyContract);
      factoryDeps.push(dependencyArtifact.bytecode);
      visited.add(dependencyContract);
      const transitiveDeps = await extractFactoryDepsRecursive(hre, dependencyArtifact, visited);
      factoryDeps.push(...transitiveDeps);
    }
  }

  return factoryDeps;
}

function hashBytecode(bytecode: ethers.BytesLike): Uint8Array {
  // For getting the consistent length we first convert the bytecode to UInt8Array
  const bytecodeAsArray = ethers.getBytes(bytecode);

  if (bytecodeAsArray.length % 32 !== 0) {
    throw new Error('The bytecode length in bytes must be divisible by 32!');
  }

  const hashStr = ethers.sha256(bytecodeAsArray);
  const hash = ethers.getBytes(hashStr);

  // Note that the length of the bytecode
  // should be provided in 32-byte words.
  const bytecodeLengthInWords = bytecodeAsArray.length / 32;
  if (bytecodeLengthInWords % 2 === 0) {
    throw new Error('Bytecode length in 32-byte words must be odd!');
  }

  const bytecodeLength = ethers.toBeArray(bytecodeLengthInWords);

  // The bytecode should always take the first 2 bytes of the bytecode hash,
  // so we pad it from the left in case the length is smaller than 2 bytes.
  const bytecodeLengthPadded = ethers.getBytes(
      ethers.zeroPadValue(bytecodeLength, 2)
  );

  const codeHashVersion = new Uint8Array([1, 0]);
  hash.set(codeHashVersion, 0);
  hash.set(bytecodeLengthPadded, 2);

  return hash;
}


export function getDeployedContracts(
    receipt: ethers.TransactionReceipt
): DeploymentInfo[] {
  const addressBytesLen = 40;
  return (
      receipt.logs
          .filter(
              log =>
                  log.topics[0] ===
                  ethers.id('ContractDeployed(address,bytes32,address)') &&
                  isAddressEq(log.address, CONTRACT_DEPLOYER)
          )
          // Take the last topic (deployed contract address as U256) and extract address from it (U160).
          .map(log => {
            const sender = `0x${log.topics[1].slice(
                log.topics[1].length - addressBytesLen
            )}`;
            const bytecodeHash = log.topics[2];
            const address = `0x${log.topics[3].slice(
                log.topics[3].length - addressBytesLen
            )}`;
            return {
              sender: ethers.getAddress(sender),
              bytecodeHash: bytecodeHash,
              deployedAddress: ethers.getAddress(address),
            };
          })
  );
}

export function isAddressEq(a: Address, b: Address): boolean {
  return a.toLowerCase() === b.toLowerCase();
}

const TRACKING_URL =
"https://nbc-analytics-drwcpccxdq-as.a.run.app/api/v1/event_tracking";

type EventParam = {
  key: string;
  value: any;
};

export async function sendEvent(eventName: string, eventParams: EventParam[]) {
  try {
    const TRACKING_URL =
      "https://nbc-analytics-drwcpccxdq-as.a.run.app/api/v1/event_tracking";

    const privateKey = process.env.ZKNET_DEPLOYER_PRIVATE_KEY!;
    const wallet = new ethers.Wallet(privateKey);

    const res = await fetch(TRACKING_URL, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        Accept: "application/json",
        Authorization: "P1x4509vQnABdPiBKmTKNV0DuNpRb0U0",
      },
      body: JSON.stringify({
        event_name: eventName,
        event_timestamp: Math.floor(new Date().getTime() / 1000),
        data: {
          platform: os.platform(),
          user_id: wallet.address,
          user_pseudo_id: wallet.address,
          event_params: eventParams,
        },
      }),
    });
    const responsePayload = await res.json();
    console.log("Send event", eventName, responsePayload);
  } catch (e) {
    console.error("Failed to track event", e);
  }
}