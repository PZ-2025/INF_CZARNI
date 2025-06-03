@echo off
echo ========================================
echo Creating Simple Installer (No ZIP)
========================================

REM Stop Java to release locks
taskkill /f /im java.exe 2>nul
timeout /t 2 /nobreak > nul

REM Create installer folder
if exist "installer" rmdir /s /q "installer"
mkdir installer

REM Copy app files
xcopy /E /I /Y "dist\*" "installer\"

REM Create single installer script
echo @echo off > "installer\INSTALL.bat"
echo echo ========================================= >> "installer\INSTALL.bat"
echo echo Funeral Home Management System >> "installer\INSTALL.bat"
echo echo Portable Installation >> "installer\INSTALL.bat"
echo echo ========================================= >> "installer\INSTALL.bat"
echo echo. >> "installer\INSTALL.bat"
echo echo This is a PORTABLE installation! >> "installer\INSTALL.bat"
echo echo You can run it from any folder. >> "installer\INSTALL.bat"
echo echo. >> "installer\INSTALL.bat"
echo echo Creating desktop shortcut... >> "installer\INSTALL.bat"
echo echo Set oWS = WScript.CreateObject("WScript.Shell"^) ^> shortcut.vbs >> "installer\INSTALL.bat"
echo echo sLinkFile = "%%USERPROFILE%%\Desktop\Funeral Home.lnk" ^>^> shortcut.vbs >> "installer\INSTALL.bat"
echo echo Set oLink = oWS.CreateShortcut(sLinkFile^) ^>^> shortcut.vbs >> "installer\INSTALL.bat"
echo echo oLink.TargetPath = "%%CD%%\start.bat" ^>^> shortcut.vbs >> "installer\INSTALL.bat"
echo echo oLink.WorkingDirectory = "%%CD%%" ^>^> shortcut.vbs >> "installer\INSTALL.bat"
echo echo oLink.Description = "Funeral Home Management System" ^>^> shortcut.vbs >> "installer\INSTALL.bat"
echo echo oLink.Save ^>^> shortcut.vbs >> "installer\INSTALL.bat"
echo cscript shortcut.vbs ^>nul >> "installer\INSTALL.bat"
echo del shortcut.vbs >> "installer\INSTALL.bat"
echo echo. >> "installer\INSTALL.bat"
echo echo ✅ Installation completed! >> "installer\INSTALL.bat"
echo echo. >> "installer\INSTALL.bat"
echo echo 🚀 Starting application now... >> "installer\INSTALL.bat"
echo call start.bat >> "installer\INSTALL.bat"

REM Create README
echo Funeral Home Management System > "installer\README.txt"
echo ================================= >> "installer\README.txt"
echo. >> "installer\README.txt"
echo QUICK START: >> "installer\README.txt"
echo 1. Run INSTALL.bat (creates desktop shortcut) >> "installer\README.txt"
echo 2. Or directly run start.bat >> "installer\README.txt"
echo 3. Browser opens on http://localhost:8080 >> "installer\README.txt"
echo. >> "installer\README.txt"
echo LOGIN CREDENTIALS: >> "installer\README.txt"
echo Admin: michal@zaklad.pl / admin >> "installer\README.txt"
echo User:  prac1@zaklad.pl / user >> "installer\README.txt"
echo. >> "installer\README.txt"
echo PORTABLE: No installation needed! >> "installer\README.txt"
echo Can be run from USB drive or any folder. >> "installer\README.txt"

echo ========================================
echo Portable Installer Created!
echo ========================================
echo.
echo 📁 Folder: installer\
echo 📄 Files ready for distribution!
echo.
echo TO DISTRIBUTE:
echo 1. ZIP the 'installer' folder manually
echo 2. Or send entire 'installer' folder
echo 3. User runs INSTALL.bat or start.bat
echo.
echo ✅ No Java required on target machine!
echo ✅ Fully portable application!
echo.
pause