##### Dumps all Azure Locations to a CSV file for updating the Regions columns in the 'Selection Lists' sheet in Google Sheet -> https://docs.google.com/spreadsheets/d/1lwl1lbRoYA0hoG2BC3Ky2HOUgXoXZND2X5DDEfYFYok/edit?usp=sharing

$csv = @()
$locations = Get-AzLocation | Select-Object DisplayName, Location
ForEach($location in $locations)
{
    $newRecord = [PSCustomObject]@{
        DisplayName = $location.DisplayName
        Location = $location.Location
    }
    
    $csv += $newRecord
}
    
$csv | ConvertTo-CSV | out-file "./regions.csv"  