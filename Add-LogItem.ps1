Function Add-LogItem {
	[CmdletBinding()]
	Param(
    [Parameter( 
        Mandatory=$true,  
        HelpMessage="Log File Path")] 
    [string[]]$Logfile,

    [Parameter( 
        Mandatory=$true,  
        HelpMessage="Text Of Log Entry")] 
    [string]$Message,

    [Parameter( 
        Mandatory=$false,  
        HelpMessage="Text message to show the user")] 
    [string][ValidateSet("Error","Warning","Information")]$MessageType="Information"
	)	
	BEGIN {
		$Timestamp=Get-Date -uformat %Y-%m-%d_%r
	}
	PROCESS {
        $outputObject=[PSCustomObject]@{
            Timestamp=$Timestamp
            MessageType=$MessageType
            Message=$message
        } 
        foreach ($file in $Logfile) { 
            $outputObject|export-csv -path $file -append -notypeinformation -force -delimiter ';' -encoding UTF8 
        }
	}
}
