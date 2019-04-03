# Install nuget, without  questions
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Trust microsoft's PS Gallery, without questions
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install a powershell-git helper module
Install-Module posh-git -Force

# Install chocolatey for command-line normal program installs
install-module chocolatey
install-chocolateysoftware

# use chocolatey to install git
install-chocolateypackage git -Force -Confirm:$false

# use chocolatey to install vscode, which you should be using for powershell development.
install-chocolateypackage vscode -Force -Confirm:$false

# import the posh-git module
Import-Module posh-git

# automatically import the posh-git module by modifying the powershell profile script for your user.
'import-module posh-git'|out-file $PROFILE -Append
