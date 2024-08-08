import hre from "hardhat";
import { deployContract, deployContractToZKNet } from "./lib";
import { ethers } from "ethers";
import fs from "fs";
import * as path from 'path';

const GCD_CONTRACT_NAME = "GCD";

async function deployGCD() {
    let arraySort: ethers.BaseContract;
    const scriptDir = path.resolve(__dirname, "..");
    const script_path = path.join(scriptDir, "contracts", GCD_CONTRACT_NAME, GCD_CONTRACT_NAME + ".json");
    const configObject = JSON.parse(fs.readFileSync(script_path, 'utf8'));
    if (hre.network.name === "zknet") {
        arraySort = await deployContractToZKNet(hre, configObject);
    } else {
        arraySort = await deployContract(hre, configObject);
    }
    console.log(
        `ArraySort contract deployed on ${hre.network.name} network.\n` +
        `Problem ID: ${configObject.ProblemID}\n`
    );
}

deployGCD()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);        
        process.exit(1);
    });
