# Azure Usability Project - Landing Zone, Terraform


## How to Use the Azure Reuse Project to Build Terraform from an LLD Google Sheet
### Step 1:
Clone the repo to an appropriate location for your client work:

The repo is located at https://github.com/cloudreach/az-lzauto-code

Because this repo uses submodules, you will want to include them when you clone the code.
<br>
`git clone git@github.com:cloudreach/az-lzauto-code.git --recurse-submodules`

### Step 2:
Remove the git references to prepare this code for a new repo.
Because this repo uses submodules, you will want to include them when you clone the code.
<br>
`cd az-lzauto-code`
<br>
`rm .gitmodules`
<br>
`find . -name .git -exec rm -rf {} \;`

### Step 3: 
Create a new repository for your client
Use the Github interface, Azure DevOps, or other repo management to create a repository. In our example, we will create it in Github.

### Step 4: 
Add code to repo :
<br>
`git init`
<br>
`git add .`
<br>
`git commit -m "Initial setup"`
<br>
`git remote add origin git@github.com:cloudreach/timnewclient1.git`
<br>
`git branch -M main`
<br>
`git push -u origin main`


### Step 5:
In a Powershell terminal, navigate to ***az-lzauto-code/automation***

### Step 6:
Download spreadsheet as Excel format and save it in ***az-lzauto-code/automation***.

A sample project landing zone LLD sheet can be found [here](https://docs.google.com/spreadsheets/d/18o62lXAsmGqrW2PI3ZXPJc4Jm5QsokmewUPtlgOORJU/edit#gid=581445993)

### Step 7:
From VS Code, execute the Powershell script ***Process-CLZ_Manifest.ps1*** using Run->Start Debugging (or F5) with the file open. A bug exists currently if you try to execute the script from the terminal, so that method is not recommended at this time.

This script will prompt you to select the spreadsheet to use. Then the script will allow you to build Terraform from the CLZ Manifest.  It will display the Tenant for you to confirm.

The script will then build out each stack in the ***stacks/az-lztf-stacks*** directory. The Terraform will be in JSON format (not HCL) but Terraform should be able to process it.

Once each stack is built, you’ll be prompted to quit. It’s safe to do so at this point.

You now have Terraform for a basic landing zone. Execute each stack and see the results. 
Note, additional work can be added to these folders, and should go into separate files (other than the ones that were auto-created).  If the Powershell script is run again, it will replace the existing files it plans to build, but should leave any other files alone.

Here’s a [video that walks through the execution of Step 7](https://drive.google.com/file/d/1XNX21yZ_GsfAJ5PYEbp82uNMyE5VNmvv/view?usp=sharing).
