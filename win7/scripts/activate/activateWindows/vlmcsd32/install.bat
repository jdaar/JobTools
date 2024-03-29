@echo off
cd %~dp0
echo Installing TAP driver...
bin\tap-windows-installer.exe
echo Installing now the KMS server service...
bin\vlmcsd.exe -s -U /n -O
echo Adding firewall exception...
netsh advfirewall firewall add rule name="vlmcsd" dir=in action=allow program=%~dp0bin\vlmcsd.exe enable=yes
echo Starting vlmcsd service...
net start vlmcsd
start notepad keys.txt
set /p kmsKey=Enter a valid key for your Windows version: 
echo Installing key...
slmgr /ipk %kmsKey%
echo Setting up KMS address...
slmgr /skms 10.10.10.10
echo Sending activation request...
slmgr /ato
echo All done! Press enter to exit.
pause > nul
exit
