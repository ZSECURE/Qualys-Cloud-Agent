# =============================================================================
# File Name: Qualys_CloudAgent_Uninstall_Script.ps1
# =============================================================================
# Name: Qualys Cloud Agent Uninstall Script
# Author: Zak Clifford 
# Contact:  zak@zsecure.uk
# Version 1.0
# Created: 20 Jul 2021
# Updated: N/A
# Description: Checks for installation of Qualys Cloud Agent then uninstalls it
# =============================================================================
# Function Change Log
# v1.0 - Creation of script
# =============================================================================
$ver = "1.0"

# =============================================================================
# START OF CODE
# =============================================================================

##Start of Script

# Enabling logging for the script and saving to c:\windows\temp
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\windows\temp\Qualys-Agent.txt -append

$Qualysinstalled = $false
$Qualysproc = $false

# Checking Qualys is installed
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

# Uninstalling the qualys agent
Start-Process -Wait -FilePath "$env:ProgramFiles\qualys\qualysagent\uninstall.exe" -ArgumentList "Uninstall=True Force=True" -passthru -ErrorAction SilentlyContinue

# Checking Qualys is not running and removed.
Write-Host [+] Checking Qualys Cloud Agent is installed
Write-Host [=]
Write-Host [=]

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

##End of Script
