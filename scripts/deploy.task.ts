import { task, types } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { deploy} from "./lib";
import fs from "fs";

task("deploy", "deploy submission")
    .addParam("p", "Problem name")
    .addOptionalParam("c", "Contract name", undefined, types.string)
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const { p: problemName, c: contractName } = taskArgs;

        const metadata = JSON.parse(fs.readFileSync("scripts/metadata.json", 'utf8'));
        let contractArtifactName: string;
        if (contractName) {
            contractArtifactName = contractName;
        } else {
            contractArtifactName = problemName;
        }
        const problem_id = String(metadata[problemName]);
        const tx_json = await deploy(contractArtifactName, hre);
        console.log(
            `${problemName} contract deployed on zk network.\n` +
            `Problem Name: ${problemName}\n` +
            `Problem ID: ${problem_id}\n` +
            `Contract Address: ${tx_json.address}\n` +
            `Transaction Hash: ${tx_json.hash}`
        );
    });