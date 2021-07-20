# =============================================================================
# File Name: Qualys_CloudAgent_Check_Script.ps1
# =============================================================================
# Name: Qualys Cloud Agent Check Script
# Author: Zak Clifford 
# Contact:  zak@zsecure.uk
# Version 1.0
# Created: 20 Jul 2021
# Updated: N/A
# Description: Checks if Qualys Cloud Agent is installed in program files 
# Description: or if the QualysAgent process is running
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

$Qualysinstalled = $false
$Qualysproc = $false

Write-Host [+] Checking Qualys Cloud Agent is installed
Write-Host [=]
Write-Host [=]

$Qualysinstalled = Test-Path -Path "C:\Program Files\Qualys\QualysAgent\QualysAgent.exe" -ErrorAction SilentlyContinue
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
