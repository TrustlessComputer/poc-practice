# Proof of Code Practice

# Introduction
Welcome to Proof of Code, a weekly crypto coding competition with prize pools of $500, focusing initially on Solidity problems. Hosted by **BVM**, the leading Rollup-As-A-Service platform on Bitcoin, Proof of Code enables anyone to launch their own blockchain on Bitcoin for just $99/month.

# Register 
To register for Proof Of Code, please visit [BVMPoC](https://bvm.network/PoC).

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
## Step 3: Set Up Your Private Key
Create a `.env` file in the root directory of the project and add your private key as follows:
```
ZKNET_DEPLOYER_PRIVATE_KEY=YOUR_PRIVATE_KEY
```
## Step 4: Solve the Problem
Each problem is located in its own folder. For example, the problem `ArraySort` can be found in the [ArraySort](contracts/ArraySort/) folder. The problem must be solved using Solidity.

For the ArraySort problem, you will find two files: [ArraySort.sol](contracts/ArraySort/ArraySort.sol) and [IArraySort.sol](contracts/ArraySort/IArraySort.sol). To solve the `ArraySort` problem, modify the `solve` function in [ArraySort.sol](contracts/ArraySort/ArraySort.sol).


## Step 5: Deploy Your Solution to BVM Chain
To deploy your solution, run the deployment script. For example, to deploy the `ArraySort` solution, use the following command:

```
npx hardhat run scripts/deployArraySort.ts --network zknet
```

*Note: Make sure you have enough funds in your account to deploy the contract.*

## Step 6: Test Your Solution
Following deployment, you will receive the address of the deployed contract. Use this address to test your solution. For example, to test the deployed `ArraySort` solution, use the following command:
```
bash test-arraysort.sh <CONTRACT_ADDRESS>
```
## Step 7: Submit Your Solution
Option 1:
You can submit your solution by using the following command:
```
bash submit.sh <problem_id> <tx_id>
```
Option 2:
Submit your solution on our website [BVMPoC](https://bvm.network/PoC) to participate in the competition.
# Need help?
Join our community on [BVM](https://bvm.network/).