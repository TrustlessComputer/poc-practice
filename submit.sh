URL="https://poc.bvm.network/api/contest/submit-tx?problem_id=$1&tx_hash=$2"

RESPONSE=$(curl -s "$URL")

echo $RESPONSE