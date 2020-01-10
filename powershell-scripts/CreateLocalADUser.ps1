#Create local AD user
Write-Host "Create local AD user" -ForegroundColor Yellow
$userDirectory = [ADSI]"WinNT://localhost"
$user = $userDirectory.Create("User", "ADUSER")
$user.SetPassword("ADUSERPASSWORD")
$user.SetInfo()
$user.UserFlags = 64 + 65536
$user.SetInfo()
$user.FullName = "ADUSER"
$user.SetInfo()
&net "localgroup" "administrators" "/add" "ADUSER"
Write-Host "User: 'ADUSER' has been created as a local administrator." -ForegroundColor Green