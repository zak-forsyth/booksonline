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
Start-Logging -Name "win10user";



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

####################################################################

# Disbales Network discovery popup
write-output "Disbales Network discovery popup"
netsh advfirewall firewall set rule group="Network Discovery" new enable=No

# disable Cortana
write-output "disable Cortana"
   $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"     
    IF(!(Test-Path -Path $path)) {  
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search" 
    }  
    Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0  
    #Restart Explorer to change it immediately     
    #Stop-Process -name explorer

# Remove Edge Icon from desktop
write-output "Remove Edge Icon from desktop"
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name DisableEdgeDesktopShortcutCreation -value 1 -Force

# Disable Notification Center
write-output "Disable Notification Center"
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows' -Name Explorer -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name DisableNotificationCenter -value 1 -Force

# Disable Notification Center
write-output "Disable Notification Center"
New-Item -Path 'HKCU:\Software\Policies\Microsoft\Windows' -Name Explorer -Force
New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name DisableNotificationCenter -value 1 -Force

# Disable Security and Maintenance Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.SecurityAndMaintenance -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance' -Name Enabled -value 0 -Force

#Disable OneDrive Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.SkyDrive.Desktop -Force
New-ItemProperty -Path 'HKCU:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.SkyDrive.Desktop' -Name Enabled -value 0 -Force

#Disable Photos Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.Windows.Photos_8wekyb3d8bbwe!App -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Photos_8wekyb3d8bbwe!App' -Name Enabled -value 0 -Force

#Disable Store Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.WindowsStore_8wekyb3d8bbwe!App -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.WindowsStore_8wekyb3d8bbwe!App' -Name Enabled -value 0 -Force

#Disable Suggested Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.Suggested -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested' -Name Enabled -value 0 -Force

#Disable Calendar Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar' -Name Enabled -value 0 -Force

#Disable Cortana Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI' -Name Enabled -value 0 -Force

#Disable Mail Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail' -Name Enabled -value 0 -Force

#Disable Edge Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge' -Name Enabled -value 0 -Force

#Disable Audio Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.AudioTroubleshooter -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AudioTroubleshooter' -Name Enabled -value 0 -Force

#Disable Autoplay Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.AutoPlay -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay' -Name Enabled -value 0 -Force

#Disable Battery Saver Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.BackgroundAccess -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BackgroundAccess' -Name Enabled -value 0 -Force

#Disable Bitlocker Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.BdeUnlock -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BdeUnlock' -Name Enabled -value 0 -Force

#Disable News Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Microsoft.BingNews_8wekyb3d8bbwe!AppexNews -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.BingNews_8wekyb3d8bbwe!AppexNews' -Name Enabled -value 0 -Force

#Disable Settings Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel' -Name Enabled -value 0 -Force

#Disable Tablet Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.System.Continuum -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.System.Continuum' -Name Enabled -value 0 -Force

#Disable VPN Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.RasToastNotifier -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.RasToastNotifier' -Name Enabled -value 0 -Force

#Disable Windows Hello Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.HelloFace -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.HelloFace' -Name Enabled -value 0 -Force

#Disable Wireless Notifications
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name Windows.SystemToast.WiFiNetworkManager -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager' -Name Enabled -value 0 -Force

# Hide TaskViewButton
write-output "Hide TaskViewButton"
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowTaskViewButton -value 0 -Force

# Hide people Button
write-output "Hide people Button"
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name People -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name PeopleBand -value 0 -Force

# Remove Icons from taskbar
write-output "Remove Edge Icon from taskbar"
$appname = "Microsoft Edge"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

write-output "Remove Store Icon from taskbar"
$appname = "Microsoft Store"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

write-output "Remove Mail Icon from taskbar"
$appname = "Mail"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

#Edge (link to Azure portal) This creates a Desktop shortcut to the Azure portal and uses the Edge icon.
write-output "Edge (link to Azure portal)"
$ShortcutFile = "$env:Public\Desktop\Azure portal.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.WindowStyle = "3" 
$Shortcut.IconLocation = "%windir%\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe" 
$Shortcut.TargetPath = "https://portal.azure.com" 
$Shortcut.Save()

#Stop-Process -name explorer -Force

#Write-Output "Restarting explorer"
#Start-Process "explorer.exe"

########################################
#remove and disable OneDrive integration
<#
Write-Output "Kill OneDrive process"
taskkill.exe /F /IM "OneDrive.exe"
#taskkill.exe /F /IM "explorer.exe"

Write-Output "Remove OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

Write-Output "Removing OneDrive leftovers"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
# check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}

Write-Output "Disable OneDrive via Group Policies"
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

Write-Output "Remove Onedrive from explorer sidebar"
New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"

Write-Output "Removing run hook for new users"
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Output "Removing startmenu entry"
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Output "Removing scheduled task"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

#Write-Output "Restarting explorer"
#Start-Process "explorer.exe"

#Write-Output "Waiting for explorer to complete loading"
#Start-Sleep 10

Write-Output "Removing additional OneDrive leftovers"
foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*onedrive*")) {
    Remove-Item -Recurse -Force $item.FullName
}

########################################

Stop-Process -name explorer -Force

Write-Output "Restarting explorer"
Start-Process "explorer.exe"

#>

#####################################################################
## PostReboot.ps1
#####################################################################

# Try write Immersion sentinel file to allow pending deployments to proceed
$temploc = "D:\Temp"
$sentinel_config = Get-Content (Join-Path $tempLoc 'blob_storage_config.json') | ConvertFrom-Json

# Find and import azure blob storage helper module
Get-ChildItem -Recurse -Path 'C:\Packages' -Include 'Immersion.psm1' | Select -First 1 | Import-Module


#Write-AzureBlobFile -StorageAccountName $sentinel_config.PrimaryStorageAccountName `
#                    -StorageAccountKey $sentinel_config.PrimaryStorageAccountKey `
#                    -BlobPath "assets/$($sentinel_config.ScriptSentinelFileName)" `
#                    -SourceBytes @( 0 )

#write-output "Remove Autoadmin login and RunOnce"
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 0 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value "" -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value "" -Force

#Remove user from Local Administrators Group
$Computername = $env:COMPUTERNAME
$Username = "LabUser"
$AdminGroup = [ADSI]"WinNT://$($Computername)/Administrators,group"
$User = [ADSI]"WinNT://$Computername/$Username,user"
$AdminGroup.Remove($User.Path)

#Force Log off of user
(gwmi win32_operatingsystem -ComputerName .).Win32Shutdown(4)