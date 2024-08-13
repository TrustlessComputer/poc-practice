import fs from 'fs';
import { task } from 'hardhat/config';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { ethers } from 'ethers';

task("testSolution", "test participant submission")
    .addParam("problemName", "Problem name")
    .addParam("address", "Participant contract address", ethers.ZeroAddress)
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const { problemName, address } = taskArgs;
        console.log(`Run contract ${problemName} on ${hre.network.name}:`);
        const contract = await hre.ethers.getContractAt(`I${problemName}`, address)
        const start = new Date().getTime();
        const input = JSON.parse(fs.readFileSync('scripts/input.json').toString());
        console.log(`Address: ${await contract.getAddress()}`);
        console.log(`Result: ${await contract.solve.staticCall(...Object.values(input))}`);
        console.log(`Gas used: ${await contract.solve.estimateGas(...Object.values(input))}`);
        const end = new Date().getTime();

        console.log("Time (s):", (end - start)/1000);
    });
