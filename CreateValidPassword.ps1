Function New-PasswordChar () {
	[CmdletBinding()]
	$BannedChars=("o","O","0","1","l","i","{","}",'[',']',"\","|","'",'"','<','>','/','`','(',')',',',';',':')
	# http://www.asciitable.com/
	$PasswordChar=(-join (38..125 | ForEach-Object {[char]$_} | Get-Random -Count 1))
	if ($PasswordChar -in $BannedChars) {throw "invalid char"}
	else {$PasswordChar}
}

Function New-UserPassword {
    [CmdletBinding()]
    PARAM (
		[Parameter(Mandatory=$False)][int16]$Length=10,
		[Parameter(Mandatory=$False)][int16]$MinimumFriendlyCharacters=7
	)
	
	if ($MinimumFriendlyCharacters -ge $Length) {Write-Warning '$MinimumFriendlyCharacters cannot be greater than the total number of characters.'; throw [System.InvalidOperationException] "Bad arguments" }
	
	While ($PassCandidate.length -lt $Length) {
		try {$PassCandidate+=New-PasswordChar -errorAction SilentlyContinue }
		catch { }
	}
	[regex]$ComplexityRegex="[a-zA-Z0-9]"
	#Write-Verbose $ComplexityRegex.Matches($PassCandidate)
	
	if (($ComplexityRegex.Matches($PassCandidate).Count) -lt $MinimumFriendlyCharacters){ 
		#Write-Verbose "Password too complex for user"
		throw 'password too complex' 
	}
	else {
		#Write-Verbose "Password candidate has $($ComplexityRegex.Matches($PassCandidate).Count) matches, continuing to validate"
	}

	if (
		(
		$passCandidate -cmatch "[A-Z\p{Lu}\s]") `
		-and ($passCandidate -cmatch "[a-z\p{Ll}\s]")`
		-and ($passCandidate -match "[\d]")`
		-and ($passCandidate -match "[^w]")`
		-and $passCandidate.Length -eq $Length
	)
	{
		$passCandidate
	}
	else {
		# Write-Verbose "Password candidate not complex enough."
		throw "Could not generate a valid password"
	}
}

while (!($Newpassword)) {
  try {$Newpassword=New-UserPassword}
  catch {}
}
$Newpassword
