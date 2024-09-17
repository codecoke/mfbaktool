@echo off

setlocal enabledelayedexpansion

set "_up_vscode_bat_name=up-vscode-to-last*.bat"

REM Do not modify the following if not necessary

if /i "%~1" == "" (
  echo. "--- err:"
  echo. "%%1 must test"
  goto :eof
)

pushd "%~dp0"

set "up_vscode2last_config="
for /f "usebackq tokens=*" %%Z in (`dir /a:-d /b "%_up_vscode_bat_name%"`) do (
  if "%up_vscode2last_config%" == "" (
    for /f "usebackq tokens=*" %%Y in (`"%%Z" config-name`) do ( set "up_vscode2last_config=%%~Y")
  )
)

set /a mf_mod_cmd_test_code=0
set "up_is_in_test_dir=no"

REM call "mf_var_of_file.1.bat" "%up_vscode2last_config%"
call "mf_var_of_file.1.bat" "%up_vscode2last_config%" "" "" 1

set "_up_errcode=%ERRORLEVEL%"

if %_up_errcode% neq 0 (
  echo. "--- err "
  echo. "--- read vals from file faild. code [%_up_errcode%] "
  if "%_up_errcode%" equ "404" (
    echo. "---  file not find:"
    echo. "[%up_vscode2last_config%]"
  )
  goto :eof
)

set "date_ymd=%date:~,4%-%date:~5,2%-%date:~8,2% %time:~,2%:%time:~3,2%"

echo.
echo. " --- start clean for update-vscode-test"
echo.

set "up_zip_search_name=%up_zip_search_name:~0,-4%"
set "_up_log_ck=%up_log_dir%\up_???_%up_zip_search_name%.txt"
set "_up_dir_unzip=%up_dir_unzip_pre%_%up_zip_search_name%"
set "dir_bak_last=%up_dir_bak_pre%_%dir_vscode_last_version%"

REM echo. "up_zip_search_name : %up_zip_search_name%"
REM echo. "up_dir_unzip_pre : %up_dir_unzip_pre%"
REM echo. "up_log_dir : %up_log_dir%"
REM echo. "_up_log_ck : %_up_log_ck%"
REM echo. "_up_dir_unzip : %_up_dir_unzip%"
REM echo. "up_is_in_test_dir : %up_is_in_test_dir%"


echo. "1--- check [%_up_log_ck%]"

if exist "%up_log_dir%\" (
  if "%~1" =="init" (
    echo. " --- del [%up_log_dir%] for test init"
    rd /s /q "%up_log_dir%\"
  )else (
    if exist "%_up_log_ck%" (
      echo. " --- del [%_up_log_ck%] for test"
      del "%_up_log_ck%"
    )
  )
)

echo. "2--- check %dir_vscode_last_version%user\data for test"
if not exist "%dir_vscode_last_version%\data\"  (
  echo. " --- creat [%dir_vscode_last_version%\data] for test now"
  mkdir "%dir_vscode_last_version%\data\" 
  echo. "up vscode test info">>"%dir_vscode_last_version%\data\up_vscode_test.txt"
  echo. "[%date_ymd%]">>"%dir_vscode_last_version%\data\up_vscode_test.txt"
)


echo. "3--- check [%dir_bak_last%]"
if exist "%dir_bak_last%" (
    echo. " --- find %dir_bak_last%"
  if not exist "%dir_bak_last%\data" (
    echo. " --- del %dir_bak_last%"
    rd /s /q "%dir_bak_last%"
  ) else (
    if exist "%dir_bak_last%\data\up_vscode_test.txt" (
      echo. " --- find \data\up_vscode_test.txt,del"
      rd /s /q "%dir_bak_last%"
    )else (
      if "%up_is_in_test_dir%" equ "yes" (
        echo. " --- up_is_in_test,del %dir_bak_last%"
        rd /s /q "%dir_bak_last%"
      )
    )
  )
)

echo. "4--- check unzip_dir lasttime if find"
REM echo "%_up_dir_unzip%"
if not exist "%_up_dir_unzip%" (
  echo. " --- not find unzip_dir-xxx"
  goto after_ck_unzip_dir
)

set "_up_dir_unzip_1="
for /d %%G in ("%_up_dir_unzip%") DO (
  set "_up_dir_unzip_1=%%~nxG"
  if exist "!_up_dir_unzip_1!\data\" (
    if exist "!_up_dir_unzip_1!\data\up_vscode_test.txt" (
      echo. "---- find data\up_vscode_test.txt ,del it"
      rd /s /q "!_up_dir_unzip_1!"
    ) else (
      if "%up_is_in_test_dir%" equ "yes" (
        echo. "---- has data but in_test,del it"
        rd /s /q "!_up_dir_unzip_1!"
      )
    )
  ) else (
    echo "---- not data ,del unzip_dir"
    rd /s /q "!_up_dir_unzip_1!"
  )
)
set "_up_dir_unzip_1="

:after_ck_unzip_dir
goto up_test_clean

tasklist /v /fi "IMAGENAME eq Code.exe" | find  /i "code" >nul && set "_up_vscode_is_runing=yes" || set "_up_vscode_is_runing=no"

echo. "---- _up_vscode_is_runing: %_up_vscode_is_runing%"

:up_test_clean

echo.
REM dir_vscode_last_version

if "%up_is_in_test_dir%" equ "yes" (
  echo. "run %~nx0 /%~1 at: %date:~,4%/%date:~5,2%/%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%">> "%dir_vscode_last_version%\data\up_vscode_test.txt"
)
REM echo. "%dir_vscode_last_version%\data\up_vscode_test.txt"
echo. "---- up_test_clean end"

popd

endlocal
