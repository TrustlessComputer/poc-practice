# Define the URL with the query parameter
URL="https://api-dojo2.eternalai.org/api/contest/submit-tx?problem_id=$1&tx_hash=$2"

# Make the GET request using curl
RESPONSE=$(curl -s "$URL")

echo $RESPONSE