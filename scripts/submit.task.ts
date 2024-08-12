import { task, types } from "hardhat/config";
import fs from "fs";

task("submit", "submit solution")
    .addParam("id", "Problem ID")
    .addParam("tx", "Transaction Hash")
    .setAction(async (taskArgs: any) => {
        const { id: problemID, tx: transactionHash } = taskArgs;
        const url = `https://poc.bvm.network/api/contest/submit-tx?problem_id=${problemID}&tx_hash=${transactionHash}`;
        try {
            const res = await fetch(url, {
                method: "GET"
            });
            const responsePayload = await res.json();
            if (responsePayload.status > 0) {
                console.log("Solution submitted successfully");
            }
            else {
                console.error("Failed to submit solution", responsePayload.message);
            }
        } 
        catch (e) {
          console.error("Failed to submit solution", e);
        }
    });

