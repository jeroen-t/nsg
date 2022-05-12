#!/bin/bash

unset networkSecurityGroup
unset resourceGroup
unset subscriptionId

usage() {
  echo "Usage: $0 [ -e environment ] [ -n networkSecurityGroup ] [ -r resourceGroup ]" 1>&2 
}

exit_abnormal() {
  usage
  exit 1
}

while getopts e:n:r: flag; do
    case "${flag}" in
        e) environment=${OPTARG};;
        n) networkSecurityGroup=${OPTARG};;
        r) resourceGroup=${OPTARG};;
        *) 
            echo "Invalid option: -$flag" >&2
            exit_abnormal
            ;;
    esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "$environment" ] || [ -z "$networkSecurityGroup" ] || [ -z "$resourceGroup" ] || [ -z "$subscriptionId" ]; then
        echo 'Missing arguments. Please provide values for [e]nvironment, [n]etworkSecurityGroup and [r]esourceGroup.' >&2
        exit 1
fi

subscriptionId=$(az account show --query 'id' -o tsv)
uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Network/networkSecurityGroups/$networkSecurityGroup?api-version=2021-08-01"

# call nsg api, remove unneeded properties from response and only store the custom security rules
secRules=$(az rest --method get --uri $uri | jq 'del(.properties.securityRules[] | .id, .etag, .type, .properties.provisioningState, .properties.priority) | .properties.securityRules')

# add custom security rules to a deployment parameter ARM template
jq --argjson input "$format" '.parameters.securityRules.value += $input' template.parameters.json > "$environment.parameters.json"