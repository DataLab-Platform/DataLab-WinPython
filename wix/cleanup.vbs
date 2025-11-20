Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments
If objArgs.Count >= 1 Then
    targetFolder = objArgs(0)
    objShell.Run "cmd.exe /c rd /s /q """ & targetFolder & """", 0, True
End If
