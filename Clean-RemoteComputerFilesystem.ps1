Clear-Host
$Computer=Read-Host -Prompt "Which computer?"
$RootPath='\\'+$Computer+'\c$\'
$initialFreeSpace=(Get-WmiObject Win32_LogicalDisk -ComputerName $Computer | Select Name,Size,FreeSpace |Where-Object {$_.Name -eq 'C:'}|Select-Object -Property FreeSpace).FreeSpace
$initialFreeSpace=("{0:N2}" -f ($initialFreeSpace/1GB))+"GB"
"Beginning free space: "+$initialFreeSpace

#region clean User Profiles
$ItemsToRemove=@()
$UserFolders= Get-ChildItem $RootPath\Users -Directory
Foreach ($Folder in $UserFolders) {
    $OfficeFileCache=$Folder.FullName+'\AppData\Local\Microsoft\Office\15.0\OfficeFileCache'
    $ErrorReports=$Folder.FullName+'\AppData\Local\Microsoft\Windows\WER'
    $Tracing=$Folder.FullName+'\AppData\Local\Microsoft\Office\15.0\Lync\Tracing'
    $InternetFiles=$Folder.FullName+'\AppData\Local\Microsoft\Temporary Internet Files'
    $Temp=$Folder.FullName+'\AppData\Local\Temp'

    if (Test-Path $OfficeFileCache) { $ItemsToRemove+=get-childitem $OfficeFileCache}
    if (Test-Path $Tracing) { $ItemsToRemove+=get-childitem $Tracing }
    if (Test-Path $ErrorReports) { $ItemsToRemove+=get-childitem $ErrorReports}
    if (Test-Path $InternetFiles) { $ItemsToRemove+=get-childitem $InternetFiles}
    if (Test-Path $Temp) { $ItemsToRemove+=get-childitem $Temp}
}
$ItemsToRemove | Remove-Item -Recurse -Verbose -ErrorAction SilentlyContinue 
#endregion

#region ProgramData
$vDiskPath=($RootPath+'\ProgramData\Citrix\personal vDisk\UserData.VDESK.TEMPLATE')
if (Test-Path $vDiskPath) {Remove-Item $vDiskPath }
#endregion

#region WindowsFolder
$WindowsTemp=$RootPath+'\Windows\Temp'
if (Test-Path $WindowsTemp) { Remove-Item $WindowsTemp -Recurse}
$CCMCache=$RootPath+'\windows\ccmcache'
if (Test-Path $CCMCache) { Remove-Item $CCMCache -Recurse}
#endregion

$endingFreeSpace=(Get-WmiObject Win32_LogicalDisk -ComputerName $Computer | Select Name,Size,FreeSpace |Where-Object {$_.Name -eq 'C:'}|Select-Object -Property FreeSpace).FreeSpace
$endingFreeSpace=("{0:N2}" -f ($endingFreeSpace/1GB))+"GB"
"Ending free space: "+$endingFreeSpace
