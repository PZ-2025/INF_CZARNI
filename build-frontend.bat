@echo off
echo ========================================
echo Building Frontend for Production
echo ========================================

cd frontend-next

echo Installing dependencies...
call npm install
if %ERRORLEVEL% neq 0 (
    echo ERROR: npm install failed
    pause
    exit /b 1
)

echo Building production bundle...
call npm run build
if %ERRORLEVEL% neq 0 (
    echo ERROR: npm build failed
    pause
    exit /b 1
)

echo Copying files to Spring Boot static resources...
if exist "..\src\main\resources\static" (
    rmdir /s /q "..\src\main\resources\static"
)
mkdir "..\src\main\resources\static"

xcopy /E /I /Y "dist\*" "..\src\main\resources\static\"
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to copy frontend files
    pause
    exit /b 1
)

cd ..
echo ========================================
echo Frontend build completed successfully!
echo ========================================