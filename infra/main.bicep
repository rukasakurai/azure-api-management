targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (used for resource naming)')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Resource group name
var resourceGroupName = 'rg-${environmentName}'

// Create the resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// Deploy the API Management resources
module resources 'resources.bicep' = {
  name: 'resources'
  scope: resourceGroup
  params: {
    environmentName: environmentName
    location: location
  }
}

// Outputs
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output APIM_NAME string = resources.outputs.apimName
output APIM_GATEWAY_URL string = resources.outputs.apimGatewayUrl
output API_ENDPOINT string = resources.outputs.apiEndpoint
