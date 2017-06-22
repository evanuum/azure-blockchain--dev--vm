param([Parameter(Mandatory=$true)][string]$chocoPackages)

#"Changing ExecutionPolicy" | Out-File $LogFile -Append
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Install Choco
$sb = { iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) }
Invoke-Command -ScriptBlock $sb 

#"Install each Chocolatey Package"
$chocoPackages.Split(";") | ForEach-Object {
    $command = "choco install " + $_ + " -y -force"
    $sb = [scriptblock]::Create("$command")

    # Use the current user profile
    Invoke-Command -ScriptBlock $sb
}
