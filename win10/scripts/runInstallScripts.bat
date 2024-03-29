@echo off
powershell -command "Set-ExecutionPolicy 0"
powershell "& ""%~dp0install\installChocolatey"""
cd %~dp0install/packs
start "runtimes" /b /w cmd /c call runtimes.bat 
start "normalOffice" /b /w cmd /c call normalOffice.bat
cd ../../drivers
NetSh Advfirewall set allprofiles state off
start /b /w "driverInstall" cmd /c call SDI_auto.bat -autoinstall -nogui -autoclose
NetSh Advfirewall set allprofiles state on
cd ..
powershell -command "Set-ExecutionPolicy Restricted"
if %1 == -a (
    cd activate
    reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
    if %OS%==32BIT cd activateWindows/vlmcsd32
    if %OS%==64BIT cd activateWindows/vlmcsd64
    TIMEOUT /T 10
    start "windowsActivate" /b /w cmd /c call install.bat
    cd ../..
    start "officeActivate" /b /w cmd /c call activateOffice.bat
)
