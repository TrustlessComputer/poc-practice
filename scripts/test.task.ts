import { task, types } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";

task("test-gcd", "test gcd problem")
    .addParam("contract", "Participant contract address")
    .addParam("a", "param a")
    .addParam("b", "param b")
    .addOptionalParam("gaslimit", "gaslimit", 1000000, types.int)
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const contractAddress = taskArgs.contract;
        const a = BigInt(taskArgs.a);
        const b = BigInt(taskArgs.b);
        const gasLimit = parseInt(taskArgs.gaslimit);

        const participantContract = await hre.ethers.getContractAt('IGCD', contractAddress);

        const configObj = { gasLimit };
        const answer = await participantContract.solve(a, b, configObj);

        console.log(answer.toString());
        const gasUsed = await participantContract.solve.estimateGas(a, b, configObj);
        console.log("Gas used:", gasUsed.toString());
    });

task("test-arraySort", "test ArraySort problem")
    .addParam("contract", "Participant contract address")
    .addParam("a", "param a")
    .addOptionalParam("gaslimit", "gaslimit", 1000000, types.int)
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const contractAddress = taskArgs.contract;
        const a = JSON.parse(taskArgs.a).map((x: string) => BigInt(x));
        const gasLimit = parseInt(taskArgs.gaslimit);

        const participantContract = await hre.ethers.getContractAt('IArraySort', contractAddress);

        const configObj = { gasLimit };
        const answer = await participantContract.solve(a, configObj);

        console.log(answer.map(x => Number(x)));
        const gasUsed = await participantContract.solve.estimateGas(a, configObj);
        console.log("Gas used:", gasUsed.toString());
    });

task("test-library", "test Library problem")
    .addParam("contract", "Participant contract address")
    .addParam("a", "param a")
    .addParam("u", "param u")
    .addParam("v", "param v")
    .addOptionalParam("gaslimit", "gaslimit", 1000000, types.int)
    .setAction(async (taskArgs: any, hre: HardhatRuntimeEnvironment) => {
        const contractAddress = taskArgs.contract;
        const a = JSON.parse(taskArgs.a).map((x: string) => BigInt(x));
        const u = JSON.parse(taskArgs.u).map((x: string) => BigInt(x));
        const v = JSON.parse(taskArgs.v).map((x: string) => BigInt(x));
        const gasLimit = parseInt(taskArgs.gaslimit);

        const participantContract = await hre.ethers.getContractAt('ILibrary', contractAddress);

        const configObj = { gasLimit };
        const answer = await participantContract.solve(a, u, v, configObj);

        console.log(answer.toString());
        const gasUsed = await participantContract.solve.estimateGas(a, u, v, configObj);
        console.log("Gas used:", gasUsed.toString());
    });