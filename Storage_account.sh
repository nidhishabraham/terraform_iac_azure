# Define variables
RESOURCE_GROUP_NAME="na-resource-group08"
STORAGE_ACCOUNT_NAME="heydevopsterraformtstate"
CONTAINER_NAME="tstate"
LOCATION="eastus"

# Login to Azure
az login

# Check if Resource Group exists
if az group exists --name $RESOURCE_GROUP_NAME; then
  echo "Resource Group $RESOURCE_GROUP_NAME already exists."
else
  echo "Creating Resource Group $RESOURCE_GROUP_NAME..."
  az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
fi

# Check if Storage Account exists
if az storage account check-name --name $STORAGE_ACCOUNT_NAME --query "nameAvailable" --output tsv; then
  echo "Creating Storage Account $STORAGE_ACCOUNT_NAME..."
  az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku Standard_LRS
else
  echo "Storage Account $STORAGE_ACCOUNT_NAME already exists."
fi

# Retrieve Storage Account Key
STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' --output tsv)

# Check if Blob Container exists
if az storage container list --account-name $STORAGE_ACCOUNT_NAME --account-key $STORAGE_ACCOUNT_KEY --query "[?name=='$CONTAINER_NAME']" --output tsv | grep -q "$CONTAINER_NAME"; then
  echo "Blob Container $CONTAINER_NAME already exists."
else
  echo "Creating Blob Container $CONTAINER_NAME..."
  az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $STORAGE_ACCOUNT_KEY
fi

# Output Information
echo "Container Name: $CONTAINER_NAME"
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Account Key: $STORAGE_ACCOUNT_KEY"