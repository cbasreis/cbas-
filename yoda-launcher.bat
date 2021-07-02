@ECHO OFF

ECHO YODA-LAUNCHER starting!
:PowerShell
SET PSScript=%temp%\~tmpDlFile.ps1
IF EXIST "%PSScript%" DEL /Q /F "%PSScript%"

ECHO $ErrorActionPreference='silentlycontinue'>>"%PSScript%"
ECHO ${RepoAuthor}="cbasreis">>"%PSScript%"
ECHO ${RepoLink}="https://github.com/${RepoAuthor}/cbas-plus">>"%PSScript%"
ECHO ${APILink}="https://api.github.com/repos/${RepoAuthor}/cbas-plus">>"%PSScript%"
ECHO ${ReleasesRaw}=curl ${APILink}/releases -UseBasicParsing>>"%PSScript%"
ECHO ${Releases}=ConvertFrom-Json ${ReleasesRaw}>>"%PSScript%"
ECHO ${DlLink}=${Releases}.assets[0].browser_download_url>>"%PSScript%"
ECHO ${RemoteVersionRaw}=${Releases}[0].tag_name -Split "v">>"%PSScript%"
ECHO ${RemoteVersion}=${RemoteVersionRaw}.split("v")[1].split("-")[0]>>"%PSScript%"
ECHO ${Localversion}=Get-Content $env:USERPROFILE\AppData\Roaming\.minecraft\resourcepacks\yoda.txt>>"%PSScript%"

ECHO if([System.Version]${RemoteVersion} -gt [System.Version]${Localversion})>>"%PSScript%"
ECHO {>>"%PSScript%"
ECHO Write-Output "Updating cbas+ resource pack...">>"%PSScript%"
ECHO [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls">>"%PSScript%"
ECHO Invoke-WebRequest ${DlLink} -OutFile $env:USERPROFILE\AppData\Roaming\.minecraft\resourcepacks\cbas+.zip>>"%PSScript%"
ECHO }>>"%PSScript%"
ECHO New-Item -Path $env:USERPROFILE\AppData\Roaming\.minecraft\resourcepacks\yoda.txt -Value ${RemoteVersion} -Force>>"%PSScript%"

ECHO Write-Output "Launching the original Minecraft launcher...">>"%PSScript%"
ECHO Start-Process -FilePath "C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe">>"%PSScript%"

SET PowerShellDir=C:\Windows\System32\WindowsPowerShell\v1.0
CD /D "%PowerShellDir%"
Powershell -ExecutionPolicy Bypass -Command "& '%PSScript%'"
EXIT
