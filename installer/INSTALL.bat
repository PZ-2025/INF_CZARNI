@echo off 
echo ========================================= 
echo Funeral Home Management System 
echo Portable Installation 
echo ========================================= 
echo. 
echo This is a PORTABLE installation! 
echo You can run it from any folder. 
echo. 
echo Creating desktop shortcut... 
echo Set oWS = WScript.CreateObject("WScript.Shell") > shortcut.vbs 
echo sLinkFile = "%USERPROFILE%\Desktop\Funeral Home.lnk" >> shortcut.vbs 
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> shortcut.vbs 
echo oLink.TargetPath = "%CD%\start.bat" >> shortcut.vbs 
echo oLink.WorkingDirectory = "%CD%" >> shortcut.vbs 
echo oLink.Description = "Funeral Home Management System" >> shortcut.vbs 
echo oLink.Save >> shortcut.vbs 
cscript shortcut.vbs >nul 
del shortcut.vbs 
echo. 
echo ✅ Installation completed! 
echo. 
echo 🚀 Starting application now... 
call start.bat 
