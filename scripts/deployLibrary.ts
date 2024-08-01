import hre from "hardhat";
import * as LibraryArtifact from '../artifacts/contracts/Library/Library.sol/Library.json';
import { deployContractToZKNet } from "./lib";
import { ethers } from "ethers";

async function deployLibrary() {
    let library: ethers.BaseContract;

    if (hre.network.name === "zknet") {
        library = await deployContractToZKNet(hre, "Library");
    } else {
        const { ethers } = hre;
        const [ deployer ] = await ethers.getSigners();    
        const LibraryFac = new ethers.ContractFactory(LibraryArtifact.abi, LibraryArtifact.bytecode, deployer);    
        const Library = await LibraryFac.deploy();
        library = await Library.waitForDeployment();
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
