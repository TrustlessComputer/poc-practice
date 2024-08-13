import fs from 'fs';
import { task } from 'hardhat/config';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { deploy } from './lib';
import { ethers } from 'ethers';

task("runContract", "test participant submission")
    .addParam("contractName", "Participant contract name")
    .addParam("address", "Participant contract address", ethers.ZeroAddress)
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const { contractName, address } = taskArgs;
        console.log(`Run contract ${contractName} on ${hre.network.name}:`);

        let contract: any = await deploy(contractName, hre);
        if (address === ethers.ZeroAddress) {
            console.log(`Contract address empty. Deploying new contract`);
            const { address, hash } = await deploy(contractName, hre);
            console.log(`Contract ${contractName} deployed at address ${address[0]} (tx=${hash})`);
            contract = await hre.ethers.getContractAt(contractName, address[0])
        } else {
            contract = await hre.ethers.getContractAt(contractName, address)
        }

        const start = new Date().getTime();
        const input = JSON.parse(fs.readFileSync('scripts/input.json').toString());
        console.log(`Address: ${await contract.getAddress()}`);
        console.log(`Result: ${await contract.solve.staticCall(...Object.values(input))}`);
        console.log(`Gas used: ${await contract.solve.estimateGas(...Object.values(input))}`);
        const end = new Date().getTime();

        console.log("Time (s):", (end - start)/1000);
    });
