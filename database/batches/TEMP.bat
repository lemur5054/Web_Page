@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B
)

:: Capture start time
set "StartTime=%time%"

:: ============================================
:: USER TEMP CLEANUP
:: ============================================
echo --------------------------------------------USER-TEMP---------------------------------------

set "userTemp=%LOCALAPPDATA%\Temp"

:: Delete all files including read-only and hidden files
del /f /s /q /a "%userTemp%\*.*" 2>nul

:: Loop through folders in reverse order and delete if empty
for /f "usebackq delims=" %%d in (`dir /ad /b /s "%userTemp%" ^| sort /r`) do (
    rd "%%d" 2>nul && (
        echo Deleted: "%%d"
    ) || (
        if exist "%%d" echo Skipped/Locked: "%%d"
    )
)

:: ============================================
:: WINDOWS TEMP CLEANUP
:: ============================================
echo -------------------------------------------WINDOWS-TEMP---------------------------------------

set "winTemp=%SystemRoot%\Temp"

:: Delete all files including read-only and hidden files
del /f /s /q /a "%winTemp%\*.*" 2>nul

:: Loop through folders in reverse order and delete if empty
for /f "usebackq delims=" %%d in (`dir /ad /b /s "%winTemp%" ^| sort /r`) do (
    rd "%%d" 2>nul && (
        echo Deleted: "%%d"
    ) || (
        if exist "%%d" echo Skipped/Locked: "%%d"
    )
)

echo -------------------------------------------FINISHED---------------------------------------

:: Capture end time
set "EndTime=%time%"

:: Calculate time elapsed
for /F "tokens=1-4 delims=:.," %%a in ("%StartTime%") do (
   set /a "start_s=(%%a*3600)+(%%b*60)+%%c"
)
for /F "tokens=1-4 delims=:.," %%a in ("%EndTime%") do (
   set /a "end_s=(%%a*3600)+(%%b*60)+%%c"
)

:: Handle midnight crossover
if %end_s% lss %start_s% set /a "end_s+=86400"
set /a "duration=end_s-start_s"

echo =======================================================================================
echo Cleanup complete!
echo Started at:  %StartTime%
echo Finished at: %EndTime%
echo Total Time:  %duration% seconds
echo =======================================================================================

pause
exit
