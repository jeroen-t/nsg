param location string = resourceGroup().location
param nsgName string
param securityRules array
param tags object

var securityRuleArray = [for (securityRule, i) in securityRules: {
  name: securityRule.name
  properties: {
    access: securityRule.properties.access
    description: contains(securityRule.properties, 'description') ? securityRule.properties.description : ''
    destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix') ? securityRule.properties.destinationAddressPrefix : ''
    destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes') ? securityRule.properties.destinationAddressPrefixes : []
    destinationApplicationSecurityGroups: contains(securityRule.properties, 'destinationApplicationSecurityGroups') ? securityRule.properties.destinationApplicationSecurityGroups : []
    destinationPortRange: contains(securityRule.properties, 'destinationPortRange') ? securityRule.properties.destinationPortRange : ''
    destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges') ? securityRule.properties.destinationPortRanges : []
    direction: securityRule.properties.direction
    priority: securityRule.properties.priority
    protocol: securityRule.properties.protocol
    sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix') ? securityRule.properties.sourceAddressPrefix : ''
    sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes') ? securityRule.properties.sourceAddressPrefixes : []
    sourceApplicationSecurityGroups: contains(securityRule.properties, 'sourceApplicationSecurityGroups') ? securityRule.properties.sourceApplicationSecurityGroups : []
    sourcePortRange: contains(securityRule.properties, 'sourcePortRange') ? securityRule.properties.sourcePortRange : ''
    sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges') ? securityRule.properties.sourcePortRanges : []
  }
}]

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: securityRuleArray
  }
}
