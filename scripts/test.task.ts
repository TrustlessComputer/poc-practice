import fs from 'fs';
import { task } from 'hardhat/config';
import { getProvider } from "./utils";
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const ZKNET_ESTIMATE_GAS_PROXY_ADDRESS = "0xb309B3306B8C1a0F6Dd6aF5127DeFBD07357127E"

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

        const inputData = contract.interface.encodeFunctionData("solve", Object.values(input));
        const estimateGasContract = await hre.ethers.getContractAt("EstimateGasProxy", ZKNET_ESTIMATE_GAS_PROXY_ADDRESS);
        let gasUsed, outputBytes;
        [gasUsed, outputBytes] = await estimateGasContract.estimateStaticCallGas.staticCall(txReceipt.contractAddress, inputData);
        gasUsed = Number(gasUsed);
        let output = contract.interface.decodeFunctionResult("solve", outputBytes);
        if (output.length === 1) {
            output = output[0];
        }
        console.log(`Result: ${output}`);
        console.log(`Gas used: ${gasUsed}`);

        const end = new Date().getTime();
        console.log("Time (s):", (end - start)/1000);
    });
