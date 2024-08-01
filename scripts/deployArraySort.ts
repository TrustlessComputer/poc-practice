import hre from "hardhat";
import * as ArraySortArtifact from '../artifacts/contracts/ArraySort/ArraySort.sol/ArraySort.json';
import { deployContractToZKNet } from "./lib";
import { ethers } from "ethers";

async function deployArraySort() {
    let arraySort: ethers.BaseContract;

    if (hre.network.name === "zknet") {
        arraySort = await deployContractToZKNet(hre, "ArraySort");
    } else {
        const { ethers } = hre;
        const [ deployer ] = await ethers.getSigners();    
        const ArraySortFac = new ethers.ContractFactory(ArraySortArtifact.abi, ArraySortArtifact.bytecode, deployer);    
        const ArraySort = await ArraySortFac.deploy();
        arraySort = await ArraySort.waitForDeployment();
    }
    
    const address = await arraySort.getAddress();
    console.log(`Deployed ArraySort contract on ${hre.network.name} network at address ${address}`);
}

deployArraySort()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);        
        process.exit(1);
    });
