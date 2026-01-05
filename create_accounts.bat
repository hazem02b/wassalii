@echo off
echo ============================================
echo Creation des comptes de test Wassali
echo ============================================
echo.

echo [1/2] Creation du compte CLIENT...
curl -X POST http://localhost:8000/api/v1/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"client@wassali.com\",\"password\":\"ClientTest123!\",\"name\":\"Client Test\",\"phone\":\"0600000001\",\"role\":\"client\"}"
echo.
echo.

echo [2/2] Creation du compte TRANSPORTEUR...
curl -X POST http://localhost:8000/api/v1/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"transporteur@wassali.com\",\"password\":\"TransportTest123!\",\"name\":\"Transporteur Test\",\"phone\":\"0600000002\",\"role\":\"transporter\"}"
echo.
echo.

echo ============================================
echo Comptes crees avec succes!
echo ============================================
echo.
echo CLIENT:
echo   Email: client@wassali.com
echo   Password: ClientTest123!
echo.
echo TRANSPORTEUR:
echo   Email: transporteur@wassali.com
echo   Password: TransportTest123!
echo.
echo ============================================
pause
