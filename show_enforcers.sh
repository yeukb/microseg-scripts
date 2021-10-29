#!/bin/bash

source ./config

credentials="{\"username\":\"$access_key\", \"password\":\"$secret_key\"}"
PRISMA_TOKEN=`curl -s -H "Content-Type: application/json" -d "$credentials" https://$prisma_api_endpoint/login | jq -r .token`

aporeto_credentials="{\"metadata\":{\"token\":\"$PRISMA_TOKEN\"},\"realm\":\"PCIdentityToken\",\"validity\":\"720h\"}"
APORETO_TOKEN=`curl -s -H "Content-Type: application/json" -d "$aporeto_credentials" https://$aporeto_endpoint/issue | jq -r .token`

curl -s -X GET \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $APORETO_TOKEN" \
    -H "X-Namespace: $namespace" \
    -H "Authority: $aporeto_endpoint" \
    https://$aporeto_endpoint/enforcers?recursive=true
