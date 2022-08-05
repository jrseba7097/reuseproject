# README

Powershell code to gather Azure Configuration information for use in the Google Sheet Template

Examples:
Convert-AzLocationsToCSV.ps1 - Gets all Azure Locations and generates a CSV file with both the long and short location names for populating the Selection Lists sheet in the Google Sheet Template file at https://drive.google.com/drive/u/0/folders/1ElCIvQq2HuutQsQtOufRUcW1hGdFdrjE

Convert-AzRoleDefinitionsToCSV.ps1 - Gets all built-in Azure Role Definitions and converts to CSV format for use in populating the Custom Roles sheet in the Google Sheet Template file at https://drive.google.com/drive/u/0/folders/1ElCIvQq2HuutQsQtOufRUcW1hGdFdrjE

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

## Outputs

regions.csv
role-defs.csv

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
