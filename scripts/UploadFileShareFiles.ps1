# Start the transcript
$time = Get-Date -format "yyyyMMddhhmm"
Start-Transcript -Path "c:\temp\UploadFileShareFiles_$time.log"

Set-ExecutionPolicy unrestricted -Force

# Set the Azure credentials
Write-Output "Set the Azure credentials"
$Username = Get-Content -Path "c:\temp\Username.txt" 
$password = Get-Content -Path "c:\temp\password.txt" 
$rg = Get-Content -Path "c:\temp\rg.txt"
[ValidateNotNullOrEmpty()]$secpasswd = $password
$email = Get-Content -Path "c:\temp\email.txt" 
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $email,$securePassword

$subscriptionId = Get-Content -Path "c:\temp\subid.txt" 
if($subscriptionId -match "/"){
    $subSplit = $subscriptionId.Split("/")
    foreach($sub in $subSplit){
        if($sub -match "{.{8}-.{4}-.{4}-.{4}-"*""){
            $subscriptionId = $sub
        }
    }
}



#####################################################################

# Log in to Azure
Write-Output "Log in to Azure"
Login-AzureRmAccount -Credential $creds -SubscriptionId $subscriptionId
#az login -u $email -p $password
#az account set --subscription $subscriptionId

#####################################################################
# DataLake - Setup Folders and upload Files
#####################################################################
Write-Output "DataLake-START"

# https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-get-started-powershell

# DataLakeName
$dataLakeStorageGen1Name = "datalake$rg"
Write-Output "dataLakeStorageGen1Name set to $dataLakeStorageGen1Name"

# Create DataLake Folders
Write-Output "Create DataLake Folders"

# Set permissions

#Get-AzureRmDataLakeStoreItemAclEntry -AccountName "ContosoADL" -Path /Folder1
#Set-AzureRmDataLakeStoreItemAcl -AccountName "ContosoADL" -Path "/Folder2" -Acl $ACL -Recurse -Concurrency 128

#$user = "test219887@cloudplatimmersionlabs.onmicrosoft.com"
#Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStorageGen1Name -Path '/' -AceType User -Id (Get-AzureRmADUser -Mail $user).Id -Permissions All -Default

#az dls fs access show --account datalakerg219887 --path /
#az dls fs access set-permission --account datalakerg219887 --path / --permission 777

New-azurermDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/Latest/ --force
Start-Sleep -Second 5
New-azurermDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/01/ --force
Start-Sleep -Second 5
New-azurermDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/03/ --force

<#
New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/01/ --force
New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/03/ --force
New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/Latest/ --force
#>
<#
az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/2019/01/ --folder --force
az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/2019/03/ --folder --force
az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/Latest/ --folder --force
#>

# Upload Files to DataLake
Write-Output "Upload Files to DataLake"

Import-azurermDataLakeStoreItem -AccountName $dataLakeStorageGen1Name -Path "C:\Temp\BooksEditions-DailySnapshot-20190302.csv" -Destination "/BackEnd/Books/Editions/2019/03/BooksEditions-DailySnapshot-20190302.csv" -Force
Import-azurermDataLakeStoreItem -AccountName $dataLakeStorageGen1Name -Path "C:\Temp\BooksEditions-DailySnapshot-Latest.orc" -Destination "/BackEnd/Books/Editions/Latest/BooksEditions-DailySnapshot-Latest.orc" -Force

#Import-AzDataLakeStoreItem -AccountName $dataLakeStorageGen1Name -Path "C:\Temp\BooksEditions-DailySnapshot-20190302.csv" -Destination "/BackEnd/Books/Editions/2019/03/BooksEditions-DailySnapshot-20190302.csv" -Force
#Import-AzDataLakeStoreItem -AccountName $dataLakeStorageGen1Name -Path "C:\Temp\BooksEditions-DailySnapshot-Latest.orc" -Destination "/BackEnd/Books/Editions/Latest/BooksEditions-DailySnapshot-Latest.orc" -Force

#az dls fs upload --account $dataLakeStorageGen1Name --source-path "C:\Temp\BooksEditions-DailySnapshot-20190302.csv" --destination-path "/BackEnd/Books/Editions/2019/03/BooksEditions-DailySnapshot-20190302.csv" --overwrite
#az dls fs upload --account $dataLakeStorageGen1Name --source-path "C:\Temp\BooksEditions-DailySnapshot-Latest.orc" --destination-path "/BackEnd/Books/Editions/Latest/BooksEditions-DailySnapshot-Latest.orc" --overwrite


#####################################################################
# Restore Datawarehouse
#####################################################################
Write-Output "Restore Datawarehouse-START"

# Configuration
$sqlserver  = "azuresql-$rg.database.windows.net"
$database     = "DataWarehouse-$rg"
Write-Output "Username set to $Username"
Write-Output "PlainPassword set to $password"
Write-Output "resourceGroupName set to $rg"
Write-Output "sqlserver set to $sqlserver"
Write-Output "database set to $database"

Write-Output "sqlcmd restore DWscript_BookBeat.sql $(get-date)"
sqlcmd -U $Username -P "$password" -S tcp:$sqlserver,1433 -d $database -I -i C:\temp\DWscript_BookBeat.sql

Write-Output "Restore Datawarehouse-END"

#####################################################################

Stop-Transcript