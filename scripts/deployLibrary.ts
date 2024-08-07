import hre from "hardhat";
import { deployContract, deployContractToZKNet } from "./lib";
import { ethers } from "ethers";

const LIBRARY_CONTRACT_NAME = "Library";

async function deployLibrary() {
    let library: ethers.BaseContract;

    if (hre.network.name === "zknet") {
        library = await deployContractToZKNet(hre, LIBRARY_CONTRACT_NAME);
    } else {
        library = await deployContract(hre, LIBRARY_CONTRACT_NAME);
    }

    const address = await library.getAddress();
    const tx = library.deploymentTransaction();
    console.log(
        `ArraySort contract deployed on ${hre.network.name} network.\n` +
        `Address: ${address}\n` +
        `Problem ID: 3\n` +
        `Transaction ID: ${tx?.hash}`
    );
}

deployLibrary()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);        
        process.exit(1);
    });
