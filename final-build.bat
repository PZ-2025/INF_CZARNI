@echo off
echo ========================================
echo FINAL BUILD - React + Spring Boot
========================================

REM Step 1: Build React frontend
echo Step 1: Building React frontend...
cd frontend-next
call npm install
if %ERRORLEVEL% neq 0 (
    echo ERROR: npm install failed
    pause
    exit /b 1
)

call npm run build
if %ERRORLEVEL% neq 0 (
    echo ERROR: npm build failed
    pause
    exit /b 1
)

REM Step 2: Copy to Spring Boot static folder
echo Step 2: Copying frontend to Spring Boot...
cd ..
if exist "src\main\resources\static" (
    rmdir /s /q "src\main\resources\static"
)
mkdir "src\main\resources\static"

REM Copy ALL files from dist to static (without extra subfolder)
xcopy /E /I /Y "frontend-next\dist\*" "src\main\resources\static"

echo Files copied to static folder:
dir /b "src\main\resources\static"

REM Step 3: Build Spring Boot
echo Step 3: Building Spring Boot with embedded frontend...
if exist "mvnw.cmd" (
    call mvnw.cmd clean package -DskipTests
) else (
    call mvn clean package -DskipTests
)

if %ERRORLEVEL% neq 0 (
    echo ERROR: Spring Boot build failed
    pause
    exit /b 1
)

REM Step 4: Create distribution
echo Step 4: Creating final distribution...
if exist "dist" rmdir /s /q "dist"
mkdir dist

REM Copy JAR
for %%f in (target\*.jar) do (
    if not "%%f"=="target\*jar" (
        copy "%%f" "dist\app.jar"
        goto :jar_copied
    )
)
echo ERROR: No JAR file found!
pause
exit /b 1

:jar_copied

REM Copy JRE
if exist "jre-portable" (
    xcopy /E /I /Y "jre-portable" "dist\jre"
) else (
    echo WARNING: JRE not found! Download from https://adoptium.net/
)

REM Create production startup script
echo @echo off > "dist\start.bat"
echo echo ======================================== >> "dist\start.bat"
echo echo Funeral Home Management System >> "dist\start.bat"
echo echo ======================================== >> "dist\start.bat"
echo cd /d "%%~dp0" >> "dist\start.bat"
echo if not exist "data" mkdir data >> "dist\start.bat"
echo echo Starting application... >> "dist\start.bat"
echo echo Please wait 10-15 seconds... >> "dist\start.bat"
echo start /min "FuneralApp" jre\bin\java.exe -jar app.jar >> "dist\start.bat"
echo timeout /t 12 /nobreak ^> nul >> "dist\start.bat"
echo start http://localhost:8080 >> "dist\start.bat"
echo echo. >> "dist\start.bat"
echo echo Application started! >> "dist\start.bat"
echo echo URL: http://localhost:8080 >> "dist\start.bat"
echo echo. >> "dist\start.bat"
echo echo Default login accounts: >> "dist\start.bat"
echo echo - faustyna@zaklad.pl / admin >> "dist\start.bat"
echo echo - michal@zaklad.pl / admin >> "dist\start.bat"
echo echo - prac1@zaklad.pl / user >> "dist\start.bat"
echo echo. >> "dist\start.bat"
echo pause >> "dist\start.bat"

REM Create stop script
echo @echo off > "dist\stop.bat"
echo taskkill /f /im java.exe /fi "WINDOWTITLE eq FuneralApp" 2^>nul >> "dist\stop.bat"
echo echo Application stopped. >> "dist\stop.bat"
echo pause >> "dist\stop.bat"

echo ========================================
echo BUILD COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Test now: cd dist ^&^& start.bat
echo.
echo The app will run on: http://localhost:8080
echo Frontend and backend are now bundled together!
echo.
pause