import fs from 'fs';
import { task } from 'hardhat/config';
import { getProvider } from "./utils";
import { HardhatRuntimeEnvironment } from 'hardhat/types';

task("testSolution", "test participant submission")
    .addParam("tx", "Transaction Hash")
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const {tx} = taskArgs;
        const provider = getProvider(hre);  
        const txReceipt = await provider.getTransactionReceipt(tx);
        if (!txReceipt) {
            console.error("Transaction not found");
            return;
        }
        if (!txReceipt.contractAddress){
            console.error("Transaction is not a contract deployment");
            return;
        }
        const contract_info = await hre.ethers.getContractAt("ISolution", txReceipt.contractAddress);
        const problemName = await contract_info.getProblemName();
        console.log(`Run contract ${problemName} on ${hre.network.name}:`);
        const contract = await hre.ethers.getContractAt(`I${problemName}`, txReceipt.contractAddress)
        const start = new Date().getTime();
        const input = JSON.parse(fs.readFileSync('scripts/input.json').toString());
        console.log(`Address: ${await contract.getAddress()}`);
        console.log(`Result: ${await contract.solve.staticCall(...Object.values(input))}`);
        console.log(`Gas used: ${await contract.solve.estimateGas(...Object.values(input))}`);
        const end = new Date().getTime();
        console.log("Time (s):", (end - start)/1000);
    });
