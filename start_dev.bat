@echo off
echo 🚀 Waking up the development environment...

:: 1. Navigate to your project directory (optional, but good practice)
cd /d "%~dp0"

:: 2. Ensure MySQL Service is running (forces it to start if Windows stopped it)
echo 🛢️ Checking MySQL Service...
net start MySQL80 >nul 2>&1

:: 3. Activate the virtual environment and launch the app
echo 🐍 Activating virtual environment and launching app...
call venv\Scripts\activate.bat

:: 4. Run your Python app (replace app.py with your main file name)
python app.py

pause