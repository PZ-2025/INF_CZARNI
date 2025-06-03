@echo off
echo ========================================
echo Fixing ALL URLs to full localhost:8080
========================================

cd frontend-next

echo Making all fetch URLs complete with http://localhost:8080...

REM Fix all relative URLs to full URLs
for /r "src" %%f in (*.jsx *.js) do (
    echo Processing: %%f

    REM Replace relative URLs with full URLs
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/users\", \"fetch('http://localhost:8080/users\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/auth\", \"fetch('http://localhost:8080/auth\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/tasks\", \"fetch('http://localhost:8080/tasks\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/orders\", \"fetch('http://localhost:8080/orders\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/clients\", \"fetch('http://localhost:8080/clients\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/reports\", \"fetch('http://localhost:8080/reports\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/assignments\", \"fetch('http://localhost:8080/assignments\" | Set-Content '%%f'"

    REM Fix any other relative API calls
    powershell -Command "(Get-Content '%%f') -replace \"fetch\('/api\", \"fetch('http://localhost:8080/api\" | Set-Content '%%f'"

    REM Fix partial URLs (like fetch("users/me") without leading slash)
    powershell -Command "(Get-Content '%%f') -replace \"fetch\(`\"users/\", \"fetch('http://localhost:8080/users/\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\(`\"auth/\", \"fetch('http://localhost:8080/auth/\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\(`\"tasks/\", \"fetch('http://localhost:8080/tasks/\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\(`\"orders/\", \"fetch('http://localhost:8080/orders/\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\(`\"clients/\", \"fetch('http://localhost:8080/clients/\" | Set-Content '%%f'"
    powershell -Command "(Get-Content '%%f') -replace \"fetch\(`\"reports/\", \"fetch('http://localhost:8080/reports/\" | Set-Content '%%f'"
)

cd ..

echo ========================================
echo All URLs fixed to http://localhost:8080
========================================
echo.
echo Now test:
echo 1. Start backend: cd dist ^&^& start.bat
echo 2. Start frontend dev: cd frontend-next ^&^& npm run dev
echo 3. Frontend on :5173 should connect to backend on :8080
echo.
pause