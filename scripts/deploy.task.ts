import { task, types } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { deploy, sendEvent} from "./lib";

task("deploy", "deploy submission")
    .addParam("problemName", "Problem name")
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        try {
            const {problemName} = taskArgs;
            await sendEvent('deploySolutionStart', [{
                key: 'problemName',
                value: problemName
            }]);
            const tx_json = await deploy(problemName, hre);
            const tx = tx_json.hash;
            const address = tx_json.address[0];
            console.log(
                `${problemName} contract deployed successfully on ${hre.network.name} 🚀.\n` +
                `Transaction Hash: ${tx}`
            );
            
            await sendEvent('deploySolutionSucceed', [{
                key: 'problemName',
                value: problemName
            }, 
            {
                key: 'contract_address',
                value: address
            }, 
            {
                key: 'transaction_hash',
                value: tx
            }]);
        }
        catch (e) {
            console.error("Failed to deploy contract", e);
            await sendEvent('deploySolutionFail', [{
                key: 'error',
                value: e
            }
        ]);
        }
    });

