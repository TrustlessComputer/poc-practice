import hre from "hardhat";
import { deployContract, deployContractToZKNet } from "./lib";
import { ethers } from "ethers";

const GCD_CONTRACT_NAME = "GCD";

async function deployGCD() {
    let gcd: ethers.BaseContract;

    if (hre.network.name === "zknet") {
        gcd = await deployContractToZKNet(hre, GCD_CONTRACT_NAME);
    } else {
        gcd = await deployContract(hre, GCD_CONTRACT_NAME);
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
