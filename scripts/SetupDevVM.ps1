param([Parameter(Mandatory=$true)][string]$chocoPackages)

#"Changing ExecutionPolicy" | Out-File $LogFile -Append
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

#Enable remoting
Enable-PSRemoting -Force

# Install Choco
$sb = { iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) }
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME

#"Install each Chocolatey Package"
$chocoPackages.Split(";") | ForEach-Object {
    $command = "choco install " + $_ + " -y -force"
    $sb = [scriptblock]::Create("$command")

    # Use the current user profile
    Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME
}

# Install npm packages
$command = "npm install -g npm"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME

# Install production windows-build-tools packages
$command = "npm install -g -production windows-build-tools"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME

# Install ethereumjs-testrpc packages
$command = "npm install -g ethereumjs-testrpc"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME

# Install truffle packages
$command = "npm install -g truffle@beta"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb -ComputerName $env:COMPUTERNAME

#Disable remoting
Disable-PSRemoting -Force
