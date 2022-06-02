<#
.SYNOPSIS
    Sets the registry keys to run an On Demand Scan

.DESCRIPTION
    Qualys Cloud Agent On Demand Scan

.NOTES
    Author:  Zak Clifford 
    Website: http://www.zsecure.uk
    Twitter: @zak_hax
    Version 1.0
    Created: 02 Jun 2022
    Updated: N/A
#>

# =============================================================================
# START OF CODE
# =============================================================================

# =============================================================================
# First step, check that the script is being ran as Administrator
# =============================================================================
$Admin=([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))

if (!$Admin) {
    write-host "This script is not being run as an Administrator." -ForegroundColor Red
    write-host "Re-launch as Admin to enable install?"
    write-host "[ENTER]" -NoNewline -foregroundcolor Red; write-host "/No, " -NoNewline; write-host "[Y]" -NoNewline -foregroundcolor Red; write-host "/Yes: " -NoNewline
    $choiceInput = read-host
    switch -Regex ($choiceInput) {
        default {
		Write-Host "Aborting install as this script must be ran as Administrator."
        Read-Host "Press any key to exit..."
		Exit
        }
        'A|a|Y|y' {
            # write our current directory to a hard file since admin launches in sys32
            $pwd.path | out-file "$env:TEMP\~TEMP.tmp"
            #relaunch the shell in admin-mode
            $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
            $newProcess.Arguments = "-executionpolicy bypass &'" + $script:MyInvocation.MyCommand.Path + "'"
            $newProcess.Verb = "runas";
            [System.Diagnostics.Process]::Start($newProcess);
            exit
        }
}
    write-host "`r"
} else {
    # congratulate the user
    write-host "The script is running as an Administrator." -ForegroundColor Cyan
	Read-Host "Press [ENTER] to continue..."
    write-host "`r"
    #search for the .tmp file, if it was found, load and delete it
    if (!(test-path "$env:TEMP\~TEMP.tmp")) {
        # do nothing, user launched powershell first and then the script
    } else {
        get-content "$env:TEMP\~TEMP.tmp" | cd
        Remove-Item "$env:TEMP\~TEMP.tmp"
        $CSScriptDir = $pwd.path
    }
}

Clear-Host 

# =============================================================================
# Enabling logging for the script and saving to c:\windows\temp
# =============================================================================
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | Out-Null
$ErrorActionPreference = "Continue"
Start-Transcript -Path C:\windows\temp\Qualys-Agent.txt -Append

function SetQualysRegKeys {
    New-Item -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand" -Name "Inventory"
    New-ItemProperty -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand\Inventory" -Name "ScanOnDemand" -Value "1"  -PropertyType DWord
    New-Item -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand" -Name Vulnerability
    New-ItemProperty -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand\Vulnerability" -Name "ScanOnDemand" -Value "1"  -PropertyType DWord
    New-Item -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand" -Name PolicyCompliance
    New-ItemProperty -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand\PolicyCompliance" -Name "ScanOnDemand" -Value "1"  -PropertyType DWord
}

$QualysRegKey = $false

Write-Host [=]
Write-Host [=]
Write-Host [+] Checking Qualys Registry Key Exists

$QualysRegKey = Test-Path -Path "HKLM:\SOFTWARE\Qualys\QualysAgent\ScanOnDemand" -ErrorAction SilentlyContinue

if($QualysRegKey -eq $false)
{
  Write-Host [=]
  Write-Host [=]
  Write-Host [x] The registry keys are missing, unable to set them. -ForegroundColor Red
  Write-Host [=]
  Write-Host [=]
  return 
}
else
{
 $QualysRegKey = $true
 Write-Host [=] Setting the On Demand Scan registry keys! -ForegroundColor Green
 SetQualysRegKeys
}

Write-Host [=]
Write-Host [=]
Write-Host [+] Qualys Scan On Demand reg keys have been set! -ForegroundColor Green
Write-Host [+] The Qualys agent will check the registry in ~3 minutes and perform an, On Demand Scan. -ForegroundColor Green
Write-Host [=]
Write-Host [=]
Write-Host [=]
Stop-Transcript
