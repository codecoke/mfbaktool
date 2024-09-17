@echo off

setlocal enabledelayedexpansion


REM if "up_vscode2last_config=" then use config.you-bat-name.txt
set "up_vscode2last_config="

REM defined config youself:
REM set "up_vscode2last_config=c:\some\file-name-of-you-config.txt"


REM Do not modify the following if not necessary
set "_up_run_dir=%~dp0"
set "_up_arg_1=%~1"
set _up_exit_code=0
set /a mf_mod_cmd_test_code=0
set "up_is_in_test_dir=no"

if "%up_vscode2last_config%" == "" set "up_vscode2last_config=config.%~n0"
if "%up_vscode2last_config:~-4%" neq ".txt" (
  set "up_vscode2last_config=%up_vscode2last_config%.txt"
)
if "%up_vscode2last_config:~1,2%" neq ":\" (
  set "up_vscode2last_config=%_up_run_dir%%up_vscode2last_config%"
)

set "date_hh=%time:~,2%"
if "%date_hh:~0,1%" == " " set "date_hh=0%date_hh:~1,1%"
set "date_ymd=%date:~3,7%-%date:~5,2%-%date:~8,2% %date_hh%:%time:~3,2%:%time:~6,2%"

if not exist "%up_vscode2last_config%" (
    echo. "--- err"
    echo. "--- not find config_file"
    echo. "--- [!up_vscode2last_config!]"
    goto exit_with_err
)

if "%_up_arg_1%" == "config-name" (
    echo "%up_vscode2last_config%"
    exit /b 0
)

REM call "%share_cmd_mod%\vals_by_file.1.bat" "%up_vscode2last_config%" "-"
call "vals_by_file.1.bat" "%up_vscode2last_config%" "-"

set "_up_errcode=%ERRORLEVEL%"

if %_up_errcode% neq 0 (
  echo. "--- err "
  echo. "--- read vals from file faild. code [%_up_errcode%] "
  if "%_up_errcode%" equ "404" (
    echo. "---  file not find:"
    echo. "[%_up_run_dir%%up_vscode2last_config%]"
  )
  goto exit_with_err
)

REM echo. "up_zip_search_name : %up_zip_search_name%"
REM echo. "up_dir_unzip_pre : %up_dir_unzip_pre%"
REM echo. "up_log_dir : %up_log_dir%"
REM echo. "_up_log_ck : %_up_log_ck%"
REM echo. "_up_dir_unzip : %_up_dir_unzip%"
REM echo. "up_is_in_test_dir : %up_is_in_test_dir%"

REM echo "up_del_zip_after_sucess : %up_del_zip_after_sucess%"

set "up_zip_file_name="
set "up_log_pid=%up_log_dir%\up_pid"
set "up_log_ck=%up_log_dir%\up_???"
set "up_log_ok_pre=up_ok1"
set "up_log_err_pre=up_err"
set "up_log_ok="
set "up_log_err="

set "dir_unzip=%up_dir_unzip_pre%"
set "dir_bak_last=%up_dir_bak_pre%_%dir_vscode_last_version%"

set "up_info_1="
set "up_info_err="
set /a up_i=1
set "up_i_pre=0"

set "_up_is_test=%~1"

::echo "up_dir is exists" && goto :EOF

pushd %~dp0
echo.
echo. "--- start updata"

if /i "%up_is_in_test_dir%" neq "yes" (
  if "%~1" == "" (
    echo. "--- err :"
    echo. "--- up_is_in_test_dir : %up_is_in_test_dir%"
    echo. "--- %%1 must need"
    goto exit_with_err
  )
)

IF not EXIST "%dir_vscode_last_version%\data\" (
  echo. "--- err: not find user_data:[%dir_vscode_last_version%\data\]"
  goto exit_with_err
)

IF not EXIST "%up_zip_search_name%" (
  echo. "--- err: not find any_up_zip_file:[%up_zip_search_name%]"
  goto exit_with_err
)

IF not EXIST "%up_z7_exe%" (
  echo. "--- err: not find 7-zip.exe:[%up_z7_exe%]"
  goto exit_with_err
)

set "_up_zip_file="
for /f "usebackq delims=" %%i in (`dir /a:-d /o:-d /b "%up_zip_search_name%"`) do (
  if "!up_zip_file_name!" == "" (
    set "_up_zip_file=%%i"
    set "up_zip_file_name=!_up_zip_file:~0,-4!"
  )
)

IF "%_up_zip_file%" == "" (
  echo. "--- err: not find any_up_zip_file:[%up_zip_search_name%]"
  goto exit_with_err
)

IF not EXIST "%_up_zip_file%" (
  echo. "--- err: not find any_up_zip_file:[%_up_zip_file%]"
  goto exit_with_err
)


set "up_log_pid=%up_log_pid%_%up_zip_file_name%.txt"
set "up_log_ck=%up_log_ck%_%up_zip_file_name%.txt"
set "up_log_err=%up_log_err_pre%_%up_zip_file_name%.txt"
set "up_log_ok=%up_log_ok_pre%_%up_zip_file_name%.txt"
set "dir_unzip=%dir_unzip%_%up_zip_file_name%"

echo.
REM echo "up_zip_file_name %up_zip_file_name%"
REM echo "up_log_pid %up_log_pid%"
REM echo "up_log_ck %up_log_ck%"
REM echo "up_log_err %up_log_err%"
REM echo "up_log_ok %up_log_ok%"
REM echo "dir_unzip %dir_unzip%"
REM echo "dir_bak_last %dir_bak_last%"
REM echo "dir_vscode_last_version %dir_vscode_last_version%"
REM echo "up_log_dir %up_log_dir%"


if  not exist "%up_log_dir%\" (
  echo. "creat dir [%up_log_dir%\]"
  mkdir "%up_log_dir%\"
  goto ck_unzip_dir
)

if not exist "%up_log_ck%" (
  echo. "[0%up_i% %date_ymd%:!time:~6,2!] up_log_ck is ok,go on"
  REM echo. "[%up_log_ck%]"
  goto ck_unzip_dir
)

if exist "%up_log_dir%\%up_log_ok%" (
    echo. "--- this verion:"
    echo. "--- [%up_zip_file_name%]"
    echo. "--- had update sucess last time!"
    goto end_up_vscode
)

REM last updata not finish
if exist "%up_log_pid%" (
  echo. "--- error:"
  echo. "--- [%up_zip_file_name%] last update not finish"
  echo. "--- check file: [%up_log_pid%]"
  goto exit_with_err
)

REM last updata not finish
if exist "%up_log_dir%\%up_log_err%" (
  echo. "--- error:"
  echo. "--- [%up_zip_file_name%] last update err"
  echo. "--- check file: [%up_log_dir%\%up_log_err%]"
  goto exit_with_err
)

REM any up_???_zip_filename.txt means unknow err
if exist "%up_log_ck%" (
  echo. "unknow error,ck feile:"
  echo. "[%up_log_ck%]"
  goto exit_with_err
)

:ck_unzip_dir

if exist "%dir_unzip%\" (
  echo. "--- error:"
  echo. "--- find [%dir_unzip%] means last up faild"
  echo. "--- ck last update faild info"
  goto exit_with_err
)

if exist "%dir_bak_last%\" (
  echo. "--- error:"
  echo. "--- find [%dir_bak_last%\] means last up faild"
  echo. "--- ck last update faild info"
  goto exit_with_err
)



REM write log_pid
set /a up_i=%up_i%+1
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] write update pid"
echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

if %ERRORLEVEL% neq 0 set "up_info_err=error write update pid %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err

REM unzip _up_zip_file
set /a up_i=%up_i%+1
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] unzip [%_up_zip_file%]"

echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

start "" /wait "%up_z7_exe%" x "%_up_zip_file%" -y -o"./%dir_unzip%"

if %ERRORLEVEL% neq 0 set "up_info_err=error when unzip,code %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err

ping 127.0.0.1 -n 3 1>nul


REM stop vscode

set /a up_i=%up_i%+1
if "%up_is_in_test_dir%" neq "yes" (
  set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] stop vs code task"
  echo. "!up_info_1!">>"%up_log_pid%"
  echo. "!up_info_1!">>con
  
  REM set "_up_vscode_is_runing=no"  
  REM tasklist /v /fi "IMAGENAME eq Code.exe" | find  /i "code" || set "_up_vscode_is_runing=yes"

  tasklist /v /fi "IMAGENAME eq Code.exe" /fo csv /nh | find /i "code" >nul && set "_up_vscode_is_runing=yes" || set "_up_vscode_is_runing=no"

  if "!_up_vscode_is_runing!" == "yes" (
    start "" /wait taskkill /f /t /im "Code.exe"
    ping 127.0.0.1 -n 10 1>nul
  )

  tasklist /v /fi "IMAGENAME eq Code.exe" /fo csv /nh | find /i "code" >nul && set "_up_vscode_is_runing=yes" || set "_up_vscode_is_runing=no"

  if "!_up_vscode_is_runing!" == "yes" (
    start "" /wait taskkill /f /t /im "Code.exe"
    ping 127.0.0.1 -n 10 1>nul
  )

  if %ERRORLEVEL% neq 0 set "up_info_err=error when stop code %ERRORLEVEL%"
  if "%up_info_err%" neq "" goto writr_err

) else (
  set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] up_is_in_test_dir:%up_is_in_test_dir%"
  echo. "!up_info_1!">>"%up_log_pid%"
  echo. "!up_info_1!">>con
)


REM rename last—_version
set /a up_i=%up_i%+1
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] rename [%dir_vscode_last_version%] to [%dir_bak_last%]"
echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

ren "%dir_vscode_last_version%" "%dir_bak_last%"

if %ERRORLEVEL% neq 0 set "up_info_err=error when rename [%dir_vscode_last_version%] %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err

ping 127.0.0.1 -n 3 >nul

REM rename unzip_dir to last_version
set /a up_i=%up_i%+1
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] rename [unzip_dir] to [%dir_vscode_last_version%]"
echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

ren "%dir_unzip%" "%dir_vscode_last_version%"

if %ERRORLEVEL% neq 0 set "up_info_err=error when rename [unzip_dir] to [%dir_vscode_last_version%] %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err

ping 127.0.0.1 -n 3 1>nul

REM move data to last_version
set /a up_i=%up_i%+1
if %up_i% gtr 9 set "up_i_pre="
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] move [%dir_bak_last%\data] to [%dir_vscode_last_version%]"

echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

move "%dir_bak_last%\data" "%dir_vscode_last_version%\"

if %ERRORLEVEL% neq 0 set "up_info_err=error  move [%dir_bak_last%\data] to to [%dir_vscode_last_version%] %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err

ping 127.0.0.1 -n 5 1>nul

REM del bak_dir_last_version
set /a up_i=%up_i%+1
if %up_i% gtr 9 set "up_i_pre="
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] if not exist [bak_last\data],del [%dir_bak_last%]"

echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

if exist "%dir_bak_last%\data\" (
  set "up_info_err=error check exist [%dir_bak_last%\data]"
) else (
  rd /s /q %dir_bak_last%
)

if %ERRORLEVEL% neq 0 set "up_info_err=error  move [%dir_bak_last%\data] to to [%dir_vscode_last_version%] %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err

REM last del_zip_file
if /i "%up_del_zip_after_sucess%" neq "yes" goto jump_over_del_zip

set /a up_i=%up_i%+1
if %up_i% gtr 9 set "up_i_pre="
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] delete [%_up_zip_file%]"

echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

del "%_up_zip_file%"

if %ERRORLEVEL% neq 0 set "up_info_err=error  del [zip_file],code: %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err


REM last_clean rename log_pid to log_ok

:jump_over_del_zip

set /a up_i=%up_i%+1
if %up_i% gtr 9 set "up_i_pre="
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] updata clean finish"
echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

set /a up_i=%up_i%+1
if %up_i% gtr 9 set "up_i_pre="
set "up_info_1=[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] updata sucess"
echo. "!up_info_1!">>"%up_log_pid%"
echo. "!up_info_1!">>con

ren "%up_log_pid%" "%up_log_ok%"

if %ERRORLEVEL% neq 0 set "up_info_err=error [rename log_pid to log_ok] %ERRORLEVEL%"
if "%up_info_err%" neq "" goto writr_err



REM echo. "%up_log_pid%"
REM echo. "%up_log_ck%"
REM echo. "%up_log_err%"
REM echo. "%up_log_dir%\%up_log_err%"
REM echo. "%up_log_ok%"
REM echo. "%up_log_dir%\%up_log_ok%"
REM echo. "%dir_unzip%"
REM echo. "%dir_bak_last%"


goto end_up_vscode



:writr_err

echo.
echo. "--- err"

if "%up_info_err%" == "" (
  set "up_info_1=find error,stop update task"
) else (
  set "up_info_1=%up_info_err%"
)

set /a up_i=%up_i%+1
if %up_i% gtr 9 set "up_i_pre="

echo. "[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] error: !up_info_1!"

if "%up_zip_file_name%" == "" goto exit_with_err

if exist "%up_log_pid%" ( 
  ren "%up_log_pid%" "%up_log_err%"
  echo. "[%up_i_pre%%up_i% %date_ymd%:!time:~6,2!] error: !up_info_1!">>"%up_log_dir%\%up_log_err%"
)

:exit_with_err
  echo.
  echo. "--- exit with err"
  set _up_exit_code=1

:end_up_vscode
  echo.
  echo. "--- End."
  echo.

popd

exit /b %_up_exit_code%

