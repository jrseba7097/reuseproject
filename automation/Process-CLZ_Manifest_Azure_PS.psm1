Function Show-PS_Menu 
{
    param (
        [string]$Title = 'PowerShell Scripted Automation'
    )
    Clear-Host
    Write-Host -ForegroundColor Cyan "================ $Title ================"
    
    Write-Host -ForegroundColor Green "1: Press '1' to deploy Route Tables from the Manifest to a deployed CLZ."
    Write-Host -ForegroundColor Green "2: Press '2' to deploy Network Security Groups from the Manifest to a deployed CLZ."
    Write-Host -ForegroundColor Green "G: Press 'G' to go back to Main Menu."
}

Function Get-Tenant_Info
{
    Param(
        [string]$title,
        [string]$tenantId
    )

    # Get Current Azure Context information and present to user for validation of correct environment login
    Write-Host $title
    Write-Host -ForegroundColor Cyan "Please verify the following Tenant information to ensure you are working in the correct customer environment..."
    $azContext = Get-AzContext
    Write-Host -ForegroundColor Green "#### Current Azure Context ####"
    Write-Host -ForegroundColor Green "Azure Tenant Id: $($azContext.Tenant)"
    Write-Host -ForegroundColor Green "Azure Context Name: $($azContext.Name)"
    Write-Host -ForegroundColor Green "Current Azure Subscription: $($azContext.Subscription)"
    Write-Host -ForegroundColor Green "Currently Logged in Account: $($azContext.Account)"
}

Function Add-Route_Tables
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath
    )

    # Get the Route Tables worksheet
    $routeTablesManifest = Import-Excel -path $manifestPath -WorksheetName 'Route Tables'

    # Get the Routes worksheet
    $routesManifest = Import-Excel -path $manifestPath -WorksheetName 'Routes'

    # Get the Routes worksheet
    $subnetsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subnets'

    # Loop through each of the rows in the 'Route Tables' worksheet
    Foreach($rt in ($routeTablesManifest | Where-Object {$_.'Deployment Responsibility' -eq 'Cloudreach'}))
    {
        # Set the Subscription Context to the Subscription for the current Route Table to be created in
        Set-AzContext -SubscriptionName $($rt.'Subscription Name')

        # Only add resource to the Terraform PSCustomObject if the Deployment Responsibility is Cloudreach
        if($rt.'Deployment Responsibility' -eq 'Cloudreach')
        {
            ###### Should write this code to check if the Route Table already exists in the Azure Subscription, and skip creation if it does ######
            Write-Host - -ForegroundColor Cyan "Creating Route Table: ""$($rt.'Route Table Name')""..."
            if($rt.'Completed' -ne 'Yes')
            {
                Try{
                    if($($rt.'Propagate Gateway Routes' -ne 'Yes'))
                    {
                        # Create Route Table with BGP Route Propagation disabled
                        $objRouteTable = New-AzRouteTable -Name $($rt.'Route Table Name') -ResourceGroupName $($rt.'Resource Group') -Location $($rt.'Region') -DisableBgpRoutePropagation
                    }
                    else
                    {
                        # Create Route Table with BGP Route Propagation enabled
                        $objRouteTable = New-AzRouteTable -Name $($rt.'Route Table Name') -ResourceGroupName $($rt.'Resource Group') -Location $($rt.'Region')
                    }    
                    
                    # Write status data back to Excel sheet
                    $rt.'Completed' = 'Yes'
                    $routeTablesManifest | Export-Excel -path $manifestPath -WorksheetName 'Route Tables'
                }
                Catch
                {
                    Write-Error $_ 
                    Write-Error "Unable to create Route Table: ""$($rt.'Route Table Name')"" in Resource Group: ""$($rt.'Resource Group')"" in Region: ""$($rt.'Region')"" for Subscription: ""$($rt.'Subscription Name')""." 
                    Write-Error "Check the Route Tables sheet in the source Manifest document, and verify that the information is correct, then try again"
                    exit 1
                }
            }
            else
            {                
                Write-Host -ForegroundColor Cyan "Resource deployment for ""$($rt.'Route Table Name')"" has already been completed. Skipping..."
                $objRouteTable = Get-AzRouteTable -Name $($rt.'Route Table Name') -ResourceGroupName $($rt.'Resource Group')
            }    
            
            ###### Should write this code to check if the route already exists in the Azure Subscription, and skip creation if it does ######
            # Loop through each of the rows in the 'Route Tables' worksheet that match the current Route Table name that was just created
            Foreach($route in ($routesManifest | Where-Object {$_.'Route Table' -eq $($rt.'Route Table Name')}))
            {
                if($route.'Completed' -ne 'Yes')
                {
                    Try
                    {
                        if($($route.'Next Hop Type') -eq 'VirtualAppliance')
                        {
                            # Add new Route to the current Route Table where the Next Hop is a Virtual Appliance
                            $objRouteTable | Add-AzRouteConfig -Name $($route.'Route Name') -AddressPrefix $($route.'Address Prefix') -NextHopType $($route.'Next Hop Type') -NextHopIpAddress $($route.'Next Hop Address') | Set-AzRouteTable 
                        }
                        else
                        {
                            # Add new Route to the current Route Table where the Next Hop is anything other than a Virtual Appliance
                            $objRouteTable | Add-AzRouteConfig -Name $($route.'Route Name') -AddressPrefix $($route.'Address Prefix') -NextHopType $($route.'Next Hop Type') | Set-AzRouteTable
                        }

                        # Write status data back to Excel sheet
                        $route.'Completed' = 'Yes'
                        $routesManifest | Export-Excel -path $manifestPath -WorksheetName 'Routes'
                    }
                    Catch
                    {
                        Write-Error $_ 
                        Write-Error "Unable to create custom Route: ""$($route.'Route Name')"" for Route Table: ""$($rt.'Route Table Name')"" in Resource Group: ""$($rt.'Resource Group')"" in Region: ""$($rt.'Region')"" for Subscription: ""$($rt.'Subscription Name')""." 
                        Write-Error "Check the Routes sheet in the source Manifest document, and verify that the information is correct, then try again"
                        exit 1
                    }
                }
                else
                {                
                    Write-Host -ForegroundColor Cyan "Route deployment for ""$($route.'Route Name')"" has already been completed. Skipping..."
                }
            }

            ######## Need to add code to check if Route Table is already associated with the current subnet and skip if it is #########
            # Attach UDR to related Subnets
            Foreach($subnet in ($subnetsManifest | Where-Object {$_.'Completed' -eq 'Yes' -and $_.'Route Table' -eq $($rt.'Route Table Name') -and $_.'Deployment Responsibility' -eq 'Cloudreach'}))
            {
                Write-Host "Attaching Route Table: ""$($rt.'Route Table Name')"" to Subnet: ""$($subnet.'Subnet Name')"" in Virtual Network: ""$($subnet.'VNET Name')""..."
                $VNet = Get-AzVirtualNetwork -Name $($subnet.'VNET Name')
                $VNetSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $($subnet.'Subnet Name')
                Set-AzVirtualNetworkSubnetConfig -Name $($VNetSubnet.'Name') -VirtualNetwork $VNet -AddressPrefix $($VNetSubnet.'AddressPrefix') -RouteTable $objRouteTable
                $VNet | Set-AzVirtualNetwork
            }
        }
        else
        {
            Write-Host -ForegroundColor Cyan "Deployment Responsibility for Route Table: ""$($rt.'Route Table Name')"" is set to ""$($rt.'Deployment Responsibility')"" instead of Cloudreach. Skipping..."
        } 
    }
}

Function Add-NSGs
{
    Param(
        # Parameter for taking the path to the Excel Manifest
        [string]$manifestPath
    )

    # Get the Route Tables worksheet
    $nsgManifest = Import-Excel -path $manifestPath -WorksheetName 'NSGs'

    # Get the Routes worksheet
    $nsgRulesManifest = Import-Excel -path $manifestPath -WorksheetName 'NSG Rules'

    # Get the Routes worksheet
    $subnetsManifest = Import-Excel -path $manifestPath -WorksheetName 'Subnets'

    # Loop through each of the rows in the 'Route Tables' worksheet
    Foreach($nsg in ($nsgManifest | Where-Object {$_.'Deployment Responsibility' -eq 'Cloudreach'}))
    {
        # Set the Subscription Context to the Subscription for the current Route Table to be created in
        Set-AzContext -SubscriptionName $($nsg.'Subscription Name')

        Write-Host - -ForegroundColor Cyan "Creating Network Security Group: ""$($nsg.'NSG Name')""..."         
        
        ###### Should write this code to check if the NSG already exists in the Azure Subscription, and skip creation if it does ######
        if($nsg.'Completed' -ne 'Yes')
        {
            Try{                
                # Create Route Table with BGP Route Propagation disabled
                $objNSG = New-AzNetworkSecurityGroup -Name $($nsg.'NSG Name') -ResourceGroupName $($nsg.'Resource Group') -Location $($nsg.'Region')
                
                # Write status data back to Excel sheet
                $nsg.'Completed' = 'Yes'
                $nsgManifest | Export-Excel -path $manifestPath -WorksheetName 'NSGs' -NoNumberConversion *
            }
            Catch
            {
                Write-Error $_ 
                Write-Error "Unable to create new Network Security Group: ""$($nsg.'NSG Name')"" in Resource Group: ""$($nsg.'Resource Group')"" in Region: ""$($nsg.'Region')"" for Subscription: ""$($nsg.'Subscription Name')""." 
                Write-Error "Check the NSGs sheet in the source Manifest document, and verify that the information is correct, then try again"
                exit 1
            }   
        }
        else
        {                
            Write-Host -ForegroundColor Cyan "Resource deployment for ""$($nsg.'NSG Name')"" has already been completed. Skipping..."
            $objNSG = Get-AzNetworkSecurityGroup -Name $($nsg.'NSG Name') -ResourceGroupName $($nsg.'Resource Group')
        }

        ###### Should write this code to check if the NSG rule already exists in the Azure Subscription, and skip creation if it does ######
        # Loop through each of the rows in the 'Route Tables' worksheet that match the current Route Table name that was just created
        Foreach($rule in ($nsgRulesManifest | Where-Object {$_.'NSG Name' -eq $($nsg.'NSG Name')}))
        {
            if($rule.'Completed' -ne 'Yes')
            {
                Try
                {                          
                    $sourcePrefix = ([string]($rule.'Source')).Split(",")
                    $sourcePortRange = ([string]($rule.'Source Port Range')).Split(",")
                    $destPrefix = ([string]($rule.'Destination')).Split(",")
                    $destPortRange = ([string]($rule.'Destination Port Range')).Split(",")                        

                    Add-AzNetworkSecurityRuleConfig -Name $($rule.'Rule Name') -Access $($rule.'Action') -Protocol $($rule.'Protocol') -Direction $($rule.'Direction') `
                        -Priority $($rule.'Priority') -SourceAddressPrefix $sourcePrefix -SourcePortRange $sourcePortRange -DestinationAddressPrefix $destPrefix `
                        -DestinationPortRange $destPortRange -NetworkSecurityGroup $objNSG | Set-AzNetworkSecurityGroup   
                    
                    # Write status data back to Excel sheet
                    $rule.'Completed' = 'Yes'
                    $nsgRulesManifest | Export-Excel -path $manifestPath -WorksheetName 'NSG Rules' -NoNumberConversion *
                }
                Catch
                {
                    Write-Error $_ 
                    Write-Error "Unable to create new Network Security Group Rule: ""$($rule.'Rule Name')"" for Network Security Group: ""$($nsg.'NSG Name')"" in Resource Group: ""$($nsg.'Resource Group')"" in Region: ""$($nsg.'Region')"" for Subscription: ""$($nsg.'Subscription Name')""." 
                    Write-Error "Check the NSG Rules sheet in the source Manifest document, and verify that the information is correct, then try again"
                    exit 1
                }
            }
            else
            {                
                Write-Host -ForegroundColor Cyan "Rule deployment for ""$($rule.'Rule Name')"" has already been completed. Skipping..."
            }                
        }

        ######## Need to add code to check if NSG is already associated with the current subnet and skip if it is #########
        # Attach NSG to related Subnets
        Foreach($subnet in ($subnetsManifest | Where-Object {$_.'Completed' -eq 'Yes' -and $_.'NSG' -eq $($nsg.'NSG Name') -and $_.'Deployment Responsibility' -eq 'Cloudreach'}))
        {
            Write-Host "Attaching NSG: ""$($nsg.'NSG Name')"" to Subnet: ""$($subnet.'Subnet Name')"" in Virtual Network: ""$($subnet.'VNET Name')""..."
            $VNet = Get-AzVirtualNetwork -Name $($subnet.'VNET Name')
            $VNetSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $($subnet.'Subnet Name')
            Set-AzVirtualNetworkSubnetConfig -Name $($VNetSubnet.'Name') -VirtualNetwork $VNet -AddressPrefix $($VNetSubnet.'AddressPrefix') -NetworkSecurityGroup $objNSG
            $VNet | Set-AzVirtualNetwork
        } 
    }
}