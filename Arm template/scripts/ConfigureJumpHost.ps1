Function Start-Logging {
<#
.Synopsis
    Create transcript to c:\logs
.Description
    This function will create create the c:\logs directory if it doesn't exist
    and start logging to the name of the scrip file with a ".log" extension
.Parameter Name
    Optional Name in lieu of the script filename.  I noticed when running a script 
    in the job (or task) scheduler $MyInvocation.PSCommandPath returns nothing.
#>
Param ([string] $name)

    # name overrides scriptname 
    $scriptname = split-path $MyInvocation.PSCommandPath -Leaf
    If ($scriptname -eq "") {$scriptname = "Start-Logging"}
    If ($name -eq "") {$name=$scriptname}

    # create c:\logs if it isn't there
    $logdir = "c:\logs"
    if(!(Test-Path $logdir)) {
        New-Item -Path $logdir -ItemType Directory -Force | Out-Null;
        Write-Output "Created directory $logdir"
        } 
    
    # setup the transcript log
    $logfile = "$logdir" + "\" + $scriptname + ".log"
    Start-Transcript -Path $logfile -Append -NoClobber
    Write-Output "$(get-date) Starting Transcript"
}

# YEA - YIPPPEEE we have ConfigureJumphost logs visible after reboot - WOOT
Start-Logging -Name "ConfigureJumphost";



<# Custom Script for Windows #>

filter timestamp {"$(Get-Date -Format G): $_"}

$temploc = "D:\Temp"
$tempc = "C:\Temp"

New-Item -ItemType directory -Path "C:\temp"

Get-ChildItem -Recurse -Path 'C:\Packages' -Include 'Immersion.psm1' | Select -First 1 | Import-Module
$config = Get-CustomScriptConfig
$Computername = $env:COMPUTERNAME
$Username = $config.public.vmLocalUserName
$vmLocalUserEmail = $config.public.vmLocalUserEmail
$PlainPassword = $config.private.vmLocalUserPassword 
$Password = ConvertTo-SecureString $PlainPassword -AsPlainText -Force
$subscriptionId = $config.public.subscriptionId
$subscriptionName = $config.public.subscriptionName
$ResourceGroupName = $config.public.resourceGroupName
Write-Output "Username set to $Username"
Write-Output "vmLocalUserEmail set to $vmLocalUserEmail"
Write-Output "PlainPassword set to $PlainPassword"
Write-Output "subscriptionId set to $subscriptionId"
Write-Output "subscriptionName set to $subscriptionName"
Write-Output "resourceGroupName set to $resourceGroupName"

# Save the credentials to a file
$PlainPassword | Out-File -FilePath "c:\temp\password.txt" -Append -Force -NoClobber
$vmLocalUserEmail | Out-File -FilePath "c:\temp\email.txt" -Append -Force -NoClobber
$subscriptionId | Out-File -FilePath "c:\temp\subid.txt" -Append -Force -NoClobber
$ResourceGroupName | Out-File -FilePath "c:\temp\rg.txt" -Append -Force -NoClobber
$Username | Out-File -FilePath "c:\temp\Username.txt" -Append -Force -NoClobber


#####################################################################
## Windows 10 
#####################################################################

#####################################################################
## remove win 10 apps

Get-AppxPackage king.com.CandyCrushSaga | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage Microsoft.People | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage Microsoft.Windows.Photos | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage
Get-AppxPackage microsoft.windowscommunicationsapps | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage _solitairecollection_ | Remove-AppxPackage
Get-AppxPackage _officehub_ | Remove-AppxPackage
Get-AppxPackage _3dbuilder_ | Remove-AppxPackage
Get-AppxPackage _windowscamera_ | Remove-AppxPackage
Get-AppxPackage _getstarted_ | Remove-AppxPackage
Get-AppxPackage _photo_ | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsStore | Remove-AppxPackage
Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage
Get-AppxPackage *officehub* | Remove-AppxPackage
Get-AppxPackage *windowsmaps* | Remove-AppxPackage
Get-AppxPackage *windowscamera* | Remove-AppxPackage
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage *windowsalarms* | Remove-AppxPackage
Get-AppxPackage *3dbuilder* | Remove-AppxPackage
Get-AppxPackage *skypeapp* | Remove-AppxPackage
Get-AppxPackage *getstarted* | Remove-AppxPackage
Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
Get-AppxPackage *bingfinance* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
Get-AppxPackage *bingnews* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
Get-AppxPackage *people* | Remove-AppxPackage
Get-AppxPackage *windowsphone* | Remove-AppxPackage
Get-AppxPackage *photos* | Remove-AppxPackage
Get-AppxPackage *windowsstore* | Remove-AppxPackage
Get-AppxPackage *bingsports* | Remove-AppxPackage
Get-AppxPackage *soundrecorder* | Remove-AppxPackage
Get-AppxPackage *bingweather* | Remove-AppxPackage
Get-AppxPackage *xboxapp* | Remove-AppxPackage


# https://scribbleghost.net/467/customize-windows-10-default-user-profile-registry/

#Load default registry hive
& reg load HKLM\DEFAULT C:\Users\Default\NTUSER.DAT

# Advertising ID
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
#Delivery optimization, disabled
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v SystemSettingsDownloadMode /t REG_DWORD /d 3 /f
# Show titles in the taskbar
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarGlomLevel /t REG_DWORD /d 1 /f
# Hide system tray icons
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 1 /f
# Show known file extensions
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
# Show hidden files
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f
# Change default explorer view to my computer
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
# Disable most used apps from appearing in the start menu
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f
# Remove search bar and only show icon
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f
# Show Taskbar on one screen
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v MMTaskbarEnabled /t REG_DWORD /d 0 /f
# Disable Security and Maintenance Notifications
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v Enabled /t REG_DWORD /d 0 /f
# Hide Windows Ink Workspace Button
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /v PenWorkspaceButtonDesiredVisibility /t REG_DWORD /d 0 /f
# Disable Game DVR
reg add "HKLM\DEFAULT\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
# Show ribbon in File Explorer
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v MinimizedStateTabletModeOff /t REG_DWORD /d 0 /f
 
# Hide Taskview button on Taskbar
write-output "Hide Taskview button on Taskbar"
New-ItemProperty -Path 'HKLM:\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowTaskViewButton -value 0 -Force
 
# Hide People button from Taskbar
write-output "Hide People button from Taskbar"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name People -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name PeopleBand -value 0 -Force
 
# Remove Edge Icon from desktop
write-output "Remove Edge Icon from desktop"
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name DisableEdgeDesktopShortcutCreation -value 1 -Force
 
write-output "Remove OneDrive Setup from the RUN key"
reg delete "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /F
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
# Disable OneDrive via Group Policies"
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1
 
# Disable Notification Center
write-output "Disable Notification Center"
New-Item -Path 'HKLM:\DEFAULT\Software\Policies\Microsoft\Windows' -Name Explorer -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\Software\Policies\Microsoft\Windows\Explorer' -Name DisableNotificationCenter -value 1 -Force

write-output "Disable Security and Maintenance Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.SecurityAndMaintenance -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance' -Name Enabled -value 0 -Force

write-output "Disable OneDrive Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.SkyDrive.Desktop -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.SkyDrive.Desktop' -Name Enabled -value 0 -Force

write-output "Disable Photos Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.Windows.Photos_8wekyb3d8bbwe!App -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Photos_8wekyb3d8bbwe!App' -Name Enabled -value 0 -Force

write-output "Disable Store Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.WindowsStore_8wekyb3d8bbwe!App -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.WindowsStore_8wekyb3d8bbwe!App' -Name Enabled -value 0 -Force

write-output "Disable Suggested Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.Suggested -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested' -Name Enabled -value 0 -Force

write-output "Disable Calendar Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar' -Name Enabled -value 0 -Force

write-output "Disable Cortana Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI' -Name Enabled -value 0 -Force

write-output "Disable Mail Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail' -Name Enabled -value 0 -Force

write-output "Disable Edge Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge' -Name Enabled -value 0 -Force

write-output "Disable Audio Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.AudioTroubleshooter -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AudioTroubleshooter' -Name Enabled -value 0 -Force

write-output "Disable Autoplay Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.AutoPlay -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay' -Name Enabled -value 0 -Force

write-output "Disable Battery Saver Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.BackgroundAccess -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BackgroundAccess' -Name Enabled -value 0 -Force

write-output "Disable Bitlocker Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.BdeUnlock -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BdeUnlock' -Name Enabled -value 0 -Force

write-output "Disable News Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.BingNews_8wekyb3d8bbwe!AppexNews -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.BingNews_8wekyb3d8bbwe!AppexNews' -Name Enabled -value 0 -Force

write-output "Disable Settings Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel' -Name Enabled -value 0 -Force

write-output "Disable Tablet Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.System.Continuum -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.System.Continuum' -Name Enabled -value 0 -Force

write-output "Disable VPN Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.RasToastNotifier -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.RasToastNotifier' -Name Enabled -value 0 -Force

write-output "Disable Windows Hello Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.HelloFace -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.HelloFace' -Name Enabled -value 0 -Force

write-output "Disable Wireless Notifications"
New-Item -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.WiFiNetworkManager -Force
New-ItemProperty -Path 'HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager' -Name Enabled -value 0 -Force


############################################################################################

# Disbales Network discovery popup
write-output "Disbales Network discovery popup"
netsh advfirewall firewall set rule group="Network Discovery" new enable=No

# Remove survey link on desktop
Remove-Item -Path "C:\Users\Public\Desktop\Short survey to provide input on this VM..url"

# Remove Edge Icon from desktop
write-output "Remove Edge Icon from desktop"
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name DisableEdgeDesktopShortcutCreation -value 1 -Force

# Disable Notification Center
write-output "Disable Notification Center"
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows' -Name Explorer -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name DisableNotificationCenter -value 1 -Force

# Disbales Firewall
#write-output "Disbales Firewall"
#Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Disable Windows Defender
#New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name DisableAntiSpyware -value 1 -Force

#Remove shield Icon in tray
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name "SecurityHealth" -Force

#Disable All Notifications from Windows Security
#NOT WORKING
#New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications' -Name DisableNotifications  -value 1 -Force

# Disable Privacy Settings Experience at Sign-in
write-output "Disable Privacy Settings Experience at Sign-in"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name OOBE -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE' -Name DisablePrivacyExperience -value 1 -Force

# Disbales Network discovery popup
write-output "Disbales Network discovery popup"
netsh advfirewall firewall set rule group="Network Discovery" new enable=No
New-Item -Path 'HKLM:\System\CurrentControlSet\Control\Network' -Name NewNetworkWindowOff -Force

# disable Cortana
write-output "disable Cortana"
   $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"     
    IF(!(Test-Path -Path $path)) {  
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search" 
    }  
    Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0  
    #Restart Explorer to change it immediately     
    #Stop-Process -name explorer

# Hide WindowsInkWorkspace
write-output "Hide WindowsInkWorkspace"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name WindowsInkWorkspace -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace' -Name AllowWindowsInkWorkspace -value 0 -Force

# Disable Notification Center
write-output "Disable Notification Center"
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows' -Name Explorer -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name DisableNotificationCenter -value 1 -Force

# Hide TaskViewButton
write-output "Hide TaskViewButton"
New-ItemProperty -Path 'HKLM:\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowTaskViewButton -value 0 -Force

#Edge (link to Azure portal) This creates a Desktop shortcut to the Azure portal and uses the Edge icon.
write-output "Edge (link to Azure portal)"
$ShortcutFile = "$env:Public\Desktop\Azure portal.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.WindowStyle = "3" 
$Shortcut.IconLocation = "%windir%\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe" 
$Shortcut.TargetPath = "https://portal.azure.com" 
$Shortcut.Save()

# Disable WindowsUpdates Download
write-output "Disable WindowsUpdates Download"
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name NoAutoUpdate -value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name AUOptions -value 2 -Force

#####################################################################
## Post install script to run as user - win10user.ps1

# Copy win10user.ps1
Write-Output "Copy win10user.ps1"
Copy-Item -Path 'D:\Temp\win10user.ps1' -Destination "C:\Temp"

#### This now runs in the Set AutoadminLogin and Run Once section
<#
# Create a scheduled task to run win10user.ps1 on logon
Write-Output "Create a scheduled task to run win10user.ps1 on logon"
$TaskName = "win10user"
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-Executionpolicy unrestricted -NoProfile -WindowStyle Hidden -Command C:\Temp\win10user.ps1'
#$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger = New-ScheduledTaskTrigger -AtLogon
#$trigger.Delay = 'PT30S'
$principal = New-ScheduledTaskPrincipal -GroupID "BUILTIN\Users" -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "win10user" -Principal $principal
#>

#####################################################################
## install chocolatey package manager and packages
#####################################################################
Write-Output "install chocolatey package manager and packages"

#Install NuGet
Write-Output "Install NuGet"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#install chocolatey package manager for Windows
Write-Output "install chocolatey"
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

#choco install netfx-4.7.1-devpack -y

# choco install putty
#choco install putty -y

# choco install winscp
#choco install winscp -y

# choco install Azure-cli
#Write-Output "choco install Azure-cli"
#choco install azure-cli -y

# choco install azure powershell
Write-Output "choco install azure powershell"
choco install azurepowershell -y

##chocolatey - install SQL Server Management Studio
Write-Output "chocolatey - install SQL Server Management Studio"
choco install sql-server-management-studio --version 14.0.17289.1 -y

#chocolatey - Git (Install) - required for SQL Operations Studio 
Write-Output "chocolatey - Git (Install) - required for SQL Operations Studio "
choco install git.install -y

# #chocolatey - install SQL Operations Studio
Write-Output "chocolatey - install SQL Operations Studio"
choco install sql-operations-studio -y

#chocolatey - install PowerBI
Write-Output "chocolatey - install PowerBI"
choco install powerbi -y --ignore-checksums

## install Visual Studio 2015
#choco install visualstudio2015professional -y --execution-timeout 3600

#choco install dotnetcore --version 1.0.0 -y

#choco install windowsazurelibsfornet -y

## install Visual Studio with all available workloads and optional components
#choco install visualstudio2017professional -y --execution-timeout 3600 --package-parameters "--allWorkloads --includeRecommended --includeOptional --locale en-US"

## chocolatey - install Visual Studio 2017 Professional
## https://chocolatey.org/packages/visualstudio2017enterprise
#Write-Output "Visual Studio 2017"
#choco install visualstudio2017professional -y

## chocolatey - install .NET Desktop Development workload for Visual Studio 2017
## https://chocolatey.org/packages/visualstudio2017-workload-manageddesktop
#Write-Output ".NET Desktop Development workload for Visual Studio 2017"
#choco install visualstudio2017-workload-manageddesktop -y

## chocolatey - install Azure development workload for Visual Studio 2017
## https://chocolatey.org/packages/visualstudio2017-workload-azure
#Write-Output "install Azure development workload for Visual Studio 2017"
#choco install visualstudio2017-workload-azure -y

#chocolatey - install Microsoft SQL Server Data Tools for Visual Studio 2017
#choco install ssdt17 -y

#chocolatey - install Google Chrome
#Write-Output "Google Chrome"
#choco install googlechrome -y --ignore-checksums

Write-Output "END install chocolatey package manager and packages"

#####################################################################
## Create Desktop Icons for installed packages
#####################################################################

## sql-server-management-studio desktop shortcut
$TargetFile = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
$ShortcutFile = "$env:Public\Desktop\SSMS.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.TargetPath = $TargetFile 
$Shortcut.Save()

## VS desktop shortcut
#$TargetFile = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"
#$ShortcutFile = "$env:Public\Desktop\Visual Studio 2017.lnk" 
#$WScriptShell = New-Object -ComObject WScript.Shell 
#$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
#$Shortcut.TargetPath = $TargetFile 
#$Shortcut.Save()

# Putty desktop shortcut
#$TargetFile = "C:\ProgramData\chocolatey\bin\PUTTY.EXE"
#$ShortcutFile = "$env:Public\Desktop\PUTTY.lnk" 
#$WScriptShell = New-Object -ComObject WScript.Shell 
#$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
#$Shortcut.TargetPath = $TargetFile 
#$Shortcut.Save()

#####################################################################
## Create users and add to groups
#####################################################################

#Create User
$ADSIComp = [adsi]"WinNT://$Computername"
$NewUser = $ADSIComp.Children | ? {$_.SchemaClassName -eq 'User' -and $_.Name -eq $Username};
if (!$NewUser) {
  $NewUser = $ADSIComp.Create('User',$Username)
}

#Create password
$BSTR = [system.runtime.interopservices.marshal]::SecureStringToBSTR($Password)
$_password = [system.runtime.interopservices.marshal]::PtrToStringAuto($BSTR)

#Set password on account 
$NewUser.SetPassword(($_password))
$NewUser.SetInfo()

#Add user to Local Administrators Group
$AdminGroup = [ADSI]"WinNT://$Computername/Administrators,group"
$User = [ADSI]"WinNT://$Computername/$Username,user"
if (!($AdminGroup.Members() | ? {$_.Name() -eq $Username})) {
  $AdminGroup.Add($User.Path)
}

#Add user to Remote Desktop
$RDPGroup = [ADSI]"WinNT://$Computername/Remote Desktop Users,group"
$User = [ADSI]"WinNT://$Computername/$Username,user"
if (!($RDPGroup.Members() | ? {$_.Name() -eq $Username})) {
  $RDPGroup.Add($User.Path)
}

#Set account to never expire
$User.UserFlags.value = $user.UserFlags.value -bor 0x10000
$User.CommitChanges()

#Setting logon picture to block colour
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
$Name = "DisableLogonBackgroundImage"
$value = "1"
if(!(Test-Path $registryPath)) {
  New-Item -Path $registryPath -Force | Out-Null
  New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
} else {
  New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}  

#Cleanup 
#[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR) 
#Remove-Variable Password,BSTR,_password

#Set AutoadminLogin and Run Once
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value "$Computername\$Username" -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value $PlainPassword -Force
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File $tempc\win10user.ps1"
#Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File $temploc\PostReboot.ps1"

#####################################################################

write-output "Unload default registry hive"
#Unload default registry hive
 & reg unload HKLM\DEFAULT


#####################################################################
## Update Az powershell module
#####################################################################

#Install-Module -Name Az -AllowClobber -Force

#write-output "Update Az powershell module"
#Install-Module -Name Az -AllowClobber -Force

#####################################################################
# Restore Datawarehouse
#####################################################################
Write-Output "Restore Datawarehouse-START"

# Microsoft ODBC Driver 17 for SQL Server
# https://www.microsoft.com/en-us/download/confirmation.aspx?id=56567
# msodbcsql_17.3.1.1_x64.msi

#Download Microsoft ODBC Driver 17 for SQL Server
Write-Output "Download Microsoft ODBC Driver 17 for SQL Server $(get-date)"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=56567"
$output = "C:\temp\msodbcsql_17_x64.msi"
$start_time = Get-Date
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)

#Install Microsoft ODBC Driver 17 for SQL Server
Write-Output "Install Microsoft ODBC Driver 17 for SQL Server $(get-date)"
$odbcMSI = "C:\temp\msodbcsql_17_x64.msi"
Start-Process -filepath msiexec -argumentlist "/i $odbcMSI /qn /norestart" -Wait -PassThru

#Download DWscript_BookBeat.sql backup file
Write-Output "Download DWscript_BookBeat.sql backup file $(get-date)"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://sabookbeat.blob.core.windows.net/bookbeat/DWscript_BookBeat8-2-edit.sql?sp=rl&st=2019-03-14T17:48:28Z&se=2020-05-30T17:48:00Z&sv=2018-03-28&sig=3J66KU6BbyicKoL9CBIXzJBHUnKu7NZ2%2FYYUpstelr4%3D&sr=b"
$output = "C:\temp\DWscript_BookBeat.sql"
$start_time = Get-Date
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)

<#
# Configuration 
$ResourceGroupName = "rg661938"
$Username = "userrg661938"
$PlainPassword = "M+t!R6WkL.Rp"
$sqlserver  = "azuresql-$ResourceGroupName.database.windows.net"
$database     = "DataWarehouse-$ResourceGroupName"
$connectionString = "Data Source=$sqlserver,1433; " +`
                    "User Id=$Username; " +`
                    "Password=$PlainPassword; "

#$connectionString = "Data Source=MyDataSource;Initial Catalog=MyDB;User ID=user1;Password=pass1;Connection Timeout=90"
$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString)
$query = [IO.File]::ReadAllText("C:\temp\DWscript_BookBeat.sql")
$command = New-Object -TypeName System.Data.SqlClient.SqlCommand($query, $connection)
$connection.Open()
$command.ExecuteNonQuery()
$connection.Close()
#>

# Configuration
$sqlserver  = "azuresql-$ResourceGroupName.database.windows.net"
$database     = "DataWarehouse-$ResourceGroupName"
Write-Output "Username set to $Username"
Write-Output "PlainPassword set to $PlainPassword"
Write-Output "resourceGroupName set to $resourceGroupName"
Write-Output "sqlserver set to $sqlserver"
Write-Output "database set to $database"

#Write-Output "sqlcmd restore DWscript_BookBeat.sql $(get-date)"
#sqlcmd -U $Username -P $PlainPassword -S tcp:$sqlserver,1433 -d $database -I -i C:\temp\DWscript_BookBeat.sql

Write-Output "Restore Datawarehouse-END"


#####################################################################
# DataLake - Setup Folders and upload Files
#####################################################################
Write-Output "DataLake-START"

# Copy Files
Write-Output "Copy BooksEditions-DailySnapshot-20190302.csv"
Copy-Item -Path 'D:\Temp\BooksEditions-DailySnapshot-20190302.csv' -Destination "C:\Temp"

Write-Output "Copy BooksEditions-DailySnapshot-Latest.orc"
Copy-Item -Path 'D:\Temp\BooksEditions-DailySnapshot-Latest.orc' -Destination "C:\Temp"

# https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-get-started-powershell

# DataLakeName
$dataLakeStorageGen1Name = "datalake$resourceGroupName"
Write-Output "dataLakeStorageGen1Name set to $dataLakeStorageGen1Name"

# Set permissions

#Get-AzureRmDataLakeStoreItemAclEntry -AccountName "ContosoADL" -Path /Folder1
#Set-AzureRmDataLakeStoreItemAcl -AccountName "ContosoADL" -Path "/Folder2" -Acl $ACL -Recurse -Concurrency 128
#az dls fs access show --account datalakerg219887 --path /
#az dls fs access set-permission --account datalakerg219887 --path / --permission 777

#Write-Output "Set permissions on datalake"
#Set-AzureRmDataLakeStoreItemOwner -AccountName "$dataLakeStorageGen1Name" -Path / -Type User -Id (Get-AzureRmADUser -Mail "$vmLocalUserEmail").Id
#Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStorageGen1Name -Path '/' -AceType User -Id (Get-AzureRmADUser -Mail $vmLocalUserEmail).Id -Permissions All -Default

<#
# Create DataLake Folders
Write-Output "Create DataLake Folders"

New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/01/ --force
New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/2019/03/ --force
New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path /BackEnd/Books/Editions/Latest/ --force

az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/2019/01/ --folder --force
az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/2019/03/ --folder --force
az dls fs create --account $dataLakeStorageGen1Name --path /BackEnd/Books/Editions/Latest/ --folder --force

# Upload Files to DataLake
Write-Output "Upload Files to DataLake"

Import-AzDataLakeStoreItem -AccountName $dataLakeStorageGen1Name -Path "C:\sampledata\vehicle1_09142014.csv" -Destination $myrootdir\mynewdirectory\vehicle1_09142014.csv

az dls fs upload --account $dataLakeStorageGen1Name --source-path "C:\Temp\BooksEditions-DailySnapshot-20190302.csv" --destination-path "/BackEnd/Books/Editions/2019/03/BooksEditions-DailySnapshot-20190302.csv" --overwrite
az dls fs upload --account $dataLakeStorageGen1Name --source-path "C:\Temp\BooksEditions-DailySnapshot-Latest.orc" --destination-path "/BackEnd/Books/Editions/Latest/BooksEditions-DailySnapshot-Latest.orc" --overwrite
#>

# Copy the UploadFileShareFiles script to the PUBLIC folder
Copy-Item -Path "D:\Temp\UploadFileShareFiles.ps1" -Destination "C:\temp"

# Create a scheduled task to run the fileshare upload on logon
Write-Output "Create a scheduled task to run the fileshare upload on logon"
$TaskName = "HOLFSUpload2"
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-Executionpolicy unrestricted -NoProfile -WindowStyle Hidden -Command c:\temp\UploadFileShareFiles.ps1'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Upload fileshare files" -Principal $principal

Write-Output "DataLake-END"
#####################################################################

# Copy Booklistpopularity.pbix
Write-Output "Copy Booklistpopularity.pbix"
Copy-Item -Path 'D:\Temp\Booklistpopularity.pbix' -Destination "C:\Temp"
Copy-Item -Path 'D:\Temp\Booklistpopularity.pbix' -Destination "$env:Public\Desktop"

# Copy RelatedReadingsPy.py
Write-Output "Copy RelatedReadingsPy.py"
Copy-Item -Path 'D:\Temp\RelatedReadingsPy.py' -Destination "C:\Temp"
Copy-Item -Path 'D:\Temp\RelatedReadingsPy.py' -Destination "$env:Public\Desktop"

##Reboot
write-output "Restart Server"
& shutdown /r /t 30 /f