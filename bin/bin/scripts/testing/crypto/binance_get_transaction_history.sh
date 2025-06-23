#!/bin/bash

API_KEY="PqAythDbzRZJ7oCimubWGznYfDqDtzX3ugT3csewpycdkkuI0CXgwUgbIOT26Rzo"
API_SECRET="I6NtHI8fxhRtaF4wtrMcCCou5l9DvBkeWGhg8cnj1gzoIpgckNTBbLcEQl4orXXU"

# Timestamp in milliseconds
timestamp=$(date +%s%3N)

# Symbol for testing
symbol="BTCUSDT"

# Build query string
query_string="symbol=${symbol}&timestamp=${timestamp}"

echo "Query String: $query_string"

# Calculate signature
signature=$(echo -n "$query_string" | openssl dgst -sha256 -hmac "$API_SECRET" | sed 's/^.* //')

echo "Signature: $signature" 

# Full request body
request_body="${query_string}&signature=${signature}"

echo "Request body: $request_body"

# Send the sell order via curl
response=$(curl -s -G "https://testnet.binance.vision/api/v3/myTrades" \
  -H "X-MBX-APIKEY: $API_KEY" \
  --data-urlencode "symbol=${symbol}" \
  --data-urlencode "timestamp=${timestamp}" \
  --data-urlencode "signature=${signature}")

# Echo response 
echo "Response: "
echo "$response" | jq
