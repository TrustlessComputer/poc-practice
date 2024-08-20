import { task, types } from "hardhat/config";
import { ethers } from "ethers";

task("set-username", "Set username")
    .addParam("username", "Username")
    .setAction(async (taskArgs: any) => {
        const {username} = taskArgs;
        const url = `https://api-dojo2.eternalai.org/api/contest/set-info/`;
        try {

            const privateKey = process.env.ZKNET_DEPLOYER_PRIVATE_KEY!;
            const wallet = new ethers.Wallet(privateKey);
            const endpoint = `${url}${wallet.address}`;
            const res = await fetch(endpoint, {
                method: "POST",
                headers: {
                    "content-type": "application/json",
                },
                body: JSON.stringify({
                    name: username
                })
            });
            const responsePayload = await res.json();
            if (responsePayload.status > 0) {
                console.log("Username set successfully 🚀.")
            }
            else {
                console.error("Failed to set username", responsePayload.message);
            }
        } 
        catch (e) {
          console.error("Failed to set username", e);
        }
    });

