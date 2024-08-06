# Define the URL with the query parameter
URL="https://api-dojo2.eternalai.org/api/contest/submit-tx?tx_hash=$2?problem_id=$1"

# Make the GET request using curl
RESPONSE=$(curl -s "$URL")

echo $RESPONSE