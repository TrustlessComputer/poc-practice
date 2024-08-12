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

## Step 5: Solve the Problem
Each problem is located in its own folder. For example, the problem `ArraySort` can be found in the [ArraySort](contracts/ArraySort/) folder. The problem must be solved using Solidity.

For the ArraySort problem, you will find two files: [ArraySort.sol](contracts/ArraySort/ArraySort.sol) and [IArraySort.sol](contracts/ArraySort/IArraySort.sol). To solve the `ArraySort` problem, modify the `solve` function in [ArraySort.sol](contracts/ArraySort/ArraySort.sol).

## Step 6: Compile Your Solution
To compile your solution, run the following command:
```bash
npx hardhat compile
```

## Step 7: Deploy Your Solution to BVM Chain

To deploy your solution, run the deployment script with the following command:

```bash
npx hardhat deploy --p PROBLEM_NAME --c CONTRACT_NAME
```
***Notes***:
- The `-p` parameter means the problem you want to solve, and it is **required**. For instance, if you want to solve the `ArraySort` problem, you should use `--p ArraySort`.
- The `-c` parameter means the contract you want to deploy, and it is **optional**. If you don't specify the contract, the deployment script will deploy the default contract which is the same as the problem name.

*Note: The competition and practice sessions are **completely free to join**, you won’t have to pay anything. All gas fees are automatically covered in the backend.*

## Step 8: Test Your Solution
Following deployment, you will receive the address of the deployed contract. Use this address to test your solution. For example, to test the deployed ArraySort solution, use the following command:
```bash
bash test-arraysort.sh <CONTRACT_ADDRESS>
```
## Step 9: Submit Your Solution
You can submit your solution by using the following command:
```bash
npx hardhat submit --id PROBLEM_ID --tx TX_HASH
```
***Notes***:
- The `--id` parameter means the problem ID you want to submit, and it is **required**. This parameter can be found after deploying the contract solution in [step 7](#step-7-deploy-your-solution-to-bvm-chain).
- The `--tx` parameter means the transaction hash of the contract deployment, and it is **required**. This parameter can be found after deploying the contract solution in [step 7](#step-7-deploy-your-solution-to-bvm-chain).
# Need help?
Join the Proof of Code community: [PoC Community](https://t.me/PoCBVM).