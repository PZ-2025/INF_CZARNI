@echo off
echo ========================================
echo Building Funeral Home Management System
echo ========================================

REM Check if Maven Wrapper is available
if exist "mvnw.cmd" (
    echo Using Maven Wrapper...
    set MAVEN_CMD=mvnw.cmd
) else (
    REM Check if Maven is available
    mvn --version >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Neither Maven Wrapper nor Maven found!
        echo Please install Maven or ensure mvnw.cmd exists in project root.
        pause
        exit /b 1
    )
    set MAVEN_CMD=mvn
)

REM Check if Node.js is available
node --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Node.js not found! Please install Node.js first.
    pause
    exit /b 1
)

REM Build frontend
echo Step 1: Building frontend...
call build-frontend.bat
if %ERRORLEVEL% neq 0 (
    echo ERROR: Frontend build failed
    pause
    exit /b 1
)

REM Build backend (fat JAR)
echo Step 2: Building backend...
call %MAVEN_CMD% clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo ERROR: Backend build failed
    pause
    exit /b 1
)

REM Create distribution folder
echo Step 3: Creating distribution...
if exist "dist" (
    rmdir /s /q "dist"
)
mkdir dist

REM Copy JAR file
copy "target\pogrzebowy-*.jar" "dist\app.jar"

REM Download portable JRE (if not exists)
if not exist "jre-portable" (
    echo Step 4: Downloading portable JRE...
    REM You'll need to manually download and extract JRE here
    echo Please download JRE 17+ portable and extract to 'jre-portable' folder
    echo Download from: https://adoptium.net/temurin/releases/
    pause
) else (
    echo Step 4: Using existing JRE...
)

REM Copy JRE
xcopy /E /I /Y "jre-portable" "dist\jre"

REM Create startup scripts
echo Step 5: Creating startup scripts...

REM Windows startup script
echo @echo off > "dist\start.bat"
echo echo Starting Funeral Home Management System... >> "dist\start.bat"
echo echo Please wait... >> "dist\start.bat"
echo cd /d "%%~dp0" >> "dist\start.bat"
echo if not exist "data" mkdir data >> "dist\start.bat"
echo start /min cmd /c "jre\bin\java.exe -jar app.jar" >> "dist\start.bat"
echo timeout /t 5 /nobreak ^> nul >> "dist\start.bat"
echo start http://localhost:8080 >> "dist\start.bat"
echo echo System started! Check your browser. >> "dist\start.bat"
echo pause >> "dist\start.bat"

REM Stop script
echo @echo off > "dist\stop.bat"
echo echo Stopping Funeral Home Management System... >> "dist\stop.bat"
echo taskkill /f /im java.exe 2^>nul >> "dist\stop.bat"
echo echo System stopped. >> "dist\stop.bat"
echo pause >> "dist\stop.bat"

REM Create README
echo Funeral Home Management System > "dist\README.txt"
echo ================================= >> "dist\README.txt"
echo. >> "dist\README.txt"
echo To start the application: >> "dist\README.txt"
echo 1. Double-click 'start.bat' >> "dist\README.txt"
echo 2. Wait for the browser to open automatically >> "dist\README.txt"
echo 3. Login with: admin / admin >> "dist\README.txt"
echo. >> "dist\README.txt"
echo To stop the application: >> "dist\README.txt"
echo - Double-click 'stop.bat' >> "dist\README.txt"
echo. >> "dist\README.txt"
echo Database files are stored in 'data' folder >> "dist\README.txt"

echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Distribution created in 'dist' folder
echo.
echo IMPORTANT: Before distributing, download JRE 17+ portable
echo and extract it to 'jre-portable' folder, then run this script again.
echo.
pause