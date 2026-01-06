@echo off
cd /d %~dp0
echo ============================================
echo    Wassali Backend API Server
echo ============================================
echo.
echo Demarrage du serveur sur http://localhost:8000
echo Documentation: http://localhost:8000/api/v1/docs
echo.
C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000
pause
