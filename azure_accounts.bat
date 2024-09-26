@echo off
setlocal

:: Define variables
set RESOURCE_GROUP_NAME=na-resource-group08
set STORAGE_ACCOUNT_NAME=heydevopsterraformtstate
set CONTAINER_NAME=tstate
set LOCATION=eastus

:: Login to Azure
az login

:: Check if Resource Group exists
for /f "delims=" %%i in ('az group exists --name %RESOURCE_GROUP_NAME%') do set RG_EXISTS=%%i

if "%RG_EXISTS%"=="true" (
  echo Resource Group %RESOURCE_GROUP_NAME% already exists.
) else (
  echo Creating Resource Group %RESOURCE_GROUP_NAME%...
  az group create --name %RESOURCE_GROUP_NAME% --location %LOCATION%
)

:: Check if Storage Account exists
for /f "delims=" %%i in ('az storage account check-name --name %STORAGE_ACCOUNT_NAME% --query "nameAvailable" --output tsv') do set NAME_AVAILABLE=%%i

if "%NAME_AVAILABLE%"=="true" (
  echo Creating Storage Account %STORAGE_ACCOUNT_NAME%...
  az storage account create --name %STORAGE_ACCOUNT_NAME% --resource-group %RESOURCE_GROUP_NAME% --location %LOCATION% --sku Standard_LRS
) else (
  echo Storage Account %STORAGE_ACCOUNT_NAME% already exists.
)

:: Retrieve Storage Account Key
for /f "delims=" %%i in ('az storage account keys list --resource-group %RESOURCE_GROUP_NAME% --account-name %STORAGE_ACCOUNT_NAME% --query "[0].value" --output tsv') do set STORAGE_ACCOUNT_KEY=%%i

:: Check if Blob Container exists
for /f "delims=" %%i in ('az storage container list --account-name %STORAGE_ACCOUNT_NAME% --account-key %STORAGE_ACCOUNT_KEY% --query "[?name=='%CONTAINER_NAME%']" --output tsv') do set CONTAINER_EXISTS=%%i

echo %CONTAINER_EXISTS% | findstr /c:"%CONTAINER_NAME%" >nul
if %errorlevel% == 0 (
  echo Blob Container %CONTAINER_NAME% already exists.
) else (
  echo Creating Blob Container %CONTAINER_NAME%...
  az storage container create --name %CONTAINER_NAME% --account-name %STORAGE_ACCOUNT_NAME% --account-key %STORAGE_ACCOUNT_KEY%
)

:: Output Information
echo Container Name: %CONTAINER_NAME%
echo Storage Account Name: %STORAGE_ACCOUNT_NAME%
echo Account Key: %STORAGE_ACCOUNT_KEY%

endlocal
