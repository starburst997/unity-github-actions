# Run as administrator in powershell
# Setup a self-hosted windows runner
# You need to run this command first: `Set-ExecutionPolicy RemoteSigned`
# Couldn't get docker to work properly, so I currently use this VM only for the signing step in windows and build using linux VM

cd $PSScriptRoot

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Missing softwares
choco install git.install -y
choco install git-lfs.install -y
choco install 7zip.install -y
choco install innosetup -y
choco install dotnet -y
choco install dotnet-sdk -y
choco install pwsh -y
choco install rcedit -y

# Couldn't get docker to work properly...
#choco install docker-desktop -y

#choco install docker -y
#choco install docker-compose -y
#choco install docker-machine -y
#choco install docker-machine-vmwareworkstation -y

# Install Brotli
mkdir /brotli
cd /brotli
Invoke-WebRequest https://github.com/google/brotli/releases/download/v1.1.0/brotli-x64-windows-static.zip -OutFile ./brotli.zip
Expand-Archive -Path ./brotli.zip -DestinationPath .

# Add brotli to PATH
$oldpath = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;$($pwd.Path)"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
(Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$($pwd.Path)", "User")

# Add git bin to PATH
cd "C:\Program Files\Git\bin"
$oldpath = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$($pwd.Path);$oldpath"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
(Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
[Environment]::SetEnvironmentVariable("Path", "$($pwd.Path);" + $env:Path, "User")

cd $PSScriptRoot

# Hyper-V
#dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All