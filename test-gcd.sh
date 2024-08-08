CONTRACT_ADDRESS=$1
A=24
B=30

npx hardhat --network zknet test-gcd --a $A --b $B --contract $CONTRACT_ADDRESS