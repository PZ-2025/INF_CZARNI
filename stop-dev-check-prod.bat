@echo off
echo ========================================
echo Stopping Dev Servers and Testing Production
========================================

echo Step 1: Killing all Node.js processes (Vite dev server)
taskkill /f /im node.exe 2>nul
taskkill /f /im npm.exe 2>nul
echo Dev servers stopped.

echo Step 2: Killing any Java processes
taskkill /f /im java.exe 2>nul
echo Java processes stopped.

timeout /t 2 /nobreak > nul

echo Step 3: Starting PRODUCTION build
cd dist
if not exist "app.jar" (
    echo ERROR: app.jar not found! Run final-build.bat first.
    pause
    exit /b 1
)

if not exist "jre" (
    echo ERROR: JRE folder not found!
    pause
    exit /b 1
)

echo Starting production Spring Boot with embedded React...
start.bat