@echo off 
taskkill /f /im java.exe /fi "WINDOWTITLE eq FuneralApp" 2>nul 
echo Application stopped. 
pause 
