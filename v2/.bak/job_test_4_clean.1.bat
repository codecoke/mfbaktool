@echo off

if "%~1" == "" echo. "warn: agr 1 must" & goto :EOF

set "_test_dp0=%~dp0"
set "_test_dir=G:\test_1\"
set "_test_target_dir=G:\localSites_g\shell\mfbaktool_dev\v2\"
set "_test_bat=t_job_2.1"

if "%_test_dir:~1%" NEQ  "%_test_dp0:~1,9%" echo. "must in  %_test_dir% dir" & goto :EOF

if exist "%_test_dp0%*.log" del "%_test_dp0%*.log"
if exist "%_test_dp0%*.log.txt" del "%_test_dp0%*.log.txt"
if exist "%_test_target_dir%*.log" del "%_test_target_dir%*.log"


REM xcopy t_job_2*.bat "G:\localSites_g\shell\mfbaktool_dev\v2\" /y /q
REM xcopy "mbt_2---job---demo*.bat" "G:\localSites_g\shell\mfbaktool_dev\v2\" /y /q

REM copy ?.txt aa\ /y

REM if not exist "%_test_target_dir%%~nx0" (
REM   copy %~nx0 "%_test_target_dir%%~nx0"
REM )

copy "%_test_bat%.bat" "G:\localSites_g\shell\mfbaktool_dev\v2\" /y

if /i "%~1" neq "yes-all" goto :EOF

copy "%_test_bat%.bat" "%_test_target_dir%demo_bat\mbt_2---job---test-b1.bat" /y
copy "%_test_bat%.bat" "%_test_target_dir%demo_bat\job---test-b1.bat" /y
copy "%_test_bat%.bat" "%_test_target_dir%demo_bat\mbt_2---job---test-b1---G##test_1.bat" /y
copy "%_test_bat%.bat" "%_test_target_dir%demo_bat\mbt_2---job---test-notfind.bat" /y
copy "%_test_bat%.bat" "%_test_target_dir%demo_bat\mbt_2---job---delete test b1.bat" /y
copy "%_test_bat%.bat" "%_test_target_dir%" /y
copy %~nx0 "%_test_target_dir%%~nx0" /y




