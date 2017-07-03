# Load all printers from WMI
$printers=Get-WmiObject -Class win32_printer
# Loop through printer list
foreach ($printer in $printers) {
    # and look for printers with the location field filled out. You could also look for a printer attribute that has the server name
    # or backslashes in it \
    if ($printer.Location -ne $null){
        # Echo the printer name to the screen. You could also save this to a location to use later
        $printer.name
        # Save a batch file to use to re-map the printers later
        "rundll32 printui.dll,PrintUIEntry /in /n"+$printer.name | Out-File $PSScriptRoot\printers.bat -Append -encoding ascii
    } 

}