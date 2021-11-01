# =============================================================================
# File Name: Qualys_CloudAgent_Install_Script.ps1
# =============================================================================
# Name: Qualys Cloud Agent Install Script
# Author: Zak Clifford 
# Contact:  zak@zsecure.uk
# Version 1.0
# Created: 20 Jul 2021
# Updated: N/A
# Description: Checks for exisiting install of Qualys Cloud Agent then installs
# Description: if it's not found
# =============================================================================
# Function Change Log
# v1.0 - Creation of script
# =============================================================================
$ver = "1.0"

# =============================================================================
# START OF CODE
# =============================================================================

##Start of Script

# Enabling loggin for the script and saving to c:\windows\temp
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\windows\temp\Qualys-Agent.txt -append

# Setting script location as path
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location -Path $dir

$Qualysinstalled = $false
$Qualysproc = $false

# Setting Variables
$GetContents = Get-Content -Path ./activation.txt
$CustID = $GetContents[0]
$ActiID = $GetContents[1]
$WebURI = $GetContents[2]

$arguments = "CustomerId={" + $CustID + "} ActivationId={" + $ActiID + "} WebServiceUri=" + $WebURI

# Installing the Qualys cloud agent
Write-Host [+] Installing the Qualys cloud agent
Write-Host [=]
Write-Host [=]
Start-Process -Wait -FilePath ".\QualysCloudAgent.exe" -ArgumentList $arguments -passthru 

$Qualysinstalled = Test-Path -Path "C:\Program Files\Qualys\QualysAgent\QualysAgent.exe"
$Qualysproc = Get-Process -Name QualysAgent -ErrorAction SilentlyContinue | Select ProcessName,Id
if($Qualysproc -eq $null)
{
 $Qualysproc = $false
}
else
{
 $Qualysproc = $true
}

Write-Host [+] Qualys is installed at C:\Program Files\Qualys\QualysAgent\QualysAgent.exe : $Qualysinstalled
Write-Host [=]
Write-Host [=]
Write-Host [+] Qualys is running : $Qualysproc
Write-Host [=]
Write-Host [=]
Stop-Transcript

# End of Script
