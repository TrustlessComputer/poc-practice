CONTRACT_ADDRESS=$1
A="[5, 7, 3, 2, 8]"
U="[0, 1, 2, 3]"
V="[4, 2, 3, 1]"

npx hardhat --network zknet test-library --a "$A" --u "$U" --v "$V" --contract $CONTRACT_ADDRESS