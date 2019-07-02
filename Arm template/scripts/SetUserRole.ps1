function Start-ImmersionPostDeployScript {
    param(
        $Credentials,
        $TenantId,
        $Region,
        $UserEmail,
        $UserPassword,
        $resourceGroupName,
        $StorageAccountName
    )

    function AssignUserRole ($RoleDefinitionName) {
        Write-Verbose "Assigning role '$RoleDefinitionName' to $UserEmail"
        if(!(Get-AzureRmRoleAssignment -SignInName $UserEmail -resourceGroupName $resourceGroupName -RoleDefinitionName $RoleDefinitionName)) {
            New-AzureRmRoleAssignment -SignInName $UserEmail -resourceGroupName $resourceGroupName -RoleDefinitionName $RoleDefinitionName | Out-Null
        }
        else {
            Write-Warning "Role '$RoleDefinitionName' already assigned!"
        }
    }

	function AssignUserRoleAtResourceLevel ($RoleDefinitionName, $ResourceName, $ResourceType, $resourceGroupName) {
        Write-Verbose "Assigning role '$RoleDefinitionName' to $UserEmail"
        if(!(Get-AzureRmRoleAssignment -SignInName $UserEmail -resourceGroupName $resourceGroupName -RoleDefinitionName $roleDefinition -ResourceName $resourceName -ResourceType $resourceType)) {
            
            $user = Get-AzureRmADUser -Mail $UserEmail

            New-AzureRmRoleAssignment -ObjectId $user.Id -RoleDefinitionName $RoleDefinitionName -ResourceName $ResourceName `
            -ResourceType $ResourceType -ResourceGroupName $resourceGroupName | Out-Null
        }
        else {
            Write-Warning "Role '$RoleDefinitionName' already assigned!"
        }
    } 

    #Assign roles required for the current story
    #New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'Contributor'
	New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'DocumentDB Account Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'Search Service Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'Storage Account Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'SQL DB Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'SQL Security Manager'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'SQL Server Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'Website Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName 'Web Plan Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName '[Hands-on Labs] Sql Server Data Masking Contributor'
    New-AzureRmRoleAssignment -SignInName $UserEmail -ResourceGroupName $ResourceGroupName -RoleDefinitionName '[Hands-on Labs] Data Lake Contributor'

      	  
	#Assign contributor access to Databrick workspace
	$resourceType = "Microsoft.Databricks/workspaces"
	$resourceName = "databrickws"+$resourceGroupName 
	$roleDefinition = "Contributor"

	AssignUserRoleAtResourceLevel -RoleDefinitionName $roleDefinition -ResourceName $resourceName -ResourceType $resourceType -resourceGroupName $resourceGroupName 


	#####################################################################
	# DataLake - Setup Folders
	#####################################################################
	Write-Output "DataLake-START"

	# DataLakeName
	$dataLakeStorageGen1Name = "datalake$resourceGroupName"
	Write-Output "dataLakeStorageGen1Name set to $dataLakeStorageGen1Name"

	Write-Output "Set permissions on datalake"
	Set-AzureRmDataLakeStoreItemOwner -AccountName "$dataLakeStorageGen1Name" -Path / -Type User -Id (Get-AzureRmADUser -Mail "$UserEmail").Id

	<#
	# Create DataLake Folders
	Write-Output "Create DataLake Folders"

	New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/01/ --force
	New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/03/ --force
	New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/Latest/ --force
	#>

	<#
	az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/2019/01/ --folder --force
	az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/2019/03/ --folder --force
	az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/Latest/ --folder --force
	#>

	Write-Output "DataLake-END"
	#####################################################################



}