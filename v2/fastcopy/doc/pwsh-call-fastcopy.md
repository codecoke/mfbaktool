
```powershell

# TC Button
# Command:   powershell -noexit -File "X:\temp\PS\RemoveBOM from TCs temp file\RemoveBOM.ps1"
# Parameter: "%WL" "%T"


$TCsTempFile = $Args[0]
$TCsTarget   = $Args[1]
#  & "notepad2.exe" $TCsTempFile 
$NewTempFile = $env:temp + "\tctempfile.txt"

# //Read and write TCs temp file, but change endcoding:
# Out-File 'Encoding' :"unknown,string,unicode,bigendianunicode,utf8,utf7,utf32,ascii,default,oem" 
Get-Content $TCsTempFile | Out-File -encoding UTF8 $NewTempFile
#  & "notepad2.exe" $NewTempFile 


# //Call here your command, now with list of files w/o BOM:
$Exe = "xxx.exe"
&$exe "/auto_close /balloon=FALSE /estimate /cmd=force_copy /srcfile_w=$NewTempFile /to=$TCsTarget"


# For the right quoting see > http://edgylogic.com/blog/powershell-and-external-commands-done-right/
#     ...how do I send parameters that contain spaces? Normally we would quote the part that has spaces, e.g.
#     &$exe -p -script="H:\backup\scripts temp\vss.cmd" E: M: P:
#     
#     But not in Powershell. That will simply confuse it. Instead, just place the entire parameter in quotes, e.g.
#     &$exe -p "-script=H:\backup\scripts temp\vss.cmd" E: M: P:
#     
#     If it is necessary for the quotes to be passed on to the external command (it very rarely is),
#     you will need to double-escape the quotes inside the string, once for PowerShell using the backtick character (`), 
#     and again for the parser using the backslash character (\). 

```