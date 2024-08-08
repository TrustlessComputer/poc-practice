import { ethers } from 'ethers';
import { HardhatRuntimeEnvironment, HttpNetworkUserConfig, HardhatNetworkAccountsConfig, HardhatNetworkAccountConfig } from "hardhat/types";
import "@matterlabs/hardhat-zksync-node/dist/type-extensions";
import "@matterlabs/hardhat-zksync-verify/dist/src/type-extensions";
import { Deployer } from "@matterlabs/hardhat-zksync";
import { Provider, Wallet} from "zksync-ethers";

export async function deployContractToZKNet(hre: HardhatRuntimeEnvironment, config: any): Promise<ethers.Contract> {
    const pkey: string = process.env.ZKNET_DEPLOYER_PRIVATE_KEY!;

    const provider = new Provider((hre.network.config as HttpNetworkUserConfig).url);
    // The wallet that will deploy the token and the paymaster
    // It is assumed that this wallet already has sufficient funds on zkSync
    const wallet = new Wallet(pkey);
    const deployer = new Deployer(hre, wallet);
    const artifact = await deployer.loadArtifact(config.Name); 
    const contract = await deployer.deploy(artifact, [], undefined, {gasPrice: BigInt(config.GasPrice), gasLimit: BigInt(config.DeployGasLimit)});
    const tx = contract.deploymentTransaction();
    const TX_HASH = tx?.hash;
    if (!TX_HASH) {
        throw new Error("Transaction hash is not available");
    }
    const txReceipt = await provider.getTransactionReceipt(TX_HASH);
    const address = await contract.getAddress();
    const gasPrice = txReceipt?.gasPrice;
    const gasUsed = txReceipt?.gasUsed
    const cost = ethers.formatEther(gasPrice && gasUsed ? (gasPrice * gasUsed) : 0n);
    console.log(
        `Contract deployed on zkSync network.\n` +
        `Address: ${address}\n` +
        `Transaction ID: ${tx?.hash}\n` +
        `Gas price: ${gasPrice}\n` +
        `Gas used: ${gasUsed}\n` +     
        `Transaction cost: ${cost} BVM`
    );
    return contract;
}

export async function deployContract(hre: HardhatRuntimeEnvironment, config: any): Promise<ethers.BaseContract> {
    const { ethers } = hre;
    const [ deployer ] = await ethers.getSigners();
    const GCD = await ethers.deployContract(config.Name, deployer);
    return await GCD.waitForDeployment();
}

