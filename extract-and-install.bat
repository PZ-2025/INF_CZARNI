@echo off 
echo Funeral Home Management System Installer 
echo Extracting files... 
if not exist "%TEMP%\FuneralHome" mkdir "%TEMP%\FuneralHome" 
powershell Expand-Archive -Path "%~dp0funeral-data.zip" -DestinationPath "%TEMP%\FuneralHome" -Force 
cd "%TEMP%\FuneralHome" 
call SETUP.bat 
