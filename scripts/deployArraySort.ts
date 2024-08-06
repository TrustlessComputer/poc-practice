import hre from "hardhat";
import { deployContract, deployContractToZKNet } from "./lib";
import { ethers } from "ethers";

const ARRAYSORT_CONTRACT_NAME = "ArraySort";

async function deployArraySort() {
    let arraySort: ethers.BaseContract;

    if (hre.network.name === "zknet") {
        arraySort = await deployContractToZKNet(hre, ARRAYSORT_CONTRACT_NAME);
    } else {
        arraySort = await deployContract(hre, ARRAYSORT_CONTRACT_NAME);
    }
    
    const address = await arraySort.getAddress();    
    const tx = arraySort.deploymentTransaction();
    console.log(`Deployed ArraySort contract on ${hre.network.name} network at address ${address}, tx: ${tx?.hash}`);
}

deployArraySort()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);        
        process.exit(1);
    });
