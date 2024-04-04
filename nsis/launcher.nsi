/*

DataLab-WinPython launcher script
---------------------------------

Licensed under the terms of the BSD 3-Clause
(see ../LICENSE for details)

*/

!define COMMAND "$%NSIS_COMMAND%"
!define PARAMETERS "$%NSIS_PARAMS%"
!define WORKDIR "$%NSIS_WORKDIR%"
!define FILENAME "$%NSIS_OUTFILE%"
Icon "$%NSIS_ICON%"
OutFile $%NSIS_OUTFILE%

!include "WordFunc.nsh"
!include "FileFunc.nsh"

Unicode true
SilentInstall silent
AutoCloseWindow true
ShowInstDetails nevershow
RequestExecutionLevel user

Section ""
Call Execute
SectionEnd

Function Execute
StrCmp ${WORKDIR} "" 0 workdir
System::Call "kernel32::GetCurrentDirectory(i ${NSIS_MAX_STRLEN}, t .r0)"
SetOutPath $0
Goto end_workdir
workdir:
SetOutPath "${WORKDIR}"
end_workdir:
${GetParameters} $R1
StrCmp "${PARAMETERS}" "" end_param 0
StrCpy $R1 "${PARAMETERS} $R1"
end_param:
Exec '"${COMMAND}" $R1'
FunctionEnd