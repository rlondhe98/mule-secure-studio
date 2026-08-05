Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptFolder = fso.GetParentFolderName(WScript.ScriptFullName)
powerShellScript = fso.BuildPath(scriptFolder, "SecurePropertiesGUI.ps1")

command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File """ & powerShellScript & """"

shell.Run command, 0, False
