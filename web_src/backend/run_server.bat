@echo off
cd /d C:\Wassaliparceldeliveryapp\backend
set PYTHONPATH=C:\Wassaliparceldeliveryapp\backend
echo Starting Wassali Backend Server...
C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
pause
