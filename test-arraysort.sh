CONTRACT_ADDRESS=$1
A="[4, 1, 3, 2, 1]"

npx hardhat --network zknet test-arraySort --a "$A" --contract $CONTRACT_ADDRESS