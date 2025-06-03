@echo off
echo ========================================
echo Checking if React is bundled in JAR
========================================

if not exist "dist\app.jar" (
    echo app.jar not found! Run final-build.bat first.
    pause
    exit /b 1
)

echo Checking JAR contents for static files...
echo.

REM List static files in JAR
jre-portable\bin\jar tvf dist\app.jar | findstr "static"

echo.
echo ========================================
echo Key files to look for:
echo - BOOT-INF/classes/static/index.html
echo - BOOT-INF/classes/static/assets/
echo ========================================

if exist "src\main\resources\static\index.html" (
    echo ✅ index.html found in source static folder
) else (
    echo ❌ index.html NOT found in source static folder
    echo Run final-build.bat to copy frontend files
)
set /p "id=...: "
echo.
pause