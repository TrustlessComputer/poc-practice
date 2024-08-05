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
    console.log(`Deployed Library contract on ${hre.network.name} network at address ${address}`);
}

deployLibrary()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);        
        process.exit(1);
    });
