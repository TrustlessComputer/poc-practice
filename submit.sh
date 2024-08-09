echo "Submitting transaction $2 for problem $1"

URL="https://poc.bvm.network/api/contest/submit-tx?problem_id=$1&tx_hash=$2"

RESPONSE=$(curl -s "$URL")

echo $RESPONSE