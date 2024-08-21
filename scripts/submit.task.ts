import { getProvider } from "./utils";
import { task, types } from "hardhat/config";
import {HardhatRuntimeEnvironment} from "hardhat/types";

task("submit", "submit solution")
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
        const contract = await hre.ethers.getContractAt("ISolution", txReceipt.contractAddress);
        const problemID = await contract.getProblemID();
        const url = `https://poc.bvm.network/api/contest/submit-tx?problem_id=${problemID}&tx_hash=${tx}`;
        try {
            const res = await fetch(url, {
                method: "GET"
            });
            const responsePayload = await res.json();
            if (responsePayload.status > 0) {
                console.log("Solution submitted successfully 🚀.")
            }
            else {
                console.error("Failed to submit solution", responsePayload.message);
            }
        } 
        catch (e) {
          console.error("Failed to submit solution", e);
        }
    });

