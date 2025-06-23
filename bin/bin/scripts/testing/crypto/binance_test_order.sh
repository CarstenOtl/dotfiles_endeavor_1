#!/bin/bash

API_KEY="PqAythDbzRZJ7oCimubWGznYfDqDtzX3ugT3csewpycdkkuI0CXgwUgbIOT26Rzo"
API_SECRET="I6NtHI8fxhRtaF4wtrMcCCou5l9DvBkeWGhg8cnj1gzoIpgckNTBbLcEQl4orXXU"

# Input JSON file containing array of orders
INPUT_FILE="orders.json"

# Read the whole JSON array
orders=$(cat "$INPUT_FILE")

# Get length of array
len=$(echo "$orders" | jq length)

echo "Processing $len orders..."

for (( i=0; i<len; i++ ))
do
  # Extract each order's fields using jq
  symbol=$(echo "$orders" | jq -r ".[$i].symbol")
  quantity=$(echo "$orders" | jq -r ".[$i].quantity")
  
  # Timestamp in milliseconds
  timestamp=$(date +%s%3N)
  
  # Build query string
  query_string="symbol=${symbol}&side=SELL&type=MARKET&quantity=${quantity}&timestamp=${timestamp}"
  
  # Calculate signature
  signature=$(echo -n "$query_string" | openssl dgst -sha256 -hmac "$API_SECRET" | sed 's/^.* //')
  
  # Full request body
  request_body="${query_string}&signature=${signature}"
  
  # Send the sell order via curl
  response=$(curl -s -X POST "https://testnet.binance.vision/api/v3/order" \
    -H "X-MBX-APIKEY: $API_KEY" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "$request_body")
  
  echo "Order $((i+1)) for $symbol: $response"
  
  # Optional: sleep for a short time to avoid rate limits
  sleep 0.1
done
