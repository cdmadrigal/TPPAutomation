$Password = ConvertTo-SecureString -AsPlainText -String "ADSAFEMODEPASSWORD" -Force

# Create New Forest, add Domain Controller
$domainname = "ADDOMAINNAME"
$netbiosName = "ADNETBIOSNAME"

  Import-Module ADDSDeployment
  Install-ADDSForest -CreateDnsDelegation:$false `
   -SafeModeAdministratorPassword $Password `
   -DatabasePath "C:\Windows\NTDS" `
   -DomainMode "WinThreshold" `
   -DomainName $domainname `
   -DomainNetbiosName $netbiosName `
   -ForestMode "WinThreshold" `
   -InstallDns:$true `
   -LogPath "C:\Windows\NTDS" `
   -NoRebootOnCompletion:$false `
   -SysvolPath "C:\Windows\SYSVOL" `
   -Force:$true 
   
