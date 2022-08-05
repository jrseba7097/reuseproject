##### Dumps all Azure Built-in Roles to a CSV file for updating the Custom Roles sheet in Google Sheet -> https://docs.google.com/spreadsheets/d/1lwl1lbRoYA0hoG2BC3Ky2HOUgXoXZND2X5DDEfYFYok/edit?usp=sharing

$objRoles = @()

foreach($roleDef in Get-AzRoleDefinition)
{
    if($roleDef.Actions)
    {
        $roleActions = ([string]$roleDef.Actions).Replace(" ", ",")
    }
    else{$roleActions = [string]$roleDef.Actions}

    if($roleDef.NotActions)
    {
        $roleNotActions = ([string]$roleDef.NotActions).Replace(" ", ",")
    }
    else{[string]$roleDef.NotActions}

    if($roleDef.DataActions)
    {
        $roleDataActions = ([string]$roleDef.DataActions).Replace(" ", ",")
    }
    else{[string]$roleDef.DataActions}

    if($roleDef.NotDataActions)
    {
        $roleNotDataActions = ([string]$roleDef.NotDataActions).Replace(" ", ",")
    }
    else{[string]$roleDef.NotDataActions}


    
    $objRoleMember = [PSCustomObject]@{
        Name = $roleDef.Name
        Description = $roleDef.Description
        Actions = $roleActions
        NotActions = $roleNotActions
        DataActions = $roleDataActions
        NotDataActions = $roleNotDataActions
    }
    $objRoles += $objRoleMember
}



$objRoles | ConvertTo-Csv | Out-File "$PSScriptRoot/role-defs.csv"