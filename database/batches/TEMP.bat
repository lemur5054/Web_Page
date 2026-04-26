echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B
)


echo --------------------------------------------USER-TEMP---------------------------------------

set "userTemp=%USERPROFILE%\AppData\Local\Temp\*.*"
DEL %userTemp% /S /Q

for /f "usebackq delims=" %%d in (`dir /ad/b/s "%userTemp%" ^| sort /r`) do (
    rem Check if the directory is empty
    dir /a-d /b "%%d" | findstr . >nul || (
        rd "%%d" 2>nul
        if exist "%%d" (
            echo Failed to delete: "%%d"
        ) else (
            echo Deleted: "%%d"
        )
    )
)
 

echo -------------------------------------------WINDOWS-TEMP---------------------------------------

set "winTemp=C:\Windows\Temp\*.*"
DEL %winTemp% /S /Q

for /f "usebackq delims=" %%d in (`dir /ad/b/s "%winTemp%" ^| sort /r`) do (
    rem Check if the directory is empty
    dir /a-d /b "%%d" | findstr . >nul || (
        rd "%%d" 2>nul
        if exist "%%d" (
            echo Failed to delete: "%%d"
        ) else (
            echo Deleted: "%%d"
        )
    )
)
 


echo -------------------------------------------FINNISHED---------------------------------------
pause
exit