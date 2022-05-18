#!/bin/bash
set -e
unset subscriptionId
unset networkSecurityGroup
unset resourceGroup

function usage() {
  echo '
    This program outputs the custom security rules for a given Azure Network Security Group (NSG) in an ARM deployment parameter template.

    -n [networkSecurityGroup] - the Network Security Group name
    -r [resourceGroup]        - the Resource Group name
  
    example: ./'$(basename "$0")' -n Nsg1 -r ResourceGroup1
  '
}

while getopts 'n:r:' flag; do
    case "${flag}" in
        n) networkSecurityGroup=${OPTARG};;
        r) resourceGroup=${OPTARG};;
        *) 
            usage
            exit 1
            ;;
    esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "$networkSecurityGroup" ] || [ -z "$resourceGroup" ]; then
        echo 'WARNING: Missing arguments. Please provide values for [n]etworkSecurityGroup and [r]esourceGroup.' >&2
        usage
        exit 1
fi

subscriptionId=$(az account show --query "id" -o tsv)

# call nsg api, remove unneeded properties from response and only store the custom security rules
uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Network/networkSecurityGroups/$networkSecurityGroup?api-version=2021-08-01"
securityRules=$(az rest --method get --uri $uri | jq 'del(.properties.securityRules[] | .id, .etag, .type, .properties.provisioningState, .properties.priority) | .properties.securityRules')
if [ -z "$securityRules" ]; then
        exit 1
fi

# add custom security rules to a deployment parameter ARM template
jq --argjson input "$securityRules" '.parameters.securityRules.value += $input' template.parameters.json > "$networkSecurityGroup.parameters.json"