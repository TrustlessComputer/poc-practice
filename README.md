# Proof of Code Practice

# Introduction

Welcome to Proof of Code!

Proof of Code is a free crypto coding competition with weekly prize pools, focusing initially on Solidity problems.

Hosted by BVM, the leading Rollup-As-A-Service platform on Bitcoin, allowing anyone to launch their own blockchains on Bitcoin at low cost!

More info about Proof of Code: [BVMPoC](https://bvm.network/PoC)

# Register 
To register for Proof Of Code, please `sign in` at [BVMPoC](https://bvm.network/PoC).

# Solve problems
To solve problems, follow these steps:
## Step 1: Clone the Repository
Clone this repository using the command:
```
git clone https://github.com/TrustlessComputer/poc-practice.git
```
## Step 2: Install Dependencies
Navigate to the project directory and install the required dependencies:
```
cd poc-practice
npm install 
```
***Note: This repository requires node.js version 20.11.1 or higher.***

## Step 3: Create a wallet
Go to [BVMPoC](https://bvm.network/PoC).

Click `Sign in` using your Twitter or Gmail account.

Export your private key from the website. 

<img src="export_private_key.png" alt="Proof of Code Practice Logo" width="600"/>

## Step 4: Set Up Your Private Key
Create a `.env` file in the root directory of the project and add your private key as follows:

```bash
ZKNET_DEPLOYER_PRIVATE_KEY=YOUR_PRIVATE_KEY
```

## Set up your username

To set your username, run the following command:

```bash
npx hardhat set-username --username YOUR_USERNAME
```

## Step 5: Solve the Problem
Each problem is located in its own folder. For example, the problem `APlusB` can be found in the [APlusB](contracts/APlusB/) folder. The problem must be solved using Solidity.

For the `APlusB` problem, you will find two files: [APlusB.sol](contracts/APlusB/APlusB.sol) and [IAPlusB.sol](contracts/APlusB/IAPlusB.sol). To solve the `APlusB` problem, modify the `solve` function in [APlusB.sol](contracts/APlusB/APlusB.sol).

***Note: Please do not modify the `getProblemName` or `getProblemID` functions.***

## Step 6: Compile Your Solution
To compile your solution, run the following command:
```bash
npx hardhat compile
```

## Step 7: Deploy Your Solution to BVM Chain

To deploy your solution, run the deployment script with the following command:

```bash
npx hardhat deploy --problem-name PROBLEM_NAME
```
The `--problem-name` parameter means the problem name you want to deploy, and it is **required**.

For example, to deploy the `APlusB` solution, run the following command:
```bash
npx hardhat deploy --problem-name APlusB
```

***Note: The competition and practice sessions are **completely free to join**, you won’t have to pay anything. All gas fees are automatically covered in the backend.***

## Step 8: Test Your Solution
To test your solution, you must modify the [input.json](./scripts/input.json) file with the input data you want to test. For example, to test the `APlusB` solution, modify the [input.json](./scripts/input.json) file as follows:

```json
{
  "a": 2,
  "b": 3
}
```
Then, run the following command to test your solution:
```bash
npx hardhat testSolution --tx <TRANSACTION_HASH>
```

***Note***:
The `--tx` parameter means the transaction hash of the contract deployment, and it is **required**. This parameter can be found after deploying the contract solution in [step 7](#step-7-deploy-your-solution-to-bvm-chain).

## Step 9: Submit Your Solution
You can submit your solution by using the following command:
```bash
npx hardhat submit --tx <TRANSACTION_HASH>
```
***Note***:
The `--tx` parameter means the transaction hash of the contract deployment, and it is **required**. This parameter can be found after deploying the contract solution in [step 7](#step-7-deploy-your-solution-to-bvm-chain).

# Need help?
Join the Proof of Code community: [PoC Community](https://t.me/PoCBVM).