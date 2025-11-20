Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments
If objArgs.Count >= 2 Then
    sevenZipPath = objArgs(0)
    zipPath = objArgs(1)
    targetPath = objArgs(2)
    objShell.Run """" & sevenZipPath & """ x -y """ & zipPath & """ -o""" & targetPath & """", 0, True
End If
