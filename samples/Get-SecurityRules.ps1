param(
    [ValidateSet('Dev', 'QA1', 'QA2')]
    [string]$Environment
)

$subscriptionId = az account show --query 'id' -o tsv

switch ($Environment) {
    'Dev' {
        $ResourceGroupName = ''
        $NetworkSecurityGroupName = ''
    }
    'QA1' {
        $ResourceGroupName = ''
        $NetworkSecurityGroupName = ''
    }
    'QA2' {
        $ResourceGroupName = ''
        $NetworkSecurityGroupName = ''
    }
}


Param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$NetworkSecurityGroupName
)



$uri = 'https://management.azure.com/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Network/networkSecurityGroups/{2}/?api-version=2021-08-01' -f $subscriptionId, $ResourceGroupName, $NetworkSecurityGroupName
$path = '{0}.json' -f $NetworkSecurityGroupName

# export the nsg in json using rest api, remove unnecessary properties and export only the security rules
az rest --method get --uri $uri |
    jq 'del(.properties.securityRules[] | .etag, .id, .type, .properties.provisioningState, .properties.priority ) | .properties.securityRules[]' |
    Out-File -Path $path

#$format = Get-Content $path -Raw
##jq --argjson input "$format" '.parameters.securityRules.value += $input' template.parameters.json > "$Environment.parameters.json"

$temp = jq --slurpfile input $path '.parameters.securityRules.value += $input' template.parameters.json
Set-Content -Path $path -Value $temp

#$temp | Out-File "$Environment.parameters.json"

#jq --slurpfile temp temp.obj '. + $temp' stats.json