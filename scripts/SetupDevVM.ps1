param([Parameter(Mandatory=$true)][string]$chocoPackages,[Parameter(Mandatory=$true)][string]$admin,[Parameter(Mandatory=$true)][string]$passwd)

#"Changing ExecutionPolicy" | Out-File $LogFile -Append
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Create pwd and new $creds for remoting
$secPassword = ConvertTo-SecureString $passwd -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$($admin)", $secPassword)

#Enable remoting
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Install Choco
$sb = { iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) }
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 

#"Install each Chocolatey Package"
$chocoPackages.Split(";") | ForEach-Object {
    $command = "choco install " + $_ + " -y -force"
    $sb = [scriptblock]::Create("$command")

    # Use the current user profile
    Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 
}

# refresh env
$command = "RefreshEnv"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 

# Install npm packages
$command = "npm install -g npm"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 

# Install production windows-build-tools packages
$command = "npm install -g -production windows-build-tools"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 

# Install ethereumjs-testrpc packages
$command = "npm install -g ethereumjs-testrpc"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 

# Install truffle packages
$command = "npm install -g truffle@beta"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME -Credential $credential 

#Disable remoting
Disable-PSRemoting -Force
