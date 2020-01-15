#install roles and features

$featureLogPath = "c:\poshlog\featurelog.txt"
New-Item $featureLogPath -ItemType file -Force
$addsTools = "RSAT-AD-Tools"

Add-WindowsFeature $addsTools -LogPath $featureLogPath
Get-WindowsFeature | Where installed >>$featureLogPath
