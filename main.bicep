param location string = resourceGroup().location
param nsgName string
param securityRules array

var securityRulesVar = [for (securityRule, i) in securityRules: {
  name: securityRule.name
  properties: {
    priority: 100 + i
    protocol: securityRule.properties.protocol
    access: securityRule.properties.access
    direction: securityRule.properties.direction
    sourcePortRange: contains(securityRule.properties, 'sourcePortRange') ? securityRule.properties.sourcePortRange : ''
    sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges') ? securityRule.properties.sourcePortRanges : []
    destinationPortRange: contains(securityRule.properties, 'destinationPortRange') ? securityRule.properties.destinationPortRange : ''
    destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges') ? securityRule.properties.destinationPortRanges : []
    sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix') ? securityRule.properties.sourceAddressPrefix : ''
    destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix') ? securityRule.properties.destinationAddressPrefix : ''
    sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes') ? securityRule.properties.sourceAddressPrefixes : []
    destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes') ? securityRule.properties.destinationAddressPrefixes : []
  }
}]

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: securityRulesVar
  }
}
