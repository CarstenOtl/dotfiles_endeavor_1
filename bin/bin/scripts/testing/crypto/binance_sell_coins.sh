#!/bin/bash

API_KEY="PqAythDbzRZJ7oCimubWGznYfDqDtzX3ugT3csewpycdkkuI0CXgwUgbIOT26Rzo"
API_SECRET="I6NtHI8fxhRtaF4wtrMcCCou5l9DvBkeWGhg8cnj1gzoIpgckNTBbLcEQl4orXXU"

echo "Processing $len orders..."

# symbol
symbol="XECUSDT"
quantity="18446"

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

