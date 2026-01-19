@description('Name of the environment (used for resource naming)')
param environmentName string

@description('Primary location for all resources')
param location string = resourceGroup().location

// Generate a unique suffix for globally unique resource names
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

// API Management instance name (must be globally unique)
var apimName = 'apim-${resourceToken}'

// API Management instance - using Consumption tier for simplicity and cost-effectiveness
resource apim 'Microsoft.ApiManagement/service@2023-09-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'noreply@example.com'
    publisherName: 'API Management Demo'
  }
}

// API definition for the Hello API
resource helloApi 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' = {
  parent: apim
  name: 'hello-api'
  properties: {
    displayName: 'Hello API'
    description: 'A simple REST API that returns a greeting message'
    path: 'hello'
    protocols: [
      'https'
    ]
    subscriptionRequired: false
  }
}

// GET operation for the Hello API
resource helloGetOperation 'Microsoft.ApiManagement/service/apis/operations@2023-09-01-preview' = {
  parent: helloApi
  name: 'get-hello'
  properties: {
    displayName: 'Get Hello'
    description: 'Returns a greeting message'
    method: 'GET'
    urlTemplate: '/'
    responses: [
      {
        statusCode: 200
        description: 'Success'
        representations: [
          {
            contentType: 'text/plain'
          }
        ]
      }
    ]
  }
}

// Policy to return a constant string response
resource helloGetPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2023-09-01-preview' = {
  parent: helloGetOperation
  name: 'policy'
  properties: {
    format: 'xml'
    value: '''
<policies>
  <inbound>
    <base />
    <return-response>
      <set-status code="200" reason="OK" />
      <set-header name="Content-Type" exists-action="override">
        <value>text/plain</value>
      </set-header>
      <set-body>Hello AI Gateway!</set-body>
    </return-response>
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
'''
  }
}

// Outputs
output apimName string = apim.name
output apimGatewayUrl string = apim.properties.gatewayUrl
output apiEndpoint string = '${apim.properties.gatewayUrl}/hello'
