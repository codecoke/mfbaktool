@echo off

REM w(a)ibar.cn 2024-09-16 00:58:47


REM cls & _clean_4_mfbaktool_test.2.0.bat bylist 2.0 3
REM cls & _clean_4_mfbaktool_test.2.0.bat job 2.2 3


set "_clear_file=%~dpnx0"
set "_test_dp0=%~dp0"
set "_test_n0=%~n0"

set "_test_dir=C:\test_1\"


set "_dir_target=C:\test_1\test_1\"

set "_dir_target=C:\localSites_g\shell\mfbaktool_dev\v2\"

set "_type=%~1"
set "_version=%~2"
set "_act=%~3"

if "%_act%" == "" (
  set /a _act=0
)

set /a _act=%_act%

REM act:
REM info.clear.copy.sync

set "_err="

if "%_type%" == "" set "_err=[_type] agr 1 must" & goto _end_with_err
if "%_version%" == "" set "_err=[_version] agr 2 must" & goto _end_with_err
if "%_version:~1,1%" NEQ "." set "_err=[_version] must n.n" & goto _end_with_err
if not exist "%_dir_target%" set "_err=unfind _dir_target: [%_dir_target%]" & goto _end_with_err
if "%_test_dir%" NEQ  "%_test_dp0%" set "_err=[%_test_dp0%] NEQ [%_test_dir%]" & goto _end_with_err

REM t_job.2.2.bat
if not exist "%_test_dp0%t_%_type%.%_version%.bat" set "_err=[t_%_type%.%_version%.bat] unfind" & goto _end_with_err


if "%_err%" NEQ "" goto _end_with_err


REM -1 show info
if %_act% LSS 0 call :_echo_vars_info & goto :EOF

REM 0 copy file if_not
if not exist "%_dir_target%%_test_n0%.bat" copy "%_test_dp0%%_test_n0%.bat" "%_dir_target%" /y
if not exist "%_dir_target%t_%_type%.%_version%.bat" copy "%_test_dp0%t_%_type%.%_version%.bat" "%_dir_target%" /y

if %_act% LSS 1 goto _end_sucess

REM 1 clear log
if exist "%_test_dp0%*.log" del "%_test_dp0%*.log"
if exist "%_test_dp0%*.log.txt" del "%_test_dp0%*.log.txt"
if exist "%_dir_target%*.log" del "%_dir_target%*.log"
if exist "%_dir_target%\demo_bat\*.log" del "%_dir_target%\demo_bat\*.log"

if %_act% LSS 2 goto _end_sucess

REM 2 copy and overwrite
REM clear_4_test.x.x.bat
copy "%_test_dp0%%_test_n0%.bat" "%_dir_target%" /y

REM t_job.x.x.bat
copy "%_test_dp0%t_%_type%.%_version%.bat" "%_dir_target%" /y


if %_act% LSS 3 goto _end_sucess

REM 3 cpoy demo

set "_version_1=%_version%"

if "%_version:~-1%" == "0" set "_version_1=%_version:~0,1%"
set "_dir_demo=%_dir_target%demo_bat\"
if not exist "%_dir_demo%" set "_err=unfind [%_dir_demo%]" & goto _end_with_err


set "_target_demo_1="
set "_target_demo_2="
set "_target_demo_3="
set "_target_demo_4="


if "%_type%" == "bylist" goto _type_bylist_demo
if "%_type%" == "list" goto _type_bylist_demo
if "%_type%" == "job" goto _type_job_demo

REM copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-b1---G##test_1.bat" /y
REM copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-notfind.bat" /y
REM copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---delete test b1.bat" /y

goto _copy_target_demo

:_type_job_demo
set "_target_demo_1=test-b1"
set "_target_demo_2=test-b1---G##test_1"
set "_target_demo_3=test-notfind"
set "_target_demo_4=delete test b1"



goto _copy_target_demo
:_type_bylist_demo
set "_target_demo_1=C##test_1#bylist.1.ini---C##test_1#test 2"

goto _copy_target_demo



REM copy type to demo list
:_copy_target_demo

REM del /Q test_1\demo_bat\*
REM echo "%_dir_target%t_%_type%.%_version%.bat"

if "%_target_demo_1%" == "" goto _end_copy_target_demo

copy "%_dir_target%t_%_type%.%_version%.bat" "%_dir_target%demo_bat\mbt_%_version_1%---%_type%---%_target_demo_1%.bat" /y

if "%_target_demo_2%" == "" goto _end_copy_target_demo
copy "%_dir_target%t_%_type%.%_version%.bat" "%_dir_target%demo_bat\mbt_%_version_1%---%_type%---%_target_demo_2%.bat" /y

if "%_target_demo_3%" == "" goto _end_copy_target_demo
copy "%_dir_target%t_%_type%.%_version%.bat" "%_dir_target%demo_bat\mbt_%_version_1%---%_type%---%_target_demo_3%.bat" /y

if "%_target_demo_4%" == "" goto _end_copy_target_demo
copy "%_dir_target%t_%_type%.%_version%.bat" "%_dir_target%demo_bat\mbt_%_version_1%---%_type%---%_target_demo_4%.bat" /y



:_end_copy_target_demo

REM echo "_dir_demo:%_dir_demo%"


REM if "%_act%" == "" set "_act=info"

REM if "%_version%" == "" set "_version=%_test_n0:~-3%"
REM set "_version_main=%_version:~0,1%"

REM set "_dev_type=%_test_n0:~1,3%"
REM set "_dev_bat=t_%_dev_type%.%_test_version%"
REM t_job_2.2

REM call :_echo_vars_info


REM echo. "_test_dp0:%_test_dp0%"
REM echo. "_test_n0:%_test_n0%"
REM echo. "_type:%_type%"
REM echo. "_act:%_act%"
REM echo. "_version:%_version%"
REM echo. "_clear_file:%_clear_file%"
REM echo. "_target_dir:%_target_dir%"

REM echo. "%_test_dp0%"


REM echo. "%_test_dp0%t_%_type%.%_version%.bat"



goto :EOF

:_end_sucess

echo. & echo. "--- ok ---" 
echo. "%_type% , %_version% , %_act%" & echo.

goto :EOF


:_end_with_err

echo. & echo. "--- err ---" & echo.
echo. "%_err%"
call :_echo_vars_info


goto :EOF



:_echo_vars_info

echo. & echo. "%_type% , %_version% , %_act%" & echo.

echo. "_test_dp0:%_test_dp0%"
echo. "_test_n0:%_test_n0%"
REM echo. "_type:%_type%"
REM echo. "_act:%_act%"
REM echo. "_version:%_version%"
REM echo. "_clear_file:%_clear_file%"
REM echo. "_target_dir:%_target_dir%"
REM echo. "t_file:%_test_dp0%t_%_type%.%_version%.bat"


goto :EOF





if "%~1" == "" echo. "warn: agr 1 must" & goto :EOF


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
if exist "%_dir_target%*.log" del "%_dir_target%*.log"
if exist "%_dir_target%\demo_bat\*.log" del "%_dir_target%\demo_bat\*.log"


REM xcopy t_job_2*.bat "G:\localSites_g\shell\mfbaktool_dev\v2\" /y /q
REM xcopy "mbt_2---job---demo*.bat" "G:\localSites_g\shell\mfbaktool_dev\v2\" /y /q
REM copy ?.txt aa\ /y


copy "%_dev_bat%.bat" "%_dir_target%" /y

if /i "%~1" neq "yes-all" goto :EOF

copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-b1.bat" /y
if "%_test_version%" neq "%_test_version_1%" (
  copy "%_dev_bat%.bat" "%_dir_target%demo_bat\%_dev_type%---test-b1.bat" /y
)
copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-b1---G##test_1.bat" /y
copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---test-notfind.bat" /y
copy "%_dev_bat%.bat" "%_dir_target%demo_bat\mbt_%_test_version_1%---%_dev_type%---delete test b1.bat" /y
copy "%_dev_bat%.bat" "%_dir_target%" /y
copy %~nx0 "%_dir_target%%~nx0" /y




