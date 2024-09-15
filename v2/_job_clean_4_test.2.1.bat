@echo off

REM w@ibar.cn 2024-09-01 22:58:14

if "%~1" == "" echo. "warn: agr 1 must" & goto :EOF

set "_test_dp0=%~dp0"
set "_test_n0=%~n0"
set "_test_dir=G:\test_1\"
set "_dev_target_dir=G:\localSites_g\shell\mfbaktool_dev\v2\"
set "_test_version=%_test_n0:~-3%"
set "_dev_type=%_test_n0:~1,3%"
set "_dev_bat=t_%_dev_type%.%_test_version%"

set "_test_version_1=%_test_version%"

if "%_test_version:~-1%" == "0" set "_test_version_1=%_test_version:~0,1%"

REM echo "%_test_n0:~1,3%"
REM echo "%_test_version%"
REM echo "%_test_version_1%"
REM echo "%_dev_bat%"
REM if "%_test_version%" neq "%_test_version_1%" echo "not 2.1"

REM goto :EOF

if "%_test_dir:~1%" NEQ  "%_test_dp0:~1,9%" echo. "must in  %_test_dir% dir" & goto :EOF

if exist "%_test_dp0%*.log" del "%_test_dp0%*.log"
if exist "%_test_dp0%*.log.txt" del "%_test_dp0%*.log.txt"
if exist "%_dev_target_dir%*.log" del "%_dev_target_dir%*.log"
if exist "%_dev_target_dir%\demo_bat\*.log" del "%_dev_target_dir%\demo_bat\*.log"


REM xcopy t_job_2*.bat "G:\localSites_g\shell\mfbaktool_dev\v2\" /y /q
REM xcopy "mbt_2---job---demo*.bat" "G:\localSites_g\shell\mfbaktool_dev\v2\" /y /q
REM copy ?.txt aa\ /y


copy "%_dev_bat%.bat" "%_dev_target_dir%" /y

if /i "%~1" neq "yes-all" goto :EOF

copy "%_dev_bat%.bat" "%_dev_target_dir%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-b1.bat" /y
if "%_test_version%" neq "%_test_version_1%" (
  copy "%_dev_bat%.bat" "%_dev_target_dir%demo_bat\%_dev_type%---test-b1.bat" /y
)
copy "%_dev_bat%.bat" "%_dev_target_dir%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-b1---G##test_1.bat" /y
copy "%_dev_bat%.bat" "%_dev_target_dir%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-notfind.bat" /y
copy "%_dev_bat%.bat" "%_dev_target_dir%demo_bat\mbt_%_test_version_1%---%_dev_type%---delete test b1.bat" /y
copy "%_dev_bat%.bat" "%_dev_target_dir%" /y
copy %~nx0 "%_dev_target_dir%%~nx0" /y




