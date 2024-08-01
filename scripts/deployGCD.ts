import hre from "hardhat";
import * as GCDArtifact from '../artifacts/contracts/GCD/GCD.sol/GCD.json';
import { deployContractToZKNet } from "./lib";
import { ethers } from "ethers";

async function deployGCD() {
    let gcd: ethers.BaseContract;

    if (hre.network.name === "zknet") {
        gcd = await deployContractToZKNet(hre, "GCD");
    } else {
        const { ethers } = hre;
        const [ deployer ] = await ethers.getSigners();    
        const GCDFac = new ethers.ContractFactory(GCDArtifact.abi, GCDArtifact.bytecode, deployer);    
        const GCD = await GCDFac.deploy();
        gcd = await GCD.waitForDeployment();
    }

    const address = await gcd.getAddress();
    console.log(`Deployed GCD contract on ${hre.network.name} network at address ${address}`);
}

deployGCD()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);        
        process.exit(1);
    });
