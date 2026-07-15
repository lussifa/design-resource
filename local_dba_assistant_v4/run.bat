@echo off
setlocal
cd /d "%~dp0"

echo =============================================
echo   Local DBA Assistant - Starting...
echo =============================================

where py >nul 2>nul
if %errorlevel%==0 (
    set "PYTHON_CMD=py -3"
) else (
    set "PYTHON_CMD=python"
)

if not exist ".venv\Scripts\python.exe" (
    echo [1/3] Creating Python virtual environment...
    %PYTHON_CMD% -m venv .venv
    if errorlevel 1 goto :error
)

echo [2/3] Installing dependencies...
call ".venv\Scripts\activate.bat"
python -m pip install --disable-pip-version-check -r requirements.txt
if errorlevel 1 goto :error

echo [3/3] Starting Web service: http://127.0.0.1:5000
start "" cmd /c "timeout /t 2 /nobreak >nul & start http://127.0.0.1:5000"
python -m waitress --host=0.0.0.0 --port=5000 --threads=8 app:app
if errorlevel 1 goto :error

goto :eof

:error
echo.
echo Startup failed. Review the error above.
pause
exit /b 1
