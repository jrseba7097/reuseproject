# README

Powershell code to transform Architectural Manifests into a Terraform JSON file and exporting it to main.tf.json

Example PowerShell Testing - Azure Governance Landing Zone - LLD.xlsx input and main.tf.json output files are provided from a test run of the latest code

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

Powershell 7.x
Install the ImportExcel PowerShell Module from the Gallery: Install-Module -Name ImportExcel

## Inputs

1. Architects fill out the Google Sheet Manifest file located at *Google Drive location currently unknown*. 
2. This file will contain all of the resources needed for the Cloud Landing Zone, which is then downloaded from Google Drive as an Excel document, and then fed to the Process-CLZ_Manifest.ps1 file

Example: Process-CLZ_Manifest.ps1 *Manifest Name*.xlsx

## Outputs

main.tf.json

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
