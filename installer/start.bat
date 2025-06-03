@echo off 
echo ======================================== 
echo Funeral Home Management System 
echo ======================================== 
cd /d "%~dp0" 
if not exist "data" mkdir data 
echo Starting application... 
echo Please wait 10-15 seconds... 
start /min "FuneralApp" jre\bin\java.exe -jar app.jar 
timeout /t 12 /nobreak > nul 
start http://localhost:8080 
echo. 
echo Application started! 
echo URL: http://localhost:8080 
echo. 
echo Default login accounts: 
echo - faustyna@zaklad.pl / admin 
echo - michal@zaklad.pl / admin 
echo - prac1@zaklad.pl / user 
echo. 
pause 
