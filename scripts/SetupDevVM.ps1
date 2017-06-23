param([Parameter(Mandatory=$true)][string]$chocoPackages,[Parameter(Mandatory=$true)][string]$admin,[Parameter(Mandatory=$true)][string]$passwd)

#"Changing ExecutionPolicy" | Out-File $LogFile -Append
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Create pwd and new $creds for remoting
$secPassword = ConvertTo-SecureString $passwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$($admin)", $secPassword)

#Enable remoting
Enable-PSRemoting -Force

# Install Choco
$sb = { iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) }
Invoke-Command -ScriptBlock $sb 

#"Install each Chocolatey Package"
$chocoPackages.Split(";") | ForEach-Object {
    $command = "choco install " + $_ + " -y"
    $sb = [scriptblock]::Create("$command")

    # Use the current user profile
    Invoke-Command -ScriptBlock $sb
}

# refresh env
$command = "RefreshEnv"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb

#install code extensions
$command = "code --install-extension PKief.material-icon-theme"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb

$command = "code --install-extension JuanBlanco.solidity"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb

#Disable remoting
Disable-PSRemoting -Force
