import { HardhatUserConfig } from "hardhat/config";
import 'dotenv/config';
import "@matterlabs/hardhat-zksync";
import "@nomicfoundation/hardhat-network-helpers";
import "@nomicfoundation/hardhat-toolbox";
import "./scripts/deploy.task";
import "./scripts/test.task"

const config: HardhatUserConfig = {
  defaultNetwork: 'zknet',
  networks: {
    zknet: {
        url: "https://rpc.poc-chain.l2aas.com",
        chainId: 70683,
        accounts: [process.env.ZKNET_DEPLOYER_PRIVATE_KEY],
        allowUnlimitedContractSize: true,
        ethNetwork: "https://testnet.runechain.com/rpc", // The Ethereum Web3 RPC URL.
        zksync: true,
    } as any,
  },
  zksolc: {
    version: "latest",
    settings: {
    },
  },
  solidity: {
    compilers: [
        {
            version: '0.8.20',
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
