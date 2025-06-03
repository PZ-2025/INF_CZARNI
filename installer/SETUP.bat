@echo off 
title Funeral Home Management System Installer 
echo ========================================= 
echo Funeral Home Management System 
echo Installer 
echo ========================================= 
echo. 
echo Installing to: %CD% 
echo. 
echo Creating desktop shortcut... 
echo Set oWS = WScript.CreateObject("WScript.Shell") > shortcut.vbs 
echo sLinkFile = "%USERPROFILE%\Desktop\Funeral Home.lnk" >> shortcut.vbs 
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> shortcut.vbs 
echo oLink.TargetPath = "%CD%\start.bat" >> shortcut.vbs 
echo oLink.WorkingDirectory = "%CD%" >> shortcut.vbs 
echo oLink.Description = "Funeral Home Management System" >> shortcut.vbs 
echo oLink.IconLocation = "%CD%\app.ico" >> shortcut.vbs 
echo oLink.Save >> shortcut.vbs 
cscript shortcut.vbs >nul 
del shortcut.vbs 
echo. 
echo ✅ Installation completed! 
echo ✅ Desktop shortcut created: "Funeral Home" 
echo. 
echo 🚀 Starting application... 
timeout /t 3 /nobreak > nul 
call start.bat 
