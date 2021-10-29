#!/bin/bash

# docs for /reportsqueries endpoint
# https://docs.aporeto.com/saas/microseg-console-api/visualization/

# Flows | Enforcers | EventLogs | Packets | Counters | DNSLookups | ConnectionExceptions
LOG_TYPE=Flows
DURATION=24h

source ./config

credentials="{\"username\":\"$access_key\", \"password\":\"$secret_key\"}"
PRISMA_TOKEN=`curl -s -H "Content-Type: application/json" -d "$credentials" https://$prisma_api_endpoint/login | jq -r .token`

aporeto_credentials="{\"metadata\":{\"token\":\"$PRISMA_TOKEN\"},\"realm\":\"PCIdentityToken\",\"validity\":\"720h\"}"
APORETO_TOKEN=`curl -s -H "Content-Type: application/json" -d "$aporeto_credentials" https://$aporeto_endpoint/issue | jq -r .token`

curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $APORETO_TOKEN" \
    -H "X-Namespace: $namespace" \
    -H "Authority: $aporeto_endpoint" \
    -d "{\"report\":\"$LOG_TYPE\"}" \
    "https://$aporeto_endpoint/reportsqueries?startRelative=$DURATION&recursive=true&order=-timestamp"
