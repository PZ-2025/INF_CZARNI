@echo off
echo ========================================
echo Creating EXE Installer with IExpress
echo ========================================

REM Stop Java processes
taskkill /f /im java.exe 2>nul
timeout /t 2 /nobreak > nul

if not exist "installer" (
    echo ERROR: Run create-simple-installer.bat first!
    pause
    exit /b 1
)

echo Step 1: Preparing installer files...

REM Create enhanced installer script
echo @echo off > installer\SETUP.bat
echo title Funeral Home Management System Installer >> installer\SETUP.bat
echo echo ========================================= >> installer\SETUP.bat
echo echo Funeral Home Management System >> installer\SETUP.bat
echo echo Installer >> installer\SETUP.bat
echo echo ========================================= >> installer\SETUP.bat
echo echo. >> installer\SETUP.bat
echo echo Installing to: %%CD%% >> installer\SETUP.bat
echo echo. >> installer\SETUP.bat
echo echo Creating desktop shortcut... >> installer\SETUP.bat
echo echo Set oWS = WScript.CreateObject("WScript.Shell"^) ^> shortcut.vbs >> installer\SETUP.bat
echo echo sLinkFile = "%%USERPROFILE%%\Desktop\Funeral Home.lnk" ^>^> shortcut.vbs >> installer\SETUP.bat
echo echo Set oLink = oWS.CreateShortcut(sLinkFile^) ^>^> shortcut.vbs >> installer\SETUP.bat
echo echo oLink.TargetPath = "%%CD%%\start.bat" ^>^> shortcut.vbs >> installer\SETUP.bat
echo echo oLink.WorkingDirectory = "%%CD%%" ^>^> shortcut.vbs >> installer\SETUP.bat
echo echo oLink.Description = "Funeral Home Management System" ^>^> shortcut.vbs >> installer\SETUP.bat
echo echo oLink.IconLocation = "%%CD%%\app.ico" ^>^> shortcut.vbs >> installer\SETUP.bat
echo echo oLink.Save ^>^> shortcut.vbs >> installer\SETUP.bat
echo cscript shortcut.vbs ^>nul >> installer\SETUP.bat
echo del shortcut.vbs >> installer\SETUP.bat
echo echo. >> installer\SETUP.bat
echo echo ✅ Installation completed! >> installer\SETUP.bat
echo echo ✅ Desktop shortcut created: "Funeral Home" >> installer\SETUP.bat
echo echo. >> installer\SETUP.bat
echo echo 🚀 Starting application... >> installer\SETUP.bat
echo timeout /t 3 /nobreak ^> nul >> installer\SETUP.bat
echo call start.bat >> installer\SETUP.bat

echo Step 2: Creating IExpress configuration...

REM Create IExpress configuration file
echo [Version] > iexpress-config.sed
echo Class=IEXPRESS >> iexpress-config.sed
echo SEDVersion=3 >> iexpress-config.sed
echo [Options] >> iexpress-config.sed
echo PackagePurpose=InstallApp >> iexpress-config.sed
echo ShowInstallProgramWindow=1 >> iexpress-config.sed
echo HideExtractAnimation=0 >> iexpress-config.sed
echo UseLongFileName=1 >> iexpress-config.sed
echo InsideCompressed=0 >> iexpress-config.sed
echo CAB_FixedSize=0 >> iexpress-config.sed
echo CAB_ResvCodeSigning=0 >> iexpress-config.sed
echo RebootMode=N >> iexpress-config.sed
echo InstallPrompt=Funeral Home Management System Installer >> iexpress-config.sed
echo DisplayLicense= >> iexpress-config.sed
echo FinishMessage=Installation completed! Desktop shortcut created. Application starting... >> iexpress-config.sed
echo TargetName=%CD%\FuneralHome-Setup.exe >> iexpress-config.sed
echo FriendlyName=Funeral Home Management System >> iexpress-config.sed
echo AppLaunched=SETUP.bat >> iexpress-config.sed
echo PostInstallCmd=^<None^> >> iexpress-config.sed
echo AdminQuietInstCmd= >> iexpress-config.sed
echo UserQuietInstCmd= >> iexpress-config.sed
echo SourceFiles=SourceFiles >> iexpress-config.sed
echo [Strings] >> iexpress-config.sed
echo FILE0="SETUP.bat" >> iexpress-config.sed
echo FILE1="start.bat" >> iexpress-config.sed
echo FILE2="stop.bat" >> iexpress-config.sed
echo FILE3="app.jar" >> iexpress-config.sed
echo FILE4="README.txt" >> iexpress-config.sed
echo [SourceFiles] >> iexpress-config.sed
echo SourceFiles0=%CD%\installer\ >> iexpress-config.sed
echo [SourceFiles0] >> iexpress-config.sed

REM Add all files from installer directory
echo %%FILE0%%= >> iexpress-config.sed
echo %%FILE1%%= >> iexpress-config.sed
echo %%FILE2%%= >> iexpress-config.sed
echo %%FILE3%%= >> iexpress-config.sed
echo %%FILE4%%= >> iexpress-config.sed

REM Add JRE files (this is complex, so we'll use a simpler approach)
echo Step 3: Creating simpler ZIP-based installer...

REM Create a batch file that extracts and runs
echo @echo off > extract-and-install.bat
echo echo Funeral Home Management System Installer >> extract-and-install.bat
echo echo Extracting files... >> extract-and-install.bat
echo if not exist "%%TEMP%%\FuneralHome" mkdir "%%TEMP%%\FuneralHome" >> extract-and-install.bat
echo powershell Expand-Archive -Path "%%~dp0funeral-data.zip" -DestinationPath "%%TEMP%%\FuneralHome" -Force >> extract-and-install.bat
echo cd "%%TEMP%%\FuneralHome" >> extract-and-install.bat
echo call SETUP.bat >> extract-and-install.bat

REM Create the data archive
powershell Compress-Archive -Path "installer\*" -DestinationPath "funeral-data.zip" -Force

REM Use IExpress for the simple case
echo Step 4: Building with IExpress...
iexpress /N iexpress-config.sed

if exist "FuneralHome-Setup.exe" (
    echo ✅ SUCCESS: FuneralHome-Setup.exe created!
) else (
    echo ⚠️  IExpress failed, creating alternative...
    REM Create simple self-extracting batch
    echo @echo off > FuneralHome-Setup.bat
    echo echo Funeral Home Management System Installer >> FuneralHome-Setup.bat
    echo powershell Expand-Archive -Path "%%~dp0funeral-data.zip" -DestinationPath "%%TEMP%%\FuneralHome" -Force >> FuneralHome-Setup.bat
    echo cd "%%TEMP%%\FuneralHome" >> FuneralHome-Setup.bat
    echo call SETUP.bat >> FuneralHome-Setup.bat
    echo ✅ Created: FuneralHome-Setup.bat
)

REM Cleanup
del iexpress-config.sed 2>nul

echo ========================================
echo EXE Installer Ready!
echo ========================================
echo.
if exist "FuneralHome-Setup.exe" (
    echo 📦 File: FuneralHome-Setup.exe
    echo 📏 Size: 
    dir "FuneralHome-Setup.exe" | findstr "FuneralHome-Setup.exe"
) else (
    echo 📦 File: FuneralHome-Setup.bat + funeral-data.zip
)
echo.
echo USER EXPERIENCE:
echo 1. User double-clicks installer
echo 2. Files extract automatically
echo 3. Desktop shortcut "Funeral Home" created
echo 4. Application starts automatically
echo 5. Browser opens to http://localhost:8080
echo.
echo LOGIN: faustyna@zaklad.pl / admin
echo.
echo Ready for distribution! 🚀
pause