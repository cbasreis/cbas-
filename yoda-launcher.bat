@ECHO OFF

ECHO YODA-LAUNCHER starting!
:PowerShell
SET PSScript=%temp%\~tmpDlFile.ps1
IF EXIST "%PSScript%" DEL /Q /F "%PSScript%"

ECHO $ErrorActionPreference='silentlycontinue'>>"%PSScript%"
ECHO ${Repo}="cbasreis">>"%PSScript%"
ECHO ${RepoLink}="https://github.com/${Repo}/cbas-plus">>"%PSScript%"
ECHO ${APILink}="https://api.github.com/repos/${Repo}/cbas-plus">>"%PSScript%"
ECHO ${DlLink}="${RepoLink}/blob/main/cbas+.zip?raw=true">>"%PSScript%"
ECHO ${commitsRaw}=curl ${APILink}/commits -UseBasicParsing>>"%PSScript%"
ECHO ${commits}=ConvertFrom-Json ${commitsRaw}>>"%PSScript%"
ECHO ${localversion}=Get-Content $env:USERPROFILE\AppData\Roaming\.minecraft\resourcepacks\yoda.txt>>"%PSScript%"

ECHO if(${commits}[0].sha -ne ${localversion})>>"%PSScript%"
ECHO {>>"%PSScript%"
ECHO Write-Output "Updating cbas+ resource pack...">>"%PSScript%"
ECHO [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls">>"%PSScript%"
ECHO Invoke-WebRequest ${DlLink} -OutFile $env:USERPROFILE\AppData\Roaming\.minecraft\resourcepacks\cbas+.zip>>"%PSScript%"
ECHO New-Item -Path $env:USERPROFILE\AppData\Roaming\.minecraft\resourcepacks\yoda.txt -Value ${commits}[0].sha -Force>>"%PSScript%"
ECHO }>>"%PSScript%"

ECHO Write-Output "Launching the original Minecraft launcher...">>"%PSScript%"
ECHO Start-Process -FilePath "C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe">>"%PSScript%"

SET PowerShellDir=C:\Windows\System32\WindowsPowerShell\v1.0
CD /D "%PowerShellDir%"
Powershell -ExecutionPolicy Bypass -Command "& '%PSScript%'"
EXIT
