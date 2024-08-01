import { HardhatUserConfig } from 'hardhat/config';
import 'dotenv/config';
import '@nomicfoundation/hardhat-toolbox';
import '@nomiclabs/hardhat-solhint';
import 'hardhat-contract-sizer'
import "@matterlabs/hardhat-zksync";

let localTestMnemonic = "test test test test test test test test test test test junk";
const config: HardhatUserConfig = {
    defaultNetwork: 'hardhat',
    networks: {
        hardhat: {
            // forking: { url: "https://node.l2.trustless.computer/" },
            accounts: {
                mnemonic: localTestMnemonic,
                accountsBalance: "10000000000000000000000000",
            },
            allowUnlimitedContractSize: true,
            gas: 100_000_000,
            blockGasLimit: 1_000_000_000,
        } as any,
        zknet: {
            url: "https://rpc.poc-chain.l2aas.com",
            chainId: 70683,
            accounts: [process.env.ZKNET_DEPLOYER_PRIVATE_KEY],
            allowUnlimitedContractSize: true,
            ethNetwork: "https://testnet.runechain.com/rpc", // The Ethereum Web3 RPC URL.
            zksync: true,
        } as any,
    },
    solidity: {
        compilers: [
            {
                version: '0.8.19',
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                    viaIR: true,
                },
            },
        ],
    },
    paths: {
        sources: './contracts',
        tests: './tests',
        cache: './cache',
        artifacts: './artifacts',
    },
    mocha: {
        timeout: 2000000,
        color: true,
        reporter: 'mocha-multi-reporters',
        reporterOptions: {
            configFile: './mocha-report.json',
        },
    },
};

export default config;
