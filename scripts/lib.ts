import { ethers } from 'ethers';
import { HardhatRuntimeEnvironment, HttpNetworkUserConfig, HardhatNetworkAccountsConfig, HardhatNetworkAccountConfig } from "hardhat/types";
import "@matterlabs/hardhat-zksync-node/dist/type-extensions";
import "@matterlabs/hardhat-zksync-verify/dist/src/type-extensions";
import { Deployer } from "@matterlabs/hardhat-zksync";
import { Provider, Wallet} from "zksync-ethers";

export async function deployContractToZKNet(hre: HardhatRuntimeEnvironment, artifactName: string): Promise<ethers.Contract> {
    const pkey: string = process.env.ZKNET_DEPLOYER_PRIVATE_KEY!;

    const provider = new Provider((hre.network.config as HttpNetworkUserConfig).url);
    // The wallet that will deploy the token and the paymaster
    // It is assumed that this wallet already has sufficient funds on zkSync
    const wallet = new Wallet(pkey);
    const deployer = new Deployer(hre, wallet);
  
    // Deploying the paymaster
    const artifact = await deployer.loadArtifact(artifactName);
    const deploymentFee = await deployer.estimateDeployFee(artifact, []);
    const parsedFee = ethers.formatEther(deploymentFee.toString());
    console.log(`The deployment is estimated to cost ${parsedFee} ETH`);
    // Deploy the contract
    const contract = await deployer.deploy(artifact, []);
    await contract.waitForDeployment();

    return contract;
}

export async function deployContract(hre: HardhatRuntimeEnvironment, artifactName: string): Promise<ethers.BaseContract> {
    const { ethers } = hre;
    const [ deployer ] = await ethers.getSigners();
    const GCD = await ethers.deployContract(artifactName, deployer);
    return await GCD.waitForDeployment();
}