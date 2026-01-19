# Azure API Management Demo

This repository contains Bicep infrastructure code to provision Azure API Management with a simple REST GET API endpoint.

## Features

- Azure API Management instance (Consumption tier)
- REST GET API endpoint at `/hello`
- Returns a constant string: `Hello AI Gateway!`
- No authentication required for the basic example

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Azure Developer CLI (azd)](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd) installed
- An active Azure subscription

## Deployment

### Using Azure Developer CLI

1. **Login to Azure**:
   ```bash
   azd auth login
   ```

2. **Initialize the environment** (first time only):
   ```bash
   azd init
   ```
   When prompted, provide an environment name (e.g., `dev`, `prod`).

3. **Provision the infrastructure**:
   ```bash
   azd provision
   ```
   When prompted, select your Azure subscription and location.

4. **After deployment completes**, the API endpoint URL will be displayed in the outputs.

### Testing the API

Once deployed, you can test the API endpoint:

```bash
curl https://<your-apim-name>.azure-api.net/hello
```

Expected response:
```
Hello AI Gateway!
```

## Project Structure

```
├── azure.yaml              # Azure Developer CLI configuration
├── infra/
│   ├── main.bicep          # Main deployment orchestration
│   ├── main.parameters.json # Parameter file for deployment
│   └── resources.bicep     # API Management resource definitions
└── README.md
```

## Clean Up

To remove all deployed resources:

```bash
azd down
```

## Additional Resources

- [Azure API Management Documentation](https://learn.microsoft.com/en-us/azure/api-management/)
- [Azure Developer CLI Documentation](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)
- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)