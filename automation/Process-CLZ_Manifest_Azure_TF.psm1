# Function to check for a Tenant Id in the Tenant Google Sheet
Function Test-TenantSheet
{
    Param(
        [string]$manifestPath
    )
    
    $tenantManifest = Import-Excel -path $manifestPath -WorksheetName 'Tenants'
    
    # Verify that a tenant has been defined in the worksheet before continuing with anything else
    if($tenantManifest -and $($tenantManifest[0].'Tenant ID'))
    {
        Write-Host -ForegroundColor Yellow "Found the following Tenants in the manifest:"
        Write-Host ($tenantManifest | Format-Table | Out-String)
        $tenantId = $tenantManifest[0].'Tenant ID'
        
        Write-Host -ForegroundColor Cyan "Verify that this is the correct Tenant information before continuing"
        pause
        return $tenantId
    }
    else
    {
        Write-Host -ForegroundColor Red "Tenant configuration missing in Manifest."
        Write-Host -ForegroundColor Yellow "Would you like to populate the Terraform with the placeholder ""<<>>"" and continue?"
        $choice = Read-Host -Prompt "'Y' or 'y' to continue with placeholder information, any other key to exit the script"
        if(($choice -eq 'y') -or ($choice -eq 'Y'))
        {
            $tenantId = "<<>>"
            return $tenantId
        }
        else
        {
            Write-Host -ForegroundColor Yellow "Exiting..."
            exit 1
        }
    }
}

# Function to check for any blank Subscription Ids in the Subscriptions Google Sheet
Function Test-SubscriptionsSheet
{
    Param(
        [string]$manifestPath
    )
    
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'

    if(($subscriptionsManifest."Subscription ID") -contains $null)
    {
        Write-Host -ForegroundColor Red "The following Subscriptions are missing a Subscription ID in the manifest: "
        Foreach($nullSubId in $($subscriptionsManifest | Where-Object {$null -eq $_.'Subscription ID'}).'Subscription Name')
        {
            $nullSubId
        }
        Write-Host -ForegroundColor Yellow "Would you like to populate the Terraform with the placeholder ""<<>>"" for each missing Subscription ID and continue?"
        $choice = Read-Host -Prompt "'Y' or 'y' to continue with placeholder information, any other key to exit the script"
        if(($choice -ne 'y') -and ($choice -ne 'Y'))
        {
            Write-Host -ForegroundColor Yellow "Exiting..."
            exit 1
        }
    }
}

# Function to Create the directory location for the current Stack
Function Get-StackDir
{
    Param(
        [string]$stackName,
        [string]$stackType
    )
    
    # Check if the Stack folder exists and create it if necessary
    if(!(Get-Item -Path "$PSScriptRoot/../stacks/az-lztf-stacks/Stacks-$($stackType)/$($stackName)" -EA 0))
    {
        try 
        {
            Write-Host "Creating Stack path: ""$PSScriptRoot/../stacks/az-lztf-stacks/Stacks-$stackType/$($stackName)"""
            $stackDir = New-Item -ItemType "directory" -Path "$PSScriptRoot/../stacks/az-lztf-stacks/Stacks-$($stackType)/$($stackName)"
            Write-Host -ForegroundColor Green "Stack Path created successfully!"
        }
        catch 
        {
            Write-Error $_ 
        }            
    }
    else
    {
        Write-Host -ForegroundColor Green "Stack Path: ""$PSScriptRoot/../stacks/az-lztf-stacks/Stacks-$($stackType)/$($stackName)"" already exists! Continuing..."
        $stackDir = Get-Item -Path "$PSScriptRoot/../stacks/az-lztf-stacks/Stacks-$($stackType)/$($stackName)"
    }
    return $stackDir
}

# Function to initialize the Terraform JSON for the current Stack with main.tf.json, locals.tf.json, variables.tf.json, and necessary provider information
Function Initialize-Stack
{
    Param(
        # Parameter for the Terraform Version from the Excel Manifest. If none is provided, use the default
        [string]$terraformVersion = "=3.6.0",
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$tenantId,
        [string]$stackType,
        [string]$stackName
    )
    
    # Get the Stacks, Subscriptions, Regions, and Global Tags sheets from the Manifest
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $regionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Regions'
    $globalTagsManifest = Import-Excel -path $manifestPath -WorksheetName 'Global Tags'

    $stackType = $stackType.ToLower()

    # Create Stack main.tf.json object
    try 
    {
        # Create the root main.tf.json object with base Terraform and Provider Nodes
        $objTerraform = [PSCustomObject]@{
            provider = @{
                azurerm = @(
                    @{
                        features = @{}
                    }
                )
            }            
            terraform = @(
                @{
                    backend = @{
                        azurerm = @{}
                    }
                    required_providers = @(
                        @{
                            azurerm = @{
                                source = "hashicorp/azurerm"
                                version = $terraformVersion
                            }
                        }
                    )
                }
            ) 
        }
        
        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objTerraform | ConvertTo-Json -depth 100 | Out-File "$stackDir/main.tf.json"
        [PSCustomObject]$objTerraform = Get-Content -Path "$stackDir/main.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }
    
    # Create Stack variables.tf.json object
    try 
    {
        $objVariables = [PSCustomObject]@{
            variable = @{}
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
        [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }      
    
    # Create Provider Variables object
    $objProviderVariables = [PSCustomObject]@{}     

    # Create Stack locals.tf.json object
    try 
    {
        # Create the root locals.tf.json object with base Terraform and Provider Nodes
        $objLocals = [PSCustomObject]@{
            locals = @{
                tags = @{}
            }                             
        }
        
        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objLocals | ConvertTo-Json -depth 100 | Out-File "$stackDir/locals.tf.json"
        [PSCustomObject]$objLocals = Get-Content -Path "$stackDir/locals.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
        exit 1
    }

    # Add Tenant Id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Tenant Id to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "tenant_id" -Value $newVariablesMember -Force

    # Append tenant_id to the variables.providers.auto.tfvars.json PSCustomObject            
    $objProviderVariables | Add-Member -MemberType NoteProperty -Name "tenant_id" -Value $tenantId

    # Add hub client id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Hub client id to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "hub_client_id" -Value $newVariablesMember -Force 

    # Add hub client secret to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Hub client secret to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "hub_client_secret" -Value $newVariablesMember -Force

    # Add Hub Subscription Id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Hub Subscription ID to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "hub_subscription_id" -Value $newVariablesMember -Force  

    # Set up hub specific stack provider configuration
    if($stackType -eq 'hub')
    {
        # Add hub node to main.tf.json object for spoke to hub peering authentications
        $newMainMember = [PSCustomObject]@{
            alias           = "hub"
            features        = @{}
            client_id       = "`$`{var.hub_client_id`}"
            client_secret   = "`$`{var.hub_client_secret`}"
            subscription_id = "`$`{var.hub_subscription_id`}"
            tenant_id       = "`$`{var.tenant_id`}"
        }
        # Append new resource node to the Terraform PSCustomObject            
        $objTerraform.provider.azurerm += $newMainMember

        if(($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}).Count -gt 1)
        {
            # Need to account for possibility of multiple subscriptions in a Hub Stack, and query the user as to which Subscription is the *actual* Hub Subscription. This ensures proper Provider configuration in main.tf.json
            do
            {
                Clear-Host
                Write-Host -ForegroundColor Yellow "Multiple Subscriptions are associated with the Hub Stack named: ""$stackName""."
                Write-Host -ForegroundColor Yellow "Please select the Subscription, from the list below, that will serve as the Hub for the other Subscriptions..."

                $subscriptions = ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')})

                for($i=0; $i -lt $subscriptions.Count; $i++ )
                {
                    Write-Host -ForegroundColor Green "$($i): Press `'$($i)`' to select Subscription: ""$($subscriptions[$($i)].'Subscription Name')"" with ID: ""$($subscriptions[$($i)].'Subscription ID')""."
                }

                [int]$menuSelection = Read-Host "`n Enter Selection Number"
                
            }until($menuSelection -ge 0 -and $menuSelection -lt $($subscriptions.Count))
            
            # Verify that a Subscription ID has been defined in the worksheet before continuing with anything else
            if($($subscriptions[$menuSelection].'Subscription ID'))
            {
                $hubSubscriptionId = $($subscriptions[$menuSelection].'Subscription ID')
            }
            else
            {
                $hubSubscriptionId = "<<>>"                
            }            
        }
        else
        {
            # Verify that a Subscription ID has been defined in the worksheet before continuing with anything else
            if(($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')})."Subscription ID")
            {
                $hubSubscriptionId = ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')})."Subscription ID"
            }
            else
            {
                $hubSubscriptionId = "<<>>"                
            }  
        }
        # Append hub_subscription_id to the variables.providers.auto.tfvars.json PSCustomObject            
        $objProviderVariables | Add-Member -MemberType NoteProperty -Name "hub_subscription_id" -Value $hubSubscriptionId
    }
    else
    { 
        # Add hub node to main.tf.json object for spoke to hub peering authentications
        $newMainMember = [PSCustomObject]@{
            alias                       = "hub"
            features                    = @{}
            skip_provider_registration  = "true"
            client_id                   = "`$`{var.hub_client_id`}"
            client_secret               = "`$`{var.hub_client_secret`}"
            subscription_id             = "`$`{var.hub_subscription_id`}"
            tenant_id                   = "`$`{var.tenant_id`}"
        }
        # Append new resource node to the Terraform PSCustomObject            
        $objTerraform.provider.azurerm += $newMainMember                  
    }
    
    #$subscription = ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')})
    # Create a new Provider entry in main.tf.json for each subscription in the Stack, exluding the Hub Subscription we identified earlier in this function
    foreach($subscription in ($subscriptionsManifest | Where-Object {($_.'Stack Name' -eq $($stack.'Stack Name')) -and ($_.'Stack Type' -ne "Hub")}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"
        $providerAlias = "$stackType-$subscriptionName"

        # Create Spoke provider block
        $newMainMember = [PSCustomObject]@{
            alias           = "$($providerAlias)"
            features        = @{}
            client_id       = "`$`{var.$($stackType)_$($subscriptionName)_client_id`}"
            client_secret   = "`$`{var.$($stackType)_$($subscriptionName)_client_secret`}"
            subscription_id = "`$`{var.$($stackType)_$($subscriptionName)_subscription_id`}"
            tenant_id       = "`$`{var.tenant_id`}"
        }
        # Append new resource node to the Terraform PSCustomObject            
        $objTerraform.provider.azurerm += $newMainMember

        # Add client id to variables.tf.json object
        $newVariablesMember = [PSCustomObject]@{
            description = "$($stackType) $($subscriptionName) client id to configure provider"
            type = "string"
            sensitive = "true"
        }
        # Append new resource node to the Variables PSCustomObject
        $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($stackType)_$($subscriptionName)_client_id" -Value $newVariablesMember -Force 

        # Add client secret to variables.tf.json object
        $newVariablesMember = [PSCustomObject]@{
            description = "$($stackType) $($subscriptionName) client secret to configure provider"
            type = "string"
            sensitive = "true"
        }
        # Append new resource node to the Variables PSCustomObject
        $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($stackType)_$($subscriptionName)_client_secret" -Value $newVariablesMember -Force

        # Add Subscription Id to variables.tf.json object
        $newVariablesMember = [PSCustomObject]@{
            description = "$($stackType) $($subscriptionName) Subscription ID to configure provider"
            type = "string"
            sensitive = "true"
        }
        # Append new resource node to the Variables PSCustomObject
        $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($stackType)_$($subscriptionName)_subscription_id" -Value $newVariablesMember -Force

        # Verify that a Subscription ID has been defined in the worksheet before continuing with anything else
        if($($subscription.'Subscription ID'))
        {
            # Append Subscription_id to the locals PSCustomObject            
            $objProviderVariables | Add-Member -MemberType NoteProperty -Name "$($stackType)_$($subscriptionName)_subscription_id" -Value "$($subscription.'Subscription ID')"
        }
        else
        {
            $objProviderVariables | Add-Member -MemberType NoteProperty -Name "$($stackType)_$($subscriptionName)_subscription_id" -Value "<<>>"            
        }        
    }

    $arLocals = @{business_unit = "$($stack.'Business Unit')"; environment = "$($stack.'Environment')"; primary_location = "$($stack.'Primary Region')"; secondary_location = "$($stack.'Secondary Region')"; primary_short_location = $(($regionsManifest | Where-Object {$_.Region -eq $stack.'Primary Region'}).'Region Short Name'); secondary_short_location = $(($regionsManifest | Where-Object {$_.Region -eq $stack.'Secondary Region'}).'Region Short Name')}

    # Populate locals.tf.json variables file
    $arLocals.GetEnumerator() | ForEach-Object {  
        $objLocals.locals | Add-Member -MemberType NoteProperty -Name "$($_.Key)" -Value "$($_.Value)" -Force
        
    }

    # Populate tags node of locals.tf.json
    foreach($tag in ($globalTagsManifest | Where-Object {$_.Stack -eq $stack.'Stack Name'}))
    {
        if($($tag.'Tag Name') -eq "environment" -or $($tag.'Tag Name') -eq "env")
        {
            $objLocals.locals.tags | Add-Member -MemberType NoteProperty -Name "$($tag.'Tag Name')" -Value "`$`{local.environment`}" -Force
        }
        else{$objLocals.locals.tags | Add-Member -MemberType NoteProperty -Name "$($tag.'Tag Name')" -Value "$($tag.'Tag Value')" -Force}
    }

    # Create Stack data.tf.json object
    try 
    {
        $objDataVars = [PSCustomObject]@{
            data = @{
                azurerm_client_config = @{
                    current = @()
                }                
            }
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objDataVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/data.tf.json"
        [PSCustomObject]$objDataVars = Get-Content -Path "$stackDir/data.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }          

    # Write the Stack data.tf.json file to the appropriate Stack folder
    $objDataVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/data.tf.json"

    # Write the Stack main.tf.json file to the appropriate Stack folder
    $objTerraform | ConvertTo-Json -depth 100 | Out-File "$stackDir/main.tf.json"

    # Write the Stack variables.tf.json file to the appropriate Stack folder        
    $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"

    # Write the Stack locals.tf.json file to the appropriate Stack folder      
    $objProviderVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.providers.auto.tfvars.json"

    # Write the Stack locals.tf.json file to the appropriate Stack folder      
    $objLocals | ConvertTo-Json -depth 100 | Out-File "$stackDir/locals.tf.json"
    
}

# Function to initialize the Governance Stack
Function Initialize-GovernanceStack
{
    Param(
        # Parameter for the Terraform Version from the Excel Manifest. If none is provided, use the default
        [string]$terraformVersion = "=2.91.0",
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$tenantId
    )
    
    # Create Stack main.tf.json object
    try 
    {
        # Create the root main.tf.json object with base Terraform and Provider Nodes
        $objTerraform = [PSCustomObject]@{
            provider = @{
                azurerm = @(
                    @{
                        features = @{}
                    }
                )
            }            
            terraform = @(
                @{
                    backend = @{
                        azurerm = @{}
                    }
                    required_providers = @(
                        @{
                            azurerm = @{
                                source = "hashicorp/azurerm"
                                version = $terraformVersion
                            }
                        }
                    )
                }
            ) 
        }
        
        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objTerraform | ConvertTo-Json -depth 100 | Out-File "$stackDir/main.tf.json"
        [PSCustomObject]$objTerraform = Get-Content -Path "$stackDir/main.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }

    # Create Provider Variables object
    $objProviderVariables = [PSCustomObject]@{}

    # Append tenant_id to the variables.providers.auto.tfvars.json PSCustomObject            
    $objProviderVariables | Add-Member -MemberType NoteProperty -Name "tenant_id" -Value $tenantId

    # Create Stack variables.tf.json object
    try 
    {
        $objVariables = [PSCustomObject]@{
            variable = @{}
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
        [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }            

    # Create new entry for governance client configuration data
    $newMainMember = [PSCustomObject]@{
        alias                       = "governance"
        features                    = @{}
        skip_provider_registration  = "true"
        client_id                   = "`$`{var.governance_client_id`}"
        client_secret               = "`$`{var.governance_client_secret`}"
        subscription_id             = "`$`{var.governance_subscription_id`}"
        tenant_id                   = "`$`{var.governance_tenant_id`}"
    }
    # Append new resource node to the Terraform PSCustomObject
    $objTerraform.provider.azurerm += $newMainMember

    # Add governance id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Governance client id to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "governance_client_id" -Value $newVariablesMember -Force 

    # Add governance secret to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Governance client secret to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "governance_client_secret" -Value $newVariablesMember -Force

    # Add governance subscription id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Governance Subscription id to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "governance_subscription_id" -Value $newVariablesMember -Force 

    # Add governance tenant id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Governance tenant id to configure provider"
        type = "string"
        sensitive = "true"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "governance_tenant_id" -Value $newVariablesMember -Force

    # Create Stack data.tf.json object
    try 
    {
        $objDataVars = [PSCustomObject]@{
            data = @{
                azurerm_client_config = @{
                    current = @()
                }
                azurerm_subscription = @{
                    current = @()
                    policy_testing = @(@{
                        subscription_id = ""
                    })
                }
            }
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objDataVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/data.tf.json"
        [PSCustomObject]$objDataVars = Get-Content -Path "$stackDir/data.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }          

    # Write the Stack data.tf.json file to the appropriate Stack folder
    $objDataVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/data.tf.json"   

    # Write the Stack main.tf.json file to the appropriate Stack folder
    $objTerraform | ConvertTo-Json -depth 100 | Out-File "$stackDir/main.tf.json"

    # Write the Stack variables.tf.json file to the appropriate Stack folder        
    $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"

    # Write the Stack variables.providers.auto.tfvars.json file to the appropriate Stack folder      
    $objProviderVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.providers.auto.tfvars.json"
}

# Function to create Management Group Configurations
Function Set-ManagementGroups
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir
    )
    
    # Get Management Groups sheet from the Manifest
    $mgmtGroupsManifest = Import-Excel -path $manifestPath -WorksheetName 'Management Groups'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    
    # Get existing variables.tf.json object
    [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100
    
    # Create Stack module.management-groups.tf.json object
    try 
    {
        $objMgmtGroupModule = [PSCustomObject]@{
            module = @{
                management_groups = @(
                    @{
                        source = "../../../modules/az-lztf-mod-managementgroups/"
                        providers = @{
                            azurerm = "azurerm.governance"
                        }

                        management_groups           = "`$`{var.management_groups`}"
                        parent_management_group_id  = "`$`{var.parent_management_group_id`}"
                    }
                )
            }
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objMgmtGroupModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.management-groups.tf.json"
        [PSCustomObject]$objMgmtGroupModule = Get-Content -Path "$stackDir/module.management-groups.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }            

    # Add management groups to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Collection of Management Groups to configure"
        type = "object({name = string, display_name = string, subscription_ids = list(string), children = list(any)})"
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "management_groups" -Value $newVariablesMember -Force

    # Add Root Management Group Id to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "Management group id where the MG hierarchy starts"
        type = "string"
        default = ""
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "parent_management_group_id" -Value $newVariablesMember -Force

    # Create Stack variables.management-groups.auto.tfvars object
    try
    {
        # Create the root variables.management-groups.auto.tfvars object
        $objMgmtGroupVars = [PSCustomObject]@{
        }
        
        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objMgmtGroupVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.management-groups.auto.tfvars.json"
        [PSCustomObject]$objMgmtGroupVars = Get-Content -Path "$stackDir/variables.management-groups.auto.tfvars.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
        exit 1
    }

    Function Set-MgmtGroupHierarchy
    {
        Param(
            [string]$ParentMgmtGroup,
            [PSCustomObject]$mgmtGroupVarMember,
            [PSCustomObject]$mgmtGroupManifest
        )

        # Loop recursively through each of the Management Groups in the manifest to create the Parent Child relationship objects
        foreach($child in ($mgmtGroupsManifest | Where-Object {$_.'Parent Management Group Name' -eq $($ParentMgmtGroup)}))
        {
            $subscriptionIds = @()
            foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Management Group' -eq "$($child.'Management Group Name')" }))
            {
                if($null -eq $($subscription.'Subscription ID'))
                {
                    $subscriptionIds += "<<>>"
                }
                else
                {
                    $subscriptionIds += "$($subscription.'Subscription ID')"
                }
            }
            # Create the new child object for the current Parent object
            $mgmtGroupName = $($child.'Management Group Name').replace(' ','')
            $newMgmtGroupVarMember = [PSCustomObject]@{
                name                = $mgmtGroupName
                display_name        = "$($child.'Management Group Name')"
                subscription_ids    = @($($subscriptionIds))
                children            = @()
            }
            # Append new resource node to the Variables PSCustomObject
            $mgmtGroupVarMember.children += $newMgmtGroupVarMember

            # Check if the current Child node has any children, and if it does, call this same function recursively to process the children
            if(($mgmtGroupsManifest | Where-Object {$_.'Parent Management Group Name' -eq $($child.'Management Group Name')}))
            {
                Set-MgmtGroupHierarchy -ParentMgmtGroup $($child.'Management Group Name') -mgmtGroupVarMember $newMgmtGroupVarMember -mgmtGroupManifest $mgmtGroupsManifest
            }
        }
    }

    # Create the root Parent Management Group object 
    $rootMgmtGroup = ($mgmtGroupsManifest | Where-Object {$_.'Parent Management Group Name' -eq 'TenantRoot'})[0]
    $rootMgmtGroupName = $($rootMgmtGroup.'Management Group Name'.replace(' ',''))
    
    $newMgmtGroupVarMember = [PSCustomObject]@{
        name                = $rootMgmtGroupName
        display_name        = "$($rootMgmtGroup.'Management Group Name')"
        subscription_ids    = @()
        children            = @()
    }
    
    # Send the root Parent Management Group object to the Recursive Function for processing all child objects in the hierarchy
    Set-MgmtGroupHierarchy -ParentMgmtGroup $($rootMgmtGroup.'Management Group Name') -mgmtGroupVarMember $newMgmtGroupVarMember -mgmtGroupManifest $mgmtGroupsManifest

    # Append new resource node to the Variables PSCustomObject
    $objMgmtGroupVars | Add-Member -MemberType NoteProperty -Name "management_groups"  -Value $newMgmtGroupVarMember -Force

    # Append parent_management_group_id node to the Mgmt Group Variables PSCustomObject
    $objMgmtGroupVars | Add-Member -MemberType NoteProperty -Name "parent_management_group_id"  -Value $null -Force

    # Write the Stack main.tf.json file to the appropriate Stack folder
    $objMgmtGroupVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.management-groups.auto.tfvars.json"

    # Save the current Variables json file
    $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"

}

# Function to create Custom RBAC Role configurations
Function Set-CustomRbacRoles
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir
    )
    
    # Get Management Groups sheet from the Manifest
    $customRolesManifest = Import-Excel -path $manifestPath -WorksheetName 'Custom Roles'
    $customRolesAssignableScopesManifest = Import-Excel -path $manifestPath -WorksheetName 'Custom Role Assignable Scopes'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $resourceGroupsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'
    
    # Get existing variables.tf.json object
    [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

    # Create Stack module.management-groups.tf.json object
    try 
    {
        $objCustomRbacRoleModule = [PSCustomObject]@{
            module = @{
                custom_role_definitions = @(
                    @{
                        source = "../../../modules/az-lztf-mod-rbac/"
                        providers = @{
                            azurerm = "azurerm.governance"
                        }

                        custom_role_definitions = "`$`{var.custom_role_definitions`}"
                    }
                )
            }
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objCustomRbacRoleModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.custom-roles.tf.json"
        [PSCustomObject]$objCustomRbacRoleModule = Get-Content -Path "$stackDir/module.custom-roles.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }            

    # Add custom roles to variables.tf.json object
    $newVariablesMember = [PSCustomObject]@{
        description = "List of objects defining the role definitions"
        type = "list(object({name = string, description = string, scope = string, assignable_scopes = list(string), permissions = object({actions = list(string), not_actions = list(string), data_actions = list(string), not_data_actions = list(string)})}))"
        default = @(@{
            name = ""
            description = ""
            scope = ""
            assignable_scopes = @()
            permissions = @{
                actions = @()
                not_actions = @("*")
                data_actions = @()
                not_data_actions = @()
            }
        })
    }
    # Append new resource node to the Variables PSCustomObject
    $objVariables.variable | Add-Member -MemberType NoteProperty -Name "management_groups" -Value $newVariablesMember -Force

    # Create Stack variables.custom-roles.auto.tf.json object
    try 
    {
        $objCustomRbacRoleVars = [PSCustomObject]@{
            custom_role_definitions = @()
        }
    }
    catch 
    {
        Write-Error $_ 
    }

    # Save and re-import JSON file to ensure consistent functionality when adding members
    $objCustomRbacRoleVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.custom-roles.auto.tfvars.json"
    [PSCustomObject]$objCustomRbacRoleVars = Get-Content -Path "$stackDir/variables.custom-roles.auto.tfvars.json" | ConvertFrom-Json -Depth 100

    # Loop through each of the Custom Roles defined in the Custom Roles sheet
    foreach($customRole in ($customRolesManifest | Where-Object {$null -ne $_.'Custom Role Name'}))
    {
        # Loop through all of the Assignable Scopes in the Custom Role Assignable Scopes sheet that match the current Custom Role, and build an Assignable Scopes object
        $assignableScopes = @()
        foreach($customRoleAssignableScope in ($customRolesAssignableScopesManifest | Where-Object {$_.'Custom Role' -eq $customRole.'Custom Role Name'}))
        {
            $assignableScopeType = $customRoleAssignableScope.'Assignable Scope Type'
            $assignableScope = $customRoleAssignableScope.'Assignable Scope'
            
            If($assignableScopeType -eq "Management_Group")
            {
                $scope = "/providers/Microsoft.Management/managementGroups/$assignableScope"
            }
            elseif($assignableScopeType -eq "Subscription")
            {
                if($null -eq $(($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $assignableScope}).'Subscription ID'))
                {
                    $subscriptionId = "<<>>"
                }
                else
                {
                    $subscriptionId = ($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $assignableScope}).'Subscription ID'
                }                
                $scope = "/subscriptions/$subscriptionId"
            }
            elseif($assignableScopeType -eq "Resource_Group")
            {
                $rsgSubscriptionName = ($resourceGroupsManifest | Where-Object {$_.'Resource Group Name' -eq $assignableScope}).'Subscription Name'
                if($null -eq $(($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $rsgSubscriptionName}).'Subscription ID'))
                {
                    $subscriptionId = "<<>>"
                }
                else
                {
                    $subscriptionId = ($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $rsgSubscriptionName}).'Subscription ID'
                }                                
                $scope = "/subscriptions/$subscriptionId/resourcegroups/$assignableScope"
            }
            # Append the new Assignable Scope to the Assignable Scopes object for the current Custom Role
            $assignableScopes += $scope
        }

        # Get the Assigned Scope Type and Assigned Scope for the current Custom Role
        $customRoleAssignedScopeType = $($customRole.'Assigned Scope Type')
        $customRoleAssignedScope = $($customRole.'Assigned Scope')

        # Set the Assigned Scope for the Current Custom Role for either Management Groups, Subscriptions, or Resource Groups
        If($customRoleAssignedScopeType -eq "Management_Group")
        {
            $assignedScope = "/providers/Microsoft.Management/managementGroups/$customRoleAssignedScope"
        }
        elseif($customRoleAssignedScopeType -eq "Subscription")
        {
            if($null -eq $(($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $customRoleAssignedScope}).'Subscription ID'))
            {
                $subscriptionId = "<<>>"
            }
            else
            {
                $subscriptionId = ($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $customRoleAssignedScope}).'Subscription ID'
            }                
            $assignedScope = "/subscriptions/$subscriptionId"
        }
        elseif($customRoleAssignedScopeType -eq "Resource_Group")
        {
            $rsgSubscriptionName = ($resourceGroupsManifest | Where-Object {$_.'Resource Group Name' -eq $customRoleAssignedScope}).'Subscription Name'
            if($null -eq $(($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $rsgSubscriptionName}).'Subscription ID'))
            {
                $subscriptionId = "<<>>"
            }
            else
            {
                $subscriptionId = ($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq $rsgSubscriptionName}).'Subscription ID'
            }   
            $assignedScope = "/subscriptions/$subscriptionId/resourcegroups/$customRoleAssignedScope"
        }

        # If the Assigned Scope for the Current Custom Role is not one of the Assignable Scopes in the Custom Role Assignable Scopes sheet, throw an error. The Assigned Scope for the current CUstom Role MUST be one of the Assignable Scopes
        if($assignableScopes -notcontains $assignedScope)
        {
            Write-Error "The Assigned Scope for Custom Role: ""$($customRole.'Custom Role Name')"" is not one of the Assignable Scopes in the ""Custom Role Assignable Scopes Sheet"". Please check selections for this custom role in the ""Custom Roles"" and ""Custom Role Assignable Scopes"" Sheets, correct the issue, and rety this script"
            exit 1
        }
        
        # Populate the Actions object for the current Custom Role
        $actions = @()
        if($($customRole.'Actions'))
        {            
            foreach($action in ($($customRole.'Actions')).Split(',').Trim())
            {
                $actions += $action
            }
        }

        # Populate the Not Actions object for the current Custom Role
        $notActions = @()
        if($($customRole.'Not Actions'))
        {            
            foreach($notAction in ($($customRole.'Not Actions')).Split(',').Trim())
            {
                $notActions += $notAction
            }
        }

        # Populate the Data Actions object for the current Custom Role
        $dataActions = @()
        if($($customRole.'Data Actions'))
        {            
            foreach($dataAction in ($($customRole.'Data Actions')).Split(',').Trim())
            {
                $dataActions += $dataAction
            }
        }

        # Populate the Not Data Actions object for the current Custom Role
        $notDataActions = @()
        if($($customRole.'Not Data Actions'))
        {            
            foreach($notDataAction in ($($customRole.'Not Data Actions')).Split(',').Trim())
            {
                $notDataActions += $notDataAction
            }
        }

        # Create new Custom Role object to insert into the Custom Role Vars file object
        $newCustomRoleMember = [PSCustomObject]@{
            name                    = "$($customRole.'Custom Role Name')"
            description             = "$($customRole.'Role Description')"
            scope                   = "$assignedScope"
            assignable_scopes       = $($assignableScopes)
            permissions             = @{
                actions             = @($($actions))
                not_actions         = @($($notActions))
                data_actions        = @($($dataActions))
                not_data_actions    = @($($notDataActions))
            }
        }
        # Append new resource node to the Variables PSCustomObject
        $objCustomRbacRoleVars.custom_role_definitions += $newCustomRoleMember        
    }

    # Save variables.custom-roles.auto.tf.json JSON file 
    $objCustomRbacRoleVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.custom-roles.auto.tfvars.json"
    
    # Save the current Variables json file
    $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
}

# Function to create Resource Group Configurations
Function Set-ResourceGroups
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )

    # Get the Stacks and VNETs sheets from the Manifest
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'

    $stackType = $stackType.ToLower()
    
    try
    {
        # Create the root resource.resource-groups.tf.json object
        $objRSG = [PSCustomObject]@{
            resource = @{
                azurerm_resource_group = @{}
            }                    
        }

        # Save and re-import JSON file to ensure consistent functionality when adding members
        $objRSG | ConvertTo-Json -depth 100 | Out-File "$stackDir/resource.resource-groups.tf.json"
        [PSCustomObject]$objRSG = Get-Content -Path "$stackDir/resource.resource-groups.tf.json" | ConvertFrom-Json -Depth 100
    }
    catch 
    {
        Write-Error $_ 
    }
    
    # Loop through the Subscription configurations from the Manifest to get to Stack specific Resource Groups
    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        foreach($rsg in ($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $($subscription.'Subscription Name')}))
        {
            # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure uniqueness of node names in the resource.resource-groups.tf.json file
            $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"   
            
            # Set the provider alias for the current subscription and stack
            $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"

            # Add Resource Groupe to resource.resource-groups.tf.json object
            $newRsgMember = [PSCustomObject]@{
                provider    = $providerAlias
                name        = $($rsg.'Resource Group Name')
                location    = $($rsg.'Region')
                tags        = "`$`{local.tags`}"
            }
            # Append new resource node to the Variables PSCustomObject
            $objRSG.resource.azurerm_resource_group | Add-Member -MemberType NoteProperty -Name "$($rsg.'Resource Group Name')" -Value $newRsgMember
                            
        }
        # Write the Stack resource.resource-groups.tf.json file to the appropriate Stack folder
        $objRSG | ConvertTo-Json -depth 100 | Out-File "$stackDir/resource.resource-groups.tf.json"
    }
}

# Function to create VNET configurations
Function Set-VNETs
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $vnetsManifest = Import-Excel -path $manifestPath -WorksheetName 'VNETs'
    $serviceEndpointsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subnet Service Endpoints'
    $subnetsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subnets'
    $peeringsManifest = Import-Excel -path $manifestPath -WorksheetName 'VNET Peerings'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $regionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Regions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups' 
    # $vnetGWManifest = Import-Excel -path $manifestPath -WorksheetName 'VNET Gateways'   ### ToDo: Deploying VPN Gateways currently not implemented
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.vnets.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.vnets.tf.json" -EA -0

    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {    
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Load existing Stack main.tf.json file for gathering Provider aliases
        [PSCustomObject]$objTerraformMain = Get-Content -Path "$stackDir/main.tf.json" | ConvertFrom-Json -Depth 100
        
        # Only execute the following if there is actually a VNET associated with the current Subscription
        if(($vnetsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.vnets.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.vnets.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.vnets.auto.tfvars object
                    $objVNETVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objVNETVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.vnets.auto.tfvars.json"
                    [PSCustomObject]$objVNETVars = Get-Content -Path "$stackDir/variables.vnets.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objVNETVars = Get-Content -Path "$stackDir/variables.vnets.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.vnets.tf.json object
            if(!(Test-Path -Path "$stackDir/module.vnets.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.vnets.tf.json object
                    $objVNETModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objVNETModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.vnets.tf.json"
                    [PSCustomObject]$objVNETModule = Get-Content -Path "$stackDir/module.vnets.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objVNETModule = Get-Content -Path "$stackDir/module.vnets.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100
            
            foreach($vnet in ($vnetsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {
                # Loop through providers in main.tf.json file, and construct a providers object for the current subscription and Hub that the current VNET will peer with
                $providers = @{}
                foreach($provider in (($objTerraformMain.provider.azurerm | ForEach-Object {$_.alias}) | Where-Object {$_ -eq "hub" -or $_ -eq "$($stackType)-$($subscriptionName)"}))
                {
                    if($provider -eq "hub")
                    {
                        $providers += @{"azurerm.hub" = "azurerm.$provider"}
                    }
                    else{$providers += @{"azurerm" = "azurerm.$provider"}}
                }   
                
                $newVNETMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-vnet/"
                    providers = $providers

                    vnet_name               = "`$`{var.$($vnet.'VNET Name').name`}"
                    location                = "`$`{azurerm_resource_group.$($vnet.'Resource Group').location`}"
                    resource_group_name     = "`$`{azurerm_resource_group.$($vnet.'Resource Group').name`}"
                    address_spaces          = "`$`{var.$($vnet.'VNET Name').address_spaces`}"
                    dns_servers             = "`$`{var.$($vnet.'VNET Name').dns_servers`}"
                    subnets                 = "`$`{var.$($vnet.'VNET Name').subnets`}"
                    peerings                = "`$`{var.$($vnet.'VNET Name').peerings`}"
                    ddos_protection_plan_id = "`$`{var.$($vnet.'VNET Name').ddos_protection_plan_id`}"
                }

                $objVNETModule.module | Add-Member -MemberType NoteProperty -Name $($vnet.'VNET Name') -Value $newVNETMember
                # Save and re-import JSON file to ensure consistent functionality when adding members
                $objVNETModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.vnets.tf.json"
                [PSCustomObject]$objVNETModule = Get-Content -Path "$stackDir/module.vnets.tf.json" | ConvertFrom-Json -Depth 100

                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($vnet.'VNET Name') VNET"
                    type = "object({name = string, address_spaces = list(string), dns_servers = list(string), ddos_protection_plan_id = string, subnets = list(object({name = string, address_prefixes = list(string), service_endpoints = list(string)})), peerings = list(object({hub_resource_group_name = string, hub_vnet_name = string, hub_vnet_id = string, name_to_spoke = string, allow_vnet_access_hub_spoke = bool, allow_forwarded_traffic_hub_spoke = bool, allow_gateway_transit_hub_spoke = bool, use_remote_gateways_hub_spoke = bool, name_to_hub = string, allow_vnet_access_spoke_hub = bool, allow_forwarded_traffic_spoke_hub = bool, allow_gateway_transit_spoke_hub = bool, use_remote_gateways_spoke_hub = bool}))})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($vnet.'VNET Name')" -Value $newVariablesMember -Force
                
                # Get Primary and Secondary DNS addresses for the VNET
                $dnsIPs = @()
                if($vnet.'Primary DNS'){$dnsIPs += $vnet.'Primary DNS'}
                if($vnet.'Secondary DNS'){$dnsIPs += $vnet.'Secondary DNS'}
                
                # Get Subnets for the current VNET
                $subnets = @()
                foreach($subnet in $subnetsManifest | Where-Object {$_.'VNET Name' -eq "$($vnet.'VNET Name')" })
                {
                    # Get Subnet Service Endpoints
                    $serviceEndpoints = @()
                    foreach($endpoint in ($serviceEndpointsManifest | Where-Object {$_.'Subnet Name' -eq "$($subnet.'Subnet Name')" }))
                    {
                        $serviceEndpoints += "$($endpoint.'Service Endpoint')"
                    }

                    $addressPrefixes = @()
                    foreach($prefix in ($($subnet.'Address Prefixes')).Split(',').Trim())
                    {
                        $addressPrefixes += $prefix
                    }
                    
                    # Construct Subnet object
                    $newSubnetMember = [PSCustomObject]@{                
                        name = "$($subnet.'Subnet Name')"
                        address_prefixes = $addressPrefixes
                        service_endpoints = @($($serviceEndpoints))
                    }
                    # Append new Subnet node to the Subnets PSCustomObject
                    $subnets += $newSubnetMember  
                }
                
                $spokeRegionShortName = ($regionsManifest | Where-Object {$_.'Region' -eq $vnet.'Region'}).'Region Short Name'
                $peerings = @()
                $objPeering = @()
                $hubSubscriptionId = ""
                foreach($peering in ($peeringsManifest | Where-Object {$_.'SPOKE VNET' -eq "$($vnet.'VNET Name')"}))
                {
                    <# ### ToDo: Deploying VPN Gateways currently not implemented
                    try
                    {
                        # Check to ensure that there is a Remote GW configuration for the HUB VNET if the current peering is set to 'SPOKE Use Remote Gateway' = "TRUE" in the Google Sheet
                        if($($peering.'SPOKE Use Remote GW') -eq "TRUE")
                        {
                            if(!($vnetGWManifest | Where-Object {$_.'VNET' -eq $peering.'Hub VNET'}))
                            {
                                throw "Peering for VNET ""$($peering.'Spoke VNET')"" is set to allow the SPOKE to Use Remote Gateway of the HUB, but HUB VNET ""$($peering.'Hub VNET')"" does nto have a Gateway configuration in the VNET Gateways Sheet. `nPlease configure a Gateway for the Hub in the VNET Gateways sheet, or set ""SPOKE Use Remote Gateway"" to FALSE, and rerun this script"                            
                            }
                            else
                            {
                                # TODO: Build the VPN GW Terraform code for the GW associated with the current VNET Peering
                            }
                        }                        

                        if($($peering.'HUB Use Remote GW') -eq "TRUE")
                        {
                            if(!($vnetGWManifest | Where-Object {$_.'VNET' -eq $peering.'SPOKE VNET'}))
                            {
                                throw "Currently, the setting ""HUB Use Remote GW"" should always be set to FALSE due to the static modules being designed for Hub/Spoke model where only the Hub has a VNET GW"                            
                            }
                        }
                    }
                    catch
                    {
                        Write-Host -ForegroundColor Red $_
                        exit 1
                    }
                    #>
                    
                    #$hubVnetRegion = ($vnetsManifest | Where-Object {$_.'VNET Name' -eq $peering.'HUB VNET'}).'Region'
                    $hubRegionShortName = ($regionsManifest | Where-Object {$_.'Region' -eq ($vnetsManifest | Where-Object {$_.'VNET Name' -eq $peering.'HUB VNET'}).'Region'}).'Region Short Name'
                    # Get the Hub Subscription ID to populate the peerings
                    $hubSubscriptionId = ($subscriptionsManifest | Where-Object {$_.'Subscription Name' -eq ($rsgsManifest | Where-Object{$_.'Resource Group Name' -eq ($vnetsManifest | Where-Object {$_.'VNET Name' -eq $peering.'Hub VNET'}).'Resource Group'}).'Subscription Name'}).'Subscription ID'
                    $hubVNETRsg = ($rsgsManifest | Where-Object{$_.'Resource Group Name' -eq ($vnetsManifest | Where-Object {$_.'VNET Name' -eq $peering.'Hub VNET'}).'Resource Group'}).'Resource Group Name'
                    
                    $objPeering = [PSCustomObject]@{
                        hub_resource_group_name             = $($hubVNETRsg)
                        hub_vnet_name                       = $($peering.'HUB VNET')
                        hub_vnet_id                         = "/subscriptions/$($hubSubscriptionId)/resourceGroups/$($hubVNETRsg)/providers/Microsoft.Network/virtualNetworks/$($peering.'HUB VNET')"
                        name_to_spoke                       = "VNETPEER-$($hubRegionShortName)-$($peering.'HUB VNET')-to-$($spokeRegionShortName)-$($vnet.'VNET Name')"
                        allow_vnet_access_hub_spoke         = ($($peering.'HUB Allow Access to Spoke VNET').ToString().ToLower())
                        allow_forwarded_traffic_hub_spoke   = ($($peering.'HUB Allow Forwarded Traffic').ToString().ToLower())
                        allow_gateway_transit_hub_spoke     = ($($peering.'HUB Allow GW Transit').ToString().ToLower())
                        use_remote_gateways_hub_spoke       = "false" # ($($peering.'HUB Use Remote GW').ToString().ToLower())   ### ToDo: Deploying VPN Gateways currently not implemented

                        name_to_hub                         = "VNETPEER-$($spokeRegionShortName)-$($vnet.'VNET Name')-to-$($hubRegionShortName)-$($peering.'HUB VNET')"
                        allow_vnet_access_spoke_hub         = ($($peering.'SPOKE Allow Access to Hub VNET').ToString().ToLower())
                        allow_forwarded_traffic_spoke_hub   = ($($peering.'SPOKE Allow Forwarded Traffic').ToString().ToLower())
                        allow_gateway_transit_spoke_hub     = ($($peering.'SPOKE Allow GW Transit').ToString().ToLower())
                        use_remote_gateways_spoke_hub       = "false" # ($($peering.'SPOKE Use Remote GW').ToString().ToLower())   ### ToDo: Deploying VPN Gateways currently not implemented
                    }

                    $peerings += $objPeering  
                }

                if(($stackType -eq 'spoke') -and $hubSubscriptionId)
                    {
                        [PSCustomObject]$objProviderVariables = Get-Content -Path "$stackDir/variables.providers.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                        $objProviderVariables | Add-Member -MemberType NoteProperty -Name "hub_subscription_id" -Value $hubSubscriptionId -Force

                        # Write the Stack variables.providers.auto.tfvars.json file to the appropriate Stack folder      
                        $objProviderVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.providers.auto.tfvars.json"
                    }

                    $newVNETAutoVars = [PSCustomObject]@{
                        name                    = "$($vnet.'VNET Name')"
                        address_spaces          = @("$($vnet.'Address Spaces')")
                        dns_servers             = @($($dnsIPs))
                        ddos_protection_plan_id = ""
                        subnets                 = @($($subnets))
                        peerings                = @($($peerings))
                    }                
                # Append new resource node to the Variables PSCustomObject
                $objVNETVars | Add-Member -MemberType NoteProperty -Name "$($vnet.'VNET Name')" -Value $newVNETAutoVars -Force           
            }
            # Save the current VNET module json file
            $objVNETModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.vnets.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objVNETVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.vnets.auto.tfvars.json"
        }
    }
}

# Function to create Log Analytics Workspace configurations
Function Set-LogAnalyticsWorkspaces
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $lawsManifest = Import-Excel -path $manifestPath -WorksheetName 'Log Analytics'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.log-analytics.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.log-analytics.tf.json" -EA -0

    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually a Log Analytics Workspace associated with the current Subscription
        if(($lawsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.log-analytics.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.log-analytics.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.log-analytics.auto.tfvars object
                    $objLAWVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objLAWVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.log-analytics.auto.tfvars.json"
                    [PSCustomObject]$objLAWVars = Get-Content -Path "$stackDir/variables.log-analytics.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objLAWVars = Get-Content -Path "$stackDir/variables.log-analytics.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.log-analytics.tf.json object
            if(!(Test-Path -Path "$stackDir/module.log-analytics.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.vnets.tf.json object
                    $objLAWModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objLAWModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.log-analytics.tf.json"
                    [PSCustomObject]$objLAWModule = Get-Content -Path "$stackDir/module.log-analytics.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objLAWModule = Get-Content -Path "$stackDir/module.log-analytics.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($law in ($lawsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"
                
                $newLAWMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-loganalytics/"
                    providers = @{
                        azurerm = $providerAlias
                    }

                    workspace_name          = "`$`{var.$($law.'Log Analytics Workspace Name').workspace_name`}"
                    location                = "`$`{azurerm_resource_group.$($law.'Resource Group').location`}"
                    resource_group_name     = "`$`{azurerm_resource_group.$($law.'Resource Group').name`}"
                    log_retention_days      = "`$`{var.$($law.'Log Analytics Workspace Name').log_retention_days`}"
                    solutions               =  "`$`{var.$($law.'Log Analytics Workspace Name').solutions`}"
                    linked_storage_accounts = "`$`{var.$($law.'Log Analytics Workspace Name').linked_storage_accounts`}"
                }
                $objLAWModule.module | Add-Member -MemberType NoteProperty -Name $($law.'Log Analytics Workspace Name') -Value $newLAWMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($law.'Log Analytics Workspace Name') Workspace"
                    type = "object({workspace_name = string, log_retention_days = string, solutions = list(object({solution_name = string, publisher = string, product = string})), linked_storage_accounts = list(object({id = string}))})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($law.'Log Analytics Workspace Name')" -Value $newVariablesMember -Force            
                
                $newLAWVarMember = [PSCustomObject]@{
                    workspace_name          = "$($law.'Log Analytics Workspace Name')"
                    log_retention_days      = "$($law.'Log Retention Days')"
                    solutions               = @() # ToDo: Log Analytics Solution configurations are not currently implemented in the Google Sheet
                    linked_storage_accounts = @() # ToDo: Log Analytics Linked Storage configurations are not currently implemented in the Google Sheet
                }
                # Append new resource node to the Variables PSCustomObject
                $objLAWVars | Add-Member -MemberType NoteProperty -Name "$($law.'Log Analytics Workspace Name')" -Value $newLAWVarMember -Force            
            }

            # Save the current VNET module json file
            $objLAWModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.log-analytics.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objLAWVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.log-analytics.auto.tfvars.json"
        }
    }
}

# Function to create Bastion configurations
Function Set-Bastions
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $bastionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Azure Bastions'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.bastions.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.bastions.tf.json" -EA -0
    
    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually a Bastion configuration associated with the current Subscription
        if(($bastionsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.bastions.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.bastions.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.<subscription name>-bastions.auto.tfvars object
                    $objBastionVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objBastionVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.bastions.auto.tfvars.json"
                    [PSCustomObject]$objBastionVars = Get-Content -Path "$stackDir/variables.bastions.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objBastionVars = Get-Content -Path "$stackDir/variables.bastions.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.bastions.tf.json object
            if(!(Test-Path -Path "$stackDir/module.bastions.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.bastions.tf.json object
                    $objBastionModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objBastionModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.bastions.tf.json"
                    [PSCustomObject]$objBastionModule = Get-Content -Path "$stackDir/module.bastions.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objBastionModule = Get-Content -Path "$stackDir/module.bastions.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($bastion in ($bastionsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"
                $vnetName = $($bastion.'VNET Name')
                # Get existing variables.tf.json object
                [PSCustomObject]$objVNETVars = Get-Content -Path "$stackDir/variables.vnets.auto.tfvars.json" | ConvertFrom-Json -Depth 100

                if($objVNETVars.$vnetName.subnets)
                {
                    if($objVNETVars.$vnetName.subnets.name -contains "AzureBastionSubnet")
                    {
                        $subnetIndex = [array]::indexof(($objVNETVars.$vnetName.subnets.name),'AzureBastionSubnet')
                    }
                    else
                    {
                        throw "VNET: ""$vnetName"" does not contain an AzureBastionSubnet in the Google Sheet manifest. Please check the VNETs and Azure Bastions worksheets in the Google Sheet manifest, and correct any misconfigurations."
                    }
                }
                else
                {
                    throw "There are no Subnets found in ""$stackDir/variables.vnets.auto.tfvars.json"" for the VNET: ""$vnetName"". Please check the VNETs, Subnets, and Azure Bastions worksheets in the Google Sheet manifest, and correct any misconfigurations." 
                }

                $newBastionMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-bastion/"
                    providers = @{
                        azurerm = $providerAlias
                    }

                    name                    = "`$`{var.$($bastion.'Bastion Name').name`}"
                    location                = "`$`{azurerm_resource_group.$($bastion.'Resource Group').location`}"
                    resource_group_name     = "`$`{azurerm_resource_group.$($bastion.'Resource Group').name`}"
                    ip_configuration_name   = "Bastion_Public_IP_Config"
                    public_ip_name          = "`$`{var.$($bastion.'Bastion Name').public_ip_name`}"
                    sku                     = "`$`{var.$($bastion.'Bastion Name').sku`}"
                    subnet_id               = "`$`{module.$($vnetName).subnet_ids[$subnetIndex]`}"
                }
                $objBastionModule.module | Add-Member -MemberType NoteProperty -Name $($bastion.'Bastion Name') -Value $newBastionMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($bastion.'Bastion Name') Bastion"
                    type = "object({name = string, public_ip_name = string, sku = string})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($bastion.'Bastion Name')" -Value $newVariablesMember -Force            
                
                $newBastionVarMember = [PSCustomObject]@{
                    name            = "$($bastion.'Bastion Name')"
                    public_ip_name  = "$($bastion.'Public IP Name')"
                    sku             = "$($bastion.'SKU')"
                }
                # Append new resource node to the Variables PSCustomObject
                $objBastionVars | Add-Member -MemberType NoteProperty -Name "$($bastion.'Bastion Name')" -Value $newBastionVarMember -Force            
            }
            
            # Save the current VNET module json file
            $objBastionModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.bastions.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objBastionVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.bastions.auto.tfvars.json"
        }
    }
}

# Function to create Recovery Service Vault configurations
Function Set-RecoveryVaults
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $rsvsManifest = Import-Excel -path $manifestPath -WorksheetName 'Recovery Services Vaults'
    $rsvPoliciesManifest = Import-Excel -path $manifestPath -WorksheetName 'Recovery Policies'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.recovery-vaults.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.recovery-vaults.tf.json" -EA -0
    
    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually a Vault configuration associated with the current Subscription
        if(($rsvsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.recovery-vaults.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.recovery-vaults.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.recovery-vaults.auto.tfvars object
                    $objRSVVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objRSVVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.recovery-vaults.auto.tfvars.json"
                    [PSCustomObject]$objRSVVars = Get-Content -Path "$stackDir/variables.recovery-vaults.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objRSVVars = Get-Content -Path "$stackDir/variables.recovery-vaults.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.recovery-vaults.tf.json object
            if(!(Test-Path -Path "$stackDir/module.recovery-vaults.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.recovery-vaults.tf.json object
                    $objRSVModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objRSVModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.recovery-vaults.tf.json"
                    [PSCustomObject]$objRSVModule = Get-Content -Path "$stackDir/module.recovery-vaults.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objRSVModule = Get-Content -Path "$stackDir/module.recovery-vaults.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($rsv in ($rsvsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"

                # Get Subnets for the current VNET
                $policies = @()
                foreach($policy in $rsvPoliciesManifest | Where-Object {$_.'Recovery Vault Name' -eq "$($rsv.'Recovery Vault Name')" })
                {
                    # Get Policy Retention Days/Weeks/Months and turn the comma-separated lists into arrays
                    $backupWeekDays = @()
                    if($($policy.'Weekdays') -like "*,*")
                    {
                        foreach($backupWeekDay in ($($policy.'Weekdays')).Split(',').Trim())
                        {
                            $backupWeekDays += $backupWeekDay
                        }
                    }
                    elseif($($policy.'Weekdays'))
                    {
                        $backupWeekDays += $($policy.'Weekdays')
                    }

                    $weeklyRetentionDays = @()
                    if($($policy.'Weekly Retention Days') -like "*,*")
                    {
                        foreach($weeklyRetentionDay in ($($policy.'Weekly Retention Days')).Split(',').Trim())
                        {
                            $weeklyRetentionDays += $weeklyRetentionDay
                        }
                    }
                    elseif($($policy.'Weekly Retention Days'))
                    {
                        $weeklyRetentionDays += $($policy.'Weekly Retention Days')
                    }

                    $monthlyRetentionDays = @()
                    if($($policy.'Monthly Retention Days') -like "*,*")
                    {
                        foreach($monthlyRetentionDay in ($($policy.'Monthly Retention Days')).Split(',').Trim())
                        {
                            $monthlyRetentionDays += $monthlyRetentionDay
                        }
                    }
                    elseif($($policy.'Monthly Retention Days'))
                    {
                        $monthlyRetentionDays += $($policy.'Monthly Retention Days')
                    }

                    $monthlyRetentionWeeks = @()
                    if($($policy.'Monthly Retention Weeks') -like "*,*")
                    {
                        foreach($monthlyRetentionWeek in ($($policy.'Monthly Retention Weeks')).Split(',').Trim())
                        {
                            $monthlyRetentionWeeks += $monthlyRetentionWeek
                        }
                    }
                    elseif($($policy.'Monthly Retention Weeks'))
                    {
                        $monthlyRetentionWeeks += $($policy.'Monthly Retention Weeks')
                    }

                    $yearlyRetentionDays = @()
                    if($($policy.'Yearly Retention Days') -like "*,*")
                    {
                        foreach($yearlyRetentionDay in ($($policy.'Yearly Retention Days')).Split(',').Trim())
                        {
                            $yearlyRetentionDays += $yearlyRetentionDay
                        }
                    }
                    elseif($($policy.'Yearly Retention Days'))
                    {
                        $yearlyRetentionDays += $($policy.'Yearly Retention Days')
                    }

                    $yearlyRetentionWeeks = @()
                    if($($policy.'Yearly Retention Weeks') -like "*,*")
                    {
                        foreach($yearlyRetentionWeek in ($($policy.'Yearly Retention Weeks')).Split(',').Trim())
                        {
                            $yearlyRetentionWeeks += $yearlyRetentionWeek
                        }
                    }
                    elseif($($policy.'Yearly Retention Weeks'))
                    {
                        $yearlyRetentionWeeks += $($policy.'Yearly Retention Weeks')
                    }

                    $yearlyRetentionMonths = @()
                    if($($policy.'Yearly Retention Months') -like "*,*")
                    {
                        foreach($yearlyRetentionMonth in ($($policy.'Yearly Retention Months')).Split(',').Trim())
                        {
                            $yearlyRetentionMonths += $yearlyRetentionMonth
                        }
                    }
                    elseif($($policy.'Yearly Retention Months'))
                    {
                        $yearlyRetentionMonths += $($policy.'Yearly Retention Months')
                    }
                    
                    # Construct Recovery Policy object
                    $newRSVPolicyMember = [PSCustomObject]@{                
                        name                            = "$($policy.'Policy Name')"
                        timezone                        = "$($policy.'Timezone')"
                        instant_restore_retention_days  = $($policy.'Instant Restore Retention (Number of Days)')
                        frequency                       = "$($policy.'Backup Frequency')"
                        time                            = "$($policy.'Backup Time')"
                        weekdays                        = $backupWeekDays
                        retention_daily_count           = $($policy.'Daily Retention Count')
                        retention_weekly_count          = $($policy.'Weekly Retention Count')
                        retention_weekly_days           = $weeklyRetentionDays
                        retention_monthly_count         = $($policy.'Monthly Retention Count')
                        retention_monthly_days          = $monthlyRetentionDays
                        retention_monthly_weeks         = $monthlyRetentionWeeks
                        retention_yearly_count          = $($policy.'Yearly Retention Count')
                        retention_yearly_days           = $yearlyRetentionDays
                        retention_yearly_weeks          = $yearlyRetentionWeeks
                        retention_yearly_months         = $yearlyRetentionMonths
                    }
                    # Append new Subnet node to the Subnets PSCustomObject
                    $policies += $newRSVPolicyMember  
                }
                
                $newRSVMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-recoveryvault/"
                    providers = @{
                        azurerm = $providerAlias
                    }

                    name                = "`$`{var.$($rsv.'Recovery Vault Name').name`}"
                    location            = "`$`{azurerm_resource_group.$($rsv.'Resource Group').location`}"
                    resource_group_name = "`$`{azurerm_resource_group.$($rsv.'Resource Group').name`}"                 
                    soft_delete_enabled = "`$`{var.$($rsv.'Recovery Vault Name').soft_delete_enabled`}"
                    policies            = "`$`{var.$($rsv.'Recovery Vault Name').policies`}"
                }
                $objRSVModule.module | Add-Member -MemberType NoteProperty -Name $($rsv.'Recovery Vault Name') -Value $newRSVMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($rsv.'Recovery Vault Name') Recovery Vault"
                    type = "object({name = string, soft_delete_enabled = string, policies = list(object({name = string, timezone = string, instant_restore_retention_days = number, frequency = string, time = string, weekdays = list(string), retention_daily_count = number, retention_weekly_count = number, retention_weekly_days = list(string), retention_monthly_count = number, retention_monthly_days = list(string), retention_monthly_weeks = list(string), retention_yearly_count = number, retention_yearly_days = list(string), retention_yearly_weeks = list(string), retention_yearly_months = list(string)}))})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($rsv.'Recovery Vault Name')" -Value $newVariablesMember -Force            
                
                $newRSVVarMember = [PSCustomObject]@{
                    name                = "$($rsv.'Recovery Vault Name')"                    
                    sku                 = "$($rsv.'SKU')"
                    soft_delete_enabled = $($rsv.'Soft Delete Enabled')
                    policies            = @($($policies))
                }
                # Append new resource node to the Variables PSCustomObject
                $objRSVVars | Add-Member -MemberType NoteProperty -Name "$($rsv.'Recovery Vault Name')" -Value $newRSVVarMember -Force            
            }
            
            # Save the current VNET module json file
            $objRSVModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.recovery-vaults.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objRSVVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.recovery-vaults.auto.tfvars.json"
        }
    }
}

# Function to create Bastion configurations
Function Set-NSGs
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $nsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'NSGs'
    $nsgRulesManifest = Import-Excel -path $manifestPath -WorksheetName 'NSG Rules'
    $subnetsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subnets'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing NSG specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.nsgs.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.nsgs.tf.json" -EA -0
    
    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually an NSG configuration associated with the current Subscription
        if(($nsgsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.nsgs.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.nsgs.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.nsgs.auto.tfvars object
                    $objNSGVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objNSGVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.nsgs.auto.tfvars.json"
                    [PSCustomObject]$objNSGVars = Get-Content -Path "$stackDir/variables.nsgs.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objNSGVars = Get-Content -Path "$stackDir/variables.nsgs.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.nsgs.tf.json object
            if(!(Test-Path -Path "$stackDir/module.nsgs.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.nsgs.tf.json object
                    $objNSGModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objNSGModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.nsgs.tf.json"
                    [PSCustomObject]$objNSGModule = Get-Content -Path "$stackDir/module.nsgs.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objNSGModule = Get-Content -Path "$stackDir/module.nsgs.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($nsg in ($nsgsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"

                # Get the VNET Variables json file
                [PSCustomObject]$objVNETVars = Get-Content -Path "$stackDir/variables.vnets.auto.tfvars.json" | ConvertFrom-Json -Depth 100

                # Get the list of Subnets that this NSG should be associated with
                $nsgSubnets = $subnetsManifest | Where-Object {$_.'NSG' -eq $($nsg.'NSG Name')}
                
                $subnet_ids = @()
                # Loop through each of the Subnetsto construct the references to the Subnet IDs that the NSG should be associated with
                foreach($nsgSubnet in $nsgSubnets)
                {
                    $vnetName = $nsgSubnet.'VNET Name'                                            
                    if($objVNETVars.$vnetName.subnets)
                    {
                        if($objVNETVars.$vnetName.subnets.name -contains $($nsgSubnet.'Subnet Name'))
                        {
                            $subnetIndex = [array]::indexof(($objVNETVars.$vnetName.subnets.name), $($nsgSubnet.'Subnet Name'))
                        }
                        else
                        {
                            throw "VNET: ""$vnetName"" does not contain a ""$($nsgSubnet.'Subnet Name')"" Subnet in the Google Sheet manifest. Please check the VNETs and Subnets worksheets in the Google Sheet manifest, and correct any misconfigurations."
                        }
                    }
                    else
                    {
                        throw "There are no Subnets found in ""$stackDir/variables.vnets.auto.tfvars.json"" for the VNET: ""$vnetName"". Please check the VNETs, Subnets worksheets in the Google Sheet manifest, and correct any misconfigurations." 
                    }

                    $subnet_ids += "`$`{module.$($vnetName).subnet_ids[$subnetIndex]`}"
                }
                
                $newNSGMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-nsg/"
                    providers = @{
                        azurerm = $providerAlias
                    }

                    name                                    = "`$`{var.$($nsg.'NSG Name').name`}"
                    location                                = "`$`{azurerm_resource_group.$($nsg.'Resource Group').location`}"
                    resource_group_name                     = "`$`{azurerm_resource_group.$($nsg.'Resource Group').name`}"
                    rules                                   = "`$`{var.$($nsg.'NSG Name').rules`}"
                    subnet_ids                              = $subnet_ids
                    enable_flow_log                         = "`$`{var.$($nsg.'NSG Name').enable_flow_log`}"
                    network_watcher_name                    = "`$`{var.$($nsg.'NSG Name').network_watcher_name`}"
                    network_watcher_resource_group_name     = "`$`{var.$($nsg.'NSG Name').network_watcher_resource_group_name`}"
                    storage_account_id                      = "`$`{var.$($nsg.'NSG Name').storage_account_id`}"
                    storage_account_logs_enabled            = "`$`{var.$($nsg.'NSG Name').storage_account_logs_enabled`}"
                    retention_policy_enabled                = "`$`{var.$($nsg.'NSG Name').retention_policy_enabled`}"
                    retention_policy_days                   = "`$`{var.$($nsg.'NSG Name').retention_policy_days`}"
                    traffic_analytics_enabled               = "`$`{var.$($nsg.'NSG Name').traffic_analytics_enabled`}"
                    workspace_id                            = "`$`{var.$($nsg.'NSG Name').workspace_id`}"
                    workspace_region                        = "`$`{var.$($nsg.'NSG Name').workspace_region`}"
                    workspace_resource_id                   = "`$`{var.$($nsg.'NSG Name').workspace_resource_id`}"
                    traffic_analytics_interval_in_minutes   = "`$`{var.$($nsg.'NSG Name').traffic_analytics_interval_in_minutes`}"                    
                    flow_log_version                        = "`$`{var.$($nsg.'NSG Name').flow_log_version`}"
                }
                $objNSGModule.module | Add-Member -MemberType NoteProperty -Name $($nsg.'NSG Name') -Value $newNSGMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($nsg.'NSG Name') NSG"
                    type = "object({name = string, rules = list(object({name = string, description = string, priority = string, direction = string, access = string, protocol = string, source_port_range = string, source_port_ranges = list(string), destination_port_range = string, destination_port_ranges = list(string), source_address_prefix = string, source_address_prefixes = list(string), destination_address_prefix = string, destination_address_prefixes = list(string), source_application_security_group_ids = list(string), destination_application_security_group_ids = list(string)})), enable_flow_log = bool, network_watcher_name = string, network_watcher_resource_group_name = string, storage_account_id = string, storage_account_logs_enabled = bool, retention_policy_enabled = bool, retention_policy_days = number, traffic_analytics_enabled = bool, workspace_id = string, workspace_region = string, workspace_resource_id = string, traffic_analytics_interval_in_minutes = number, flow_log_version = number})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($nsg.'NSG Name')" -Value $newVariablesMember -Force            
                
                # Get Subnets assigned to the current NSG
                $subnetIDs = @()
                foreach($subnet in $subnetsManifest | Where-Object {$_.'NSG' -eq "$($nsg.'NSG Name')" })
                {                    
                    $subnetIDs += "`$`{azurerm_subnet.$($subnet.'Subnet Name').id`}"                 
                }   
                
                $nsgRules = @()
                foreach($nsgRule in $nsgRulesManifest | Where-Object {$_.'NSG Name' -eq "$($nsg.'NSG Name')" })
                {  
                    # Determine Port range(s) and address prefix(es) for source and destination
                    if($($nsgRule.'Source Address Prefix(es)'))
                    {
                        # Check of the value is comman separated
                        if($($nsgRule.'Source Address Prefix(es)') -like "*,*")
                        {
                            # If the value is comma separated, $sourceAddressPrefix should be null, and a list should be generated of all of the comma separated prefixes
                            $sourceAddressPrefix = $null
                            $sourceAddressPrefixes = @()
                            foreach($prefix in ($($nsgRule.'Source Address Prefix(es)')).Split(',').Trim())
                            {
                                $sourceAddressPrefixes += $prefix
                            }
                        }
                        else
                        {
                            # If the value is not comma separated, $sourceAddressPrefixes should be null, and $sourceAddressPrefix should be assigned the value directly
                            $sourceAddressPrefixes = $null
                            $sourceAddressPrefix = $($nsgRule.'Source Address Prefix(es)')                        
                        }
                    }
                    else
                    {
                        # Throw and error that there are no Source Prefixes defined in the Google Sheet
                        throw "No Source Address Prefixes specified for NSG Rule: ""$($nsgRule)""! Please check the configuration in the Google Sheet ""NSG Rules"", and correct any missing information for this NSG Rule"
                    }

                    if($($nsgRule.'Destination Address Prefix(es)'))
                    {
                        # Check of the value is comman separated
                        if($($nsgRule.'Destination Address Prefix(es)') -like "*,*")
                        {
                            # If the value is comma separated, $destinationAddressPrefix should be null, and a list should be generated of all of the comma separated prefixes
                            $destinationAddressPrefix = $null
                            $destinationAddressPrefixes = @()
                            foreach($prefix in ($($nsgRule.'Destination Address Prefix(es)')).Split(',').Trim())
                            {
                                $destinationAddressPrefixes += $prefix
                            }
                        }
                        else
                        {
                            # If the value is not comma separated, $destinationAddressPrefixes should be null, and $destinationAddressPrefix should be assigned the value directly
                            $destinationAddressPrefixes = $null
                            $destinationAddressPrefix = $($nsgRule.'Destination Address Prefix(es)')                        
                        }
                    }
                    else
                    {
                        # Throw and error that there are no Source Prefixes defined in the Google Sheet
                        throw "No Destination Address Prefixes specified for NSG Rule: ""$($nsgRule)""! Please check the configuration in the Google Sheet ""NSG Rules"", and correct any missing information for this NSG Rule"
                    }

                    if($($nsgRule.'Source Port Range(s)'))
                    {
                        # Check of the value is comman separated
                        if($($nsgRule.'Source Port Range(s)') -like "*,*")
                        {
                            # If the value is comma separated, $sourcePortRange should be null, and a list should be generated of all of the comma separated prefixes
                            $sourcePortRange = $null
                            $sourcePortRanges = @()
                            foreach($prefix in ($($nsgRule.'Source Port Range(s)')).Split(',').Trim())
                            {
                                $sourcePortRanges += $prefix
                            }
                        }
                        else
                        {
                            # If the value is not comma separated, $sourcePortRangees should be null, and $sourcePortRange should be assigned the value directly
                            $sourcePortRanges = $null
                            $sourcePortRange = $($nsgRule.'Source Port Range(s)')                        
                        }
                    }
                    else
                    {
                        # Throw and error that there are no Source Prefixes defined in the Google Sheet
                        throw "No Source Port Ranges specified for NSG Rule: ""$($nsgRule)""! Please check the configuration in the Google Sheet ""NSG Rules"", and correct any missing information for this NSG Rule"
                    }

                    if($($nsgRule.'Destination Port Range(s)'))
                    {
                        # Check of the value is comman separated
                        if($($nsgRule.'Destination Port Range(s)') -like "*,*")
                        {
                            # If the value is comma separated, $destinationPortRange should be null, and a list should be generated of all of the comma separated prefixes
                            $destinationPortRange = $null
                            $destinationPortRanges = @()
                            foreach($prefix in ($($nsgRule.'Destination Port Range(s)')).Split(',').Trim())
                            {
                                $destinationPortRanges += $prefix
                            }
                        }
                        else
                        {
                            # If the value is not comma separated, $destinationPortRangees should be null, and $destinationPortRange should be assigned the value directly
                            $destinationPortRanges = $null
                            $destinationPortRange = $($nsgRule.'Destination Port Range(s)')                        
                        }
                    }
                    else
                    {
                        # Throw and error that there are no Source Prefixes defined in the Google Sheet
                        throw "No Destination Port Ranges specified for NSG Rule: ""$($nsgRule)""! Please check the configuration in the Google Sheet ""NSG Rules"", and correct any missing information for this NSG Rule"
                    }        

                    $objNSGRule = [PSCustomObject]@{
                        name                                        = $($nsgRule.'Rule Name')
                        description                                 = $($nsgRule.'Rule Description')
                        priority                                    = $($nsgRule.'Priority')
                        direction                                   = $($nsgRule.'Direction')
                        access                                      = $($nsgRule.'Access')
                        protocol                                    = $($nsgRule.'Protocol')
                        source_port_range                           = $($sourcePortRange)
                        source_port_ranges                          = $($sourcePortRanges)                        
                        destination_port_range                      = $($destinationPortRange)
                        destination_port_ranges                     = $($destinationPortRanges)
                        source_address_prefix                       = $($sourceAddressPrefix)
                        source_address_prefixes                     = $($sourceAddressPrefixes)
                        destination_address_prefix                  = $($destinationAddressPrefix)
                        destination_address_prefixes                = $($destinationAddressPrefixes)
                        source_application_security_group_ids       = $($nsgRule.'source_application_security_group_ids')
                        destination_application_security_group_ids  = $($nsgRule.'destination_application_security_group_ids')
                    }
                    $nsgRules += $objNSGRule
                }

                # Check if the current NSG should be linked to a Storage Account
                If($($nsg.'Storage Account'))
                {
                    $storageAccountName = $($nsg.'Storage Account')
                }

                # Check if current NSG should be linked to a Log Analytics Workspace
                If($($nsg.'Log Analytics Workspace'))
                {
                    $lawName = $($nsg.'Log Analytics Workspace')
                }
                
                # Construct variable object for the current NSG
                $newNSGVarMember = [PSCustomObject]@{
                    name                                    = $($nsg.'NSG Name')            
                    rules                                   = @($($nsgRules))
                    network_watcher_name                    = $($nsg.'Network Watcher')
                    network_watcher_resource_group_name     = $($nsg.'Network Watcher Resource Group Name')
                    storage_account_id                      = "`$`{azurerm_storage_account.$($storageAccountName).id`}"
                    storage_account_logs_enabled            = $($nsg.'Enable Storage Acct Logs')
                    retention_policy_enabled                = $($nsg.'Enable Retention Policy')
                    retention_policy_days                   = $($nsg.'Retention Policy Days')
                    traffic_analytics_enabled               = $($nsg.'Enable Traffic Analytics')
                    traffic_analytics_interval_in_minutes   = $($nsg.'Traffic Analytics Interval (minutes)')
                    workspace_id                            = "`$`{azurerm_log_analytics_workspace.$($lawName).id`}"
                    workspace_region                        = "`$`{azurerm_log_analytics_workspace.$($lawName).location`}"
                    workspace_resource_id                   = "`$`{azurerm_log_analytics_workspace.$($lawName).resource_id`}"
                    enable_flow_log                         = $($nsg.'Enable Flow Log')
                    flow_log_version                        = $($nsg.'Flow Log Version')
                }
                # Append new resource node to the Variables PSCustomObject
                $objNSGVars | Add-Member -MemberType NoteProperty -Name "$($nsg.'NSG Name')" -Value $newNSGVarMember -Force            
            }
            
            # Save the current NSG module json file
            $objNSGModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.nsgs.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current NSG Auto Variables json file
            $objNSGVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.nsgs.auto.tfvars.json"
        }
    }
}

# Function to create Storage Accounts configurations
Function Set-StorageAccounts
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $storageAccountsManifest = Import-Excel -path $manifestPath -WorksheetName 'Storage Accounts'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.storage-accounts.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.storage-accounts.tf.json" -EA -0

    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually a Storage Accounts associated with the current Subscription
        if(($storageAccountsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.storage-accounts.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.storage-accounts.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.storage-accounts.auto.tfvars object
                    $objStorageVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objStorageVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.storage-accounts.auto.tfvars.json"
                    [PSCustomObject]$objStorageVars = Get-Content -Path "$stackDir/variables.storage-accounts.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objStorageVars = Get-Content -Path "$stackDir/variables.storage-accounts.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.storage-accounts.tf.json object
            if(!(Test-Path -Path "$stackDir/module.storage-accounts.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.vnets.tf.json object
                    $objStorageModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objStorageModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.storage-accounts.tf.json"
                    [PSCustomObject]$objStorageModule = Get-Content -Path "$stackDir/module.storage-accounts.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objStorageModule = Get-Content -Path "$stackDir/module.storage-accounts.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($storageAccount in ($storageAccountsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"
                
                $newStorageMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-storageaccount/"
                    providers = @{
                        azurerm = $providerAlias
                    }

                    name                        = "`$`{var.$($storageAccount.'Storage Account Name').name`}"
                    location                    = "`$`{azurerm_resource_group.$($storageAccount.'Resource Group').location`}"
                    resource_group_name         = "`$`{azurerm_resource_group.$($storageAccount.'Resource Group').name`}"
                    account_replication_type    = "`$`{var.$($storageAccount.'Storage Account Name').account_replication_type`}"
                    delete_retention_policy_days    = "`$`{var.$($storageAccount.'Storage Account Name').delete_retention_policy_days`}"
                    account_tier                = "`$`{var.$($storageAccount.'Storage Account Name').account_tier`}"
                    account_kind                = "`$`{var.$($storageAccount.'Storage Account Name').account_kind`}"
                    default_action              = "`$`{var.$($storageAccount.'Storage Account Name').default_action`}"
                    bypass                      = "`$`{var.$($storageAccount.'Storage Account Name').bypass`}"
                    allowed_ip_ranges           = "`$`{var.$($storageAccount.'Storage Account Name').allowed_ip_ranges`}"
                    allowed_virtual_network_subnet_ids    = "`$`{var.$($storageAccount.'Storage Account Name').allowed_virtual_network_subnet_ids`}"
                    containers                  = "`$`{var.$($storageAccount.'Storage Account Name').containers`}"
                    access_tier                 = "`$`{var.$($storageAccount.'Storage Account Name').access_tier`}"
                    
                }
                $objStorageModule.module | Add-Member -MemberType NoteProperty -Name $($storageAccount.'Storage Account Name') -Value $newStorageMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($storageAccount.'Storage Account Name') Workspace"
                    type = "object({location = string, resource_group_name  = string, name  = string, 
                        account_replication_type  = string, account_tier  = string, account_kind  = string, access_tier  = string,  
                        delete_retention_policy_days  = number, default_action  = string, bypass  = list(string),  
                        allowed_ip_ranges  = list(string), allowed_virtual_network_subnet_ids  = list(string), containers  = list(string)})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($storageAccount.'Storage Account Name')" -Value $newVariablesMember -Force            
                
                $newStorageVarMember = [PSCustomObject]@{
                    name                            = "$($storageAccount.'Storage Account Name')"
                    location                        = "`$`{azurerm_resource_group.$($storageAccount.'Resource Group').location`}"
                    resource_group_name             = "`$`{azurerm_resource_group.$($storageAccount.'Resource Group').name`}"
                    account_replication_type        = "$($storageAccount.'Account Replication Type')"
                    delete_retention_policy_days    = "$($storageAccount.'Storage Account Name')"
                    account_tier                    = "$($storageAccount.'Storage Account Tier')"
                    account_kind                    = "$($storageAccount.'Storage Account Type')"
                    default_action                  = "$($storageAccount.'Default Action')"
                    bypass                          = "$($storageAccount.'Bypass')"
                    allowed_ip_ranges               = "$($storageAccount.'Allowed ip Ranges')"
                    allowed_virtual_network_subnet_ids    = "$($storageAccount.'Allowed Virtual Network Subnet ids')"
                    containers                      = "$($storageAccount.'Containers')"
                    access_tier                     = "$($storageAccount.'Storage Access Tier')"
                }
                # Append new resource node to the Variables PSCustomObject
                $objStorageVars | Add-Member -MemberType NoteProperty -Name "$($storageAccount.'Storage Account Name')" -Value $newStorageVarMember -Force            
            }

            # Save the current VNET module json file
            $objStorageModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.storage-accounts.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objStorageVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.storage-accounts.auto.tfvars.json"
        }
    }
}

# Function to create Key Vault configurations
Function Set-KeyVaults
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType,
        [string]$tenantid
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $keyvaultsManifest = Import-Excel -path $manifestPath -WorksheetName 'KeyVaults'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.key-vaults.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.key-vaults.tf.json" -EA -0

    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually a Key Vault associated with the current Subscription
        if(($keyvaultsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.key-vault.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.key-vaults.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.key-vault.auto.tfvars object
                    $objKeyVaultVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objKeyVaultVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.key-vaults.auto.tfvars.json"
                    [PSCustomObject]$objKeyVaultVars = Get-Content -Path "$stackDir/variables.key-vaults.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objKeyVaultVars = Get-Content -Path "$stackDir/variables.key-vaults.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.key-vault.tf.json object
            if(!(Test-Path -Path "$stackDir/module.key-vaults.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.vnets.tf.json object
                    $objKeyVaultModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objKeyVaultModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.key-vaults.tf.json"
                    [PSCustomObject]$objKeyVaultModule = Get-Content -Path "$stackDir/module.key-vaults.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objKeyVaultModule = Get-Content -Path "$stackDir/module.key-vaults.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($keyVault in ($keyvaultsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"
                
                $newKeyVaultMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-keyvault/"
                    providers = @{
                        azurerm = $providerAlias
                    }
                    
                    name                                = "`$`{var.$($keyVault.'KeyVault Name').name`}"
                    resource_group_name                 = "`$`{azurerm_resource_group.$($keyVault.'Resource Group').name`}"
                    location                            = "`$`{azurerm_resource_group.$($keyVault.'Resource Group').location`}"
                    enabled_for_deployment              = "`$`{var.$($keyVault.'KeyVault Name').enabled_for_deployment`}"
                    enabled_for_disk_encryption         = "`$`{var.$($keyVault.'KeyVault Name').enabled_for_disk_encryption`}"
                    enabled_for_template_deployment     = "`$`{var.$($keyVault.'KeyVault Name').enabled_for_template_deployment`}"
                    enable_rbac_authorization           = "`$`{var.$($keyVault.'KeyVault Name').enable_rbac_authorization`}"
                    soft_delete_retention_days          = "`$`{var.$($keyVault.'KeyVault Name').soft_delete_retention_days`}"
                    purge_protection_enabled            = "`$`{var.$($keyVault.'KeyVault Name').purge_protection_enabled`}"
                    tenant_id                           = "`$`{var.$($keyVault.'KeyVault Name').tenant_id`}"
                    sku_name                            = "`$`{var.$($keyVault.'KeyVault Name').sku_name`}"
                    default_action                      = "`$`{var.$($keyVault.'KeyVault Name').default_action`}"
                    bypass                              = "`$`{var.$($keyVault.'KeyVault Name').bypass`}"
                    allowed_ip_ranges                   = "`$`{var.$($keyVault.'KeyVault Name').allowed_ip_ranges`}"
                    allowed_virtual_network_subnet_ids  = "`$`{var.$($keyVault.'KeyVault Name').allowed_virtual_network_subnet_ids`}"
                    enable_logs                         = "`$`{var.$($keyVault.'KeyVault Name').enable_logs`}"
                    diag_name                           = "`$`{var.$($keyVault.'KeyVault Name').diag_name`}"
                    storage_account_id                  = "`$`{var.$($keyVault.'KeyVault Name').storage_account_id`}"
                    retention_days                      = "`$`{var.$($keyVault.'KeyVault Name').retention_days`}"    
                    log_analytics_workspace_id          = "`$`{var.$($keyVault.'KeyVault Name').log_analytics_workspace_id`}"
                }       
                $objKeyVaultModule.module | Add-Member -MemberType NoteProperty -Name $($keyVault.'KeyVault Name') -Value $newKeyVaultMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($keyvault.'KeyVault Name') Workspace"
                    type = "object({name = string, enabled_for_deployment  = bool, enabled_for_disk_encryption  = bool, 
                        enabled_for_template_deployment  = bool, enable_rbac_authorization  = bool, soft_delete_retention_days  = number, purge_protection_enabled  = string,  
                        tenant_id  = string, tenant_id  = string, sku_name  = string, default_action  = string, bypass  = string,  allowed_ip_ranges  = list(any),  
                        allowed_virtual_network_subnet_ids  = list(any), enable_logs  = string,  diag_name  = string,  storage_account_id  = string,  retention_days  = number,  
                        log_analytics_workspace_id  = string})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($keyvault.'KeyVault Name')" -Value $newVariablesMember -Force

                # Get Allowed IP Address Ranges and turn the comma-separated lists into arrays
                $allowedIpRanges = @()
                if($($keyVault.'Allowed IP Ranges') -like "*,*")
                {
                    foreach($allowedIpRange in ($($keyVault.'Allowed IP Ranges')).Split(',').Trim())
                    {
                        $allowedIpRanges += $allowedIpRange
                    }
                }
                else{$allowedIpRanges += $($keyVault.'Allowed IP Ranges')}

                # Get Allowed Subnet IDs and turn the comma-separated lists into arrays
                $allowedSubnetIds = @()
                if($($keyVault.'Allowed Subnet IDs') -like "*,*")
                {
                    foreach($allowedSubnetId in ($($keyVault.'Allowed Subnet IDs')).Split(',').Trim())
                    {
                        $allowedSubnetIds += $allowedSubnetId
                    }
                }
                else{$allowedSubnetIds += $($keyVault.'Allowed Subnet IDs')}

                if($null -eq $($keyVault.'Enable Logs'))
                {
                    $enableLogs = $false
                }
                else{$enableLogs = $($keyVault.'Enable Logs')}

                $newKeyVaultVarMember = [PSCustomObject]@{
                    name                                = "$($keyVault.'KeyVault Name')"                    
                    enabled_for_deployment              = $($keyVault.'Enabled for Deployment')
                    enabled_for_disk_encryption         = $($keyVault.'Enabled for Disk Encryption')
                    enabled_for_template_deployment     = $($keyVault.'Enabled for Template Deployment')
                    enable_rbac_authorization           = $($keyVault.'Enable rbac Authorization')
                    soft_delete_retention_days          = $($keyVault.'Soft Delete Retention Days')
                    purge_protection_enabled            = $($keyVault.'Purge Protection Enabled')
                    tenant_id                           = "$($tenantid)"
                    sku_name                            = "$($keyVault.'SKU')"
                    default_action                      = "$($keyVault.'Default Action')"
                    bypass                              = "$($keyVault.'Network ACL Bypass')"
                    allowed_ip_ranges                   = $($allowedIpRanges)
                    allowed_virtual_network_subnet_ids  = $($allowedSubnetIds)
                    enable_logs                         = $enableLogs
                    diag_name                           = "$($keyVault.'Diag Name')"
                    storage_account_id                  = "$($keyVault.'Storage Account ID')"
                    retention_days                      = $($keyVault.'Retention Days')  
                    log_analytics_workspace_id          = "$($keyVault.'Log Analytics Workspace ID')"
                }
                # Append new resource node to the Variables PSCustomObject
                $objKeyVaultVars | Add-Member -MemberType NoteProperty -Name "$($keyvault.'KeyVault Name')" -Value $newKeyVaultVarMember -Force            
            }

            # Save the current VNET module json file
            $objKeyVaultModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.key-vaults.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objKeyVaultVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.key-vaults.auto.tfvars.json"
        }
    }
}

# Function to create Application Security Groups configurations
Function Set-ASGs
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath,
        [object]$stackDir,
        [string]$stackType
    )
    
    # Get the Stacks, VNETs, Subnets, and Subscriptions sheets from the Manifest
    $asgsManifest = Import-Excel -path $manifestPath -WorksheetName 'ASGs'
    $subscriptionsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subscriptions'
    $rsgsManifest = Import-Excel -path $manifestPath -WorksheetName 'Resource Groups'    
    $stackType = $stackType.ToLower()

    # Remove any existing VNET specific Terraform Files to prep for building new ones from scratch
    Remove-Item -Path "$stackDir/variables.asgs.auto.tfvars.json" -EA 0
    Remove-Item -Path "$stackDir/module.asgs.tf.json" -EA -0

    foreach($subscription in ($subscriptionsManifest | Where-Object {$_.'Stack Name' -eq $($stack.'Stack Name')}))
    {
        # Get the Subscription Name, Stack type, and create a Terraform Provider alias name from the Subscription Name and Stack Type, to ensure proper referencing of existing provider aliases in main.tf.json
        $subscriptionName = "$($subscription.'Subscription Name'.ToLower().Replace(' ',''))"

        # Only execute the following if there is actually a Applications Security Group associated with the current Subscription
        if(($asgsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group'}).count -gt 0)
        {
            # Create Stack variables.asgs.auto.tfvars.json object
            if(!(Test-Path -Path "$stackDir/variables.asgs.auto.tfvars.json" -PathType Leaf))
            {
                try
                {
                    # Create the root variables.asgs.auto.tfvars object
                    $objASGVars = [PSCustomObject]@{}
                    
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objASGVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.asgs.auto.tfvars.json"
                    [PSCustomObject]$objASGVars = Get-Content -Path "$stackDir/variables.asgs.auto.tfvars.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objASGVars = Get-Content -Path "$stackDir/variables.asgs.auto.tfvars.json" | ConvertFrom-Json -Depth 100
            }

            # Create module.asgs.tf.json object
            if(!(Test-Path -Path "$stackDir/module.asgs.tf.json" -PathType Leaf))
            {
                try
                {
                    # Create the root module.vnets.tf.json object
                    $objASGModule = [PSCustomObject]@{
                        module = @{}
                    }
                    # Save and re-import JSON file to ensure consistent functionality when adding members
                    $objASGModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.asgs.tf.json"
                    [PSCustomObject]$objASGModule = Get-Content -Path "$stackDir/module.asgs.tf.json" | ConvertFrom-Json -Depth 100
                }
                catch 
                {
                    Write-Error $_ 
                    exit 1
                }
            }
            else
            {
                [PSCustomObject]$objASGModule = Get-Content -Path "$stackDir/module.asgs.tf.json" | ConvertFrom-Json -Depth 100
            }

            # Get existing variables.tf.json object
            [PSCustomObject]$objVariables = Get-Content -Path "$stackDir/variables.tf.json" | ConvertFrom-Json -Depth 100

            foreach($asg in ($asgsManifest | Where-Object {($($rsgsManifest | Where-Object {$_.'Subscription Name' -eq $subscription.'Subscription Name'}).'Resource Group Name') -contains $_.'Resource Group' }))
            {            
                # Set the provider alias for the current subscription and stack
                $providerAlias = "azurerm.$($stackType)-$($subscriptionName)"
                
                # Create empty list of Network Interface IDs be default.
                ## ToDo: Once VM TF modules have been added to the project, add links between the VM and the ASG, and add code below to generate list of Network ID TF lookups per ASG
                $networkInterfaceIds = @()
                
                $newASGMember = [PSCustomObject]@{
                    source = "../../../../modules/az-lztf-mod-asg/"
                    providers = @{
                        azurerm = $providerAlias
                    }
                    resource_group_name     = "`$`{azurerm_resource_group.$($asg.'Resource Group').name`}"
                    location                = "`$`{azurerm_resource_group.$($asg.'Resource Group').location`}"
                    name                    = "`$`{var.$($asg.'ASG Name').name`}"
                    network_interface_id    = "`$`{var.$($asg.'ASG Name').network_interface_id`}"
                }       
                $objASGModule.module | Add-Member -MemberType NoteProperty -Name $($asg.'ASG Name') -Value $newASGMember
                
                # Add VNET parameters to variables.tf.json object
                $newVariablesMember = [PSCustomObject]@{
                    description = "Parameters to configure $($asg.'ASG Name') Workspace"
                    type = "object({name = string, network_interface_id  = list(string)})"
                }
                # Append new resource node to the Variables PSCustomObject
                $objVariables.variable | Add-Member -MemberType NoteProperty -Name "$($asg.'ASG Name')" -Value $newVariablesMember -Force            
                
                $newASGVarMember = [PSCustomObject]@{
                    name                                = "$($asg.'ASG Name')"
                    network_interface_id                = $networkInterfaceIds
                }
                # Append new resource node to the Variables PSCustomObject
                $objASGVars | Add-Member -MemberType NoteProperty -Name "$($asg.'ASG Name')" -Value $newASGVarMember -Force            
            }

            # Save the current VNET module json file
            $objASGModule | ConvertTo-Json -depth 100 | Out-File "$stackDir/module.asgs.tf.json"
            # Save the current Variables json file
            $objVariables | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.tf.json"
            # Save the current VNET Auto Variables json file
            $objASGVars | ConvertTo-Json -depth 100 | Out-File "$stackDir/variables.asgs.auto.tfvars.json"
        }
    }
}