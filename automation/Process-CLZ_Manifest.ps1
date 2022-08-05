Param(
    [string]$manifestPath
)

$ErrorActionPreference = "Stop"

if($manifestPath -eq "")
{
    $excelFiles = Get-ChildItem -Path $PSScriptRoot | Where-Object {$_.Name -like "*.xlsx"}

    if($excelFiles)
    {
        Write-Host -ForegroundColor Cyan "Found the following Excel files in the script folder."
        $menu = @{}
        for ($i=1;$i -le $excelFiles.count; $i++) 
        { 
            Write-Host "$i. $($excelFiles[$i-1].name)"
            $menu.Add($i,($excelFiles[$i-1].name)) 
        }

        [int]$ans = Read-Host 'Enter the number of the file to process...'
        $manifestPath = "$PSScriptRoot/$($menu.Item($ans))"
    }
    else {
        throw "No Excel file found! Please ensure you have downloaded an Excel file manifest to the script folder, and try again..."
    }    
}

if(!(Test-Path $manifestPath))
{
    Write-Error "Manifest file not found at Path: ""$($manifestPath)"""
}

# Check PowerShell is version 7.x or above
Write-Host -ForegroundColor Cyan "Checking installed PowerShell version for compatibility..."
try 
{   
    if($($PSVersionTable.PSVersion.Major) -lt 7)
    {
        throw "Detected PowerShell Version: ""$($PSVersionTable.PSVersion)"". This script requires a minimum of PowerShell 7.x. Please check your PowerShell installation and try again..."        
    }
    else
    {
        Write-Host -ForegroundColor Green "Found PowerShell version: ""$($PSVersionTable.PSVersion)"". Continuing..."
        
        # Check if ImportExcel Module is installed
        If((Get-InstalledModule -Name ImportExcel -EA 0))
        {
            Write-Host -ForegroundColor Green "Found ImportExcel Module. Importing..."   
            Import-Module -Name ImportExcel         
        }
        else 
        {
            Write-Host -ForegroundColor Yellow "ImportExcel Module not found or not installed. Installing..."
            Install-Module -Name ImportExcel
            Write-Host -ForegroundColor Green "ImportExcel Module installed successfully!" 
            Write-Host -ForegroundColor Yellow "Please restart your PowerShell session to ensure modules are loaded properly..."
            exit 0
        }
    }
}
catch 
{
    Write-Error $_ 
    exit 1
}
Function Show-Main_Menu {
    param (
        [string]$Title = 'Cloud Landing Zone Automation'
    )
    Clear-Host
    Write-Host -ForegroundColor Cyan "================ $Title ================"
    
    Write-Host -ForegroundColor Green "1: Press '1' to build Terraform from the CLZ Manifest."
    #Write-Host -ForegroundColor Green "2: Press '2' to Execute PowerShell Automated Deployments from the CLZ Manifest."
    Write-Host -ForegroundColor Green "Q: Press 'Q' to quit."
}

# Open Excel based Manifest
$HLDManifest = Open-ExcelPackage -path $manifestPath

# Get platform form the HLD Design Decisions worksheet
$platform = $HLDManifest.'HLD Design Decisions'.Cells["B1"].value
$terraformVersion = $HLDManifest.'HLD Design Decisions'.Cells["B2"].value
Close-ExcelPackage -ExcelPackage $HLDManifest -NoSave

# Load Platform specific Custom Modules
Import-Module "$PSScriptRoot/Process-CLZ_Manifest_$($platform)_TF" -Force
Import-Module "$PSScriptRoot/Process-CLZ_Manifest_$($platform)_PS" -Force

if($platform -eq "Azure")
{
    do
    {    
        # Present menu to user, and take input
        Show-Main_Menu
        $mainSelection = $(Write-Host -ForegroundColor Yellow "Select from the tasks above: " -NoNewLine; Read-Host)
        Write-Host ""

        switch ($mainSelection) 
        {
            '1' 
            {      
                $stacksManifest = Import-Excel -path $manifestPath -WorksheetName 'Stacks'
                
                $tenantId = Test-TenantSheet -manifestPath $manifestPath

                Test-SubscriptionsSheet -manifestPath $manifestPath
               
                [object]$governanceStackDir = Get-StackDir -stackName "" -stackType "Governance"
                # Setup Governance Stack for Management Groups, Policies, and Custom RBAC Roles
                Initialize-GovernanceStack -terraformVersion $terraformVersion -manifestPath $manifestPath -stackDir $governanceStackDir -tenantId $tenantId
                Set-ManagementGroups -manifestPath $manifestPath -stackDir $governanceStackDir
                Set-CustomRbacRoles -manifestPath $manifestPath -stackDir $governanceStackDir
                # Set-CustomPolicies
                
                Foreach($stack in $stacksManifest )
                {
                    $stackName = $($stack.'Stack Name')
                    $stackType = $($stack.'Stack Type')

                    [object]$stackDir = Get-StackDir -stackName $stackName -stackType $stackType

                    Write-Host -ForegroundColor Cyan "Processing Stack: ""$stackName"" of Type: ""$stackType"""

                    # Setup Terraform Provider data in the PSObject
                    Initialize-Stack -terraformVersion $terraformVersion -manifestPath $manifestPath -stackDir $stackDir -tenantId $tenantId -stackType $stackType -stackName $stackName

                    # Process Resource Groups
                    Set-ResourceGroups -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process VNETs and SubNets
                    Set-VNETs -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process Log Analytics Workspaces
                    Set-LogAnalyticsWorkspaces -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process Azure Bastion Configurations
                    Set-Bastions -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process Azure Bastion Configurations
                    Set-RecoveryVaults -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process Key Vaults
                    Set-KeyVaults -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType -tenantId $tenantId

                    # Process ASGs
                    Set-ASGs -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process Storage Accounts
                    Set-StorageAccounts -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process NSG Configurations
                    Set-NSGs -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType

                    # Process Azure Bastion Configurations
                    # Set-StorageAccounts -manifestPath $manifestPath -stackDir $stackDir -stackType $stackType          
                }   
            }
            <#'2'
            {                
                # Get Tenant Information and present user with a menu to select whether to Continue, Login as a different user, or Go back to main menu
                Connect-AzAccount -TenantId $tenantId
                $title = "Getting Current Tenant Context Info..."
                Get-Tenant_Info -Title $title -TenantId $tenantId
                pause                         

                do
                {
                    # Present menu to user, and take input
                    Show-PS_Menu                
                    $psSelection = $(Write-Host -ForegroundColor Yellow "Select from the PowerShell scripted tasks above: " -NoNewLine; Read-Host)
                    Write-Host ""

                    switch ($psSelection)
                    {
                        '1'
                        {
                            Add-Route_Tables $manifestPath
                        }
                        '2'
                        {
                            Add-NSGs $manifestPath                                        
                        }
                        'G'
                        {
                            Write-Host "Going back to main menu..."
                        }
                        Default {Write-Host -ForegroundColor Yellow "Unknown response! Returning to menu..."}
                    }
                }
                until($psSelection -eq 'G')
            }#>        
            'Q'
            {
                Write-Host "Quitting..."
            }
            Default {Write-Host -ForegroundColor Yellow "Unknown response! Returning to menu..."}
        }
    }
    until($mainSelection -eq 'q')
}
elseif($platform -eq "AWS")
{
    
}
elseif($platform -eq "GCP")
{
    
}