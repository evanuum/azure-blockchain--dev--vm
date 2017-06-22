#"Changing ExecutionPolicy" | Out-File $LogFile -Append
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Install npm packages
$command = "npm install -g npm"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb

# Install production windows-build-tools packages
$command = "npm install -g -production windows-build-tools"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb

# Install ethereumjs-testrpc packages
$command = "npm install -g ethereumjs-testrpc"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb

# Install truffle packages
$command = "npm install -g truffle@beta"
$sb = [scriptblock]::Create("$command")
Invoke-Command -ScriptBlock $sb 
