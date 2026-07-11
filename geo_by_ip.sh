#!/bin/bash

DOWNLOAD_URL="https://stedolan.github.io/jq/download/"


if  ! command -v jq &> /dev/null; then
    echo "❌ jq is not installed."
    echo "👉 You can download it here: $DOWNLOAD_URL"
    exit 1
else
    echo "✅ jq is installed."
fi

if [ $# -gt 1 ] || [ $# -lt 1 ]; then
     echo "The script is expected a single argument only, but got $#."
    exit 1
fi

ip_address=$1

if [ "${ip_address}" = "127.0.0.1" ]; then
    echo "${ip_address} is not a valid address"
    exit 1
fi

REQUEST=$(curl -s http://ip-api.com/json/"${ip_address}")

status=$(echo "$REQUEST" | jq -r '.status')

if [ "$status" != "success" ]; then
    echo "Failed to retrieve geo-location information."
    exit 1
fi

country=$(echo "$REQUEST" | jq -r '.country')
city=$(echo "$REQUEST" | jq -r '.city')
regionName=$(echo "$REQUEST" | jq -r '.regionName')

echo "Country: $country"
echo "City: $city"
echo "Region: $regionName"

