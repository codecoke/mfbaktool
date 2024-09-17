@echo off
setlocal enabledelayedexpansion

REM mfbaktool caller
REM version 2.0.1
REM w@ibar.cn 2024-08-26 17:13:56

REM mbt_2---job---jobname---G##check target dir#.bat



REM ---- user setting ----

REM set "mbt_tool_dir="
REM set "mbt_tool_dir=G:\localSites_g\shell\mfbaktool_dev\v2"
REM File directory where job_2.bat is stored


REM The directory where your backup logs are stored:
REM set "log_file=test_log\"
REM set "log_file=D:\some path\your log dir\any-your-bakname.log"


REM set "mbt_caller_file_name="

REM for test
REM set "mbt_caller_file_name=mbt_2---job---test v 1---G##test_1#"
REM set "mbt_caller_file_name=mbt_2---job---test-notfind---G##test_1#"
REM set "mbt_caller_file_name=mbt_2---job---test-notfind"
REM set "mbt_caller_file_name=mbt_2---job---test-b1"
REM set "mbt_caller_file_name=mbt_2---job---del test b1---G##test_1"

REM --- --- need no modification ---

set "mbt_script_version=2.0.0"
set "mbt_name=mbt"
set "mbt_path_sp=---"
set "mbt_path_chr=#"

REM 0     : default 0
REM 1     : show info
REM gtr 1 : fastcopy.exe not execute
set /a mbt_debug_level=0

set "mbt_script_dir=%~dp0"

REM set "mbt_version_major=%mbt_version:~0,1%"
REM set "mbt_version_major=%mbt_script_version:~0,1%"
set "sp_cut_left__=%mbt_path_sp:~0,1%"

call:get_str_len "%mbt_name%"
set /a mbt_name_len=%val_get_str_len%+1

call:get_str_len "%mbt_path_sp%"
set /a sp_len__=%val_get_str_len%


set "mbt_ac_type_list=info,cmd,job,queue,list,folder,file-list"
set "mbt_ac_type="
set "mbt_ac_name="
set "mbt_ac_dir="
set "mbt_bat="


set "mbt_err="
set "arg_1=%~1"
set "arg_2=%~2"

REM user custom log file
if "%log_file%" == "" (
  set "log_file=%~dpn0.log"
  goto check_arg_1
)

if "%log_file:~-1%" == "\" set "log_file=%log_file%%~n0.log"

if "%log_file:~0,1%" == "\" set "log_file=%mbt_script_dir%%log_file:~1%"


REM echo "----------- ck arg 1 -----"

set "log_file_right4_=%log_file:~-4%"

if "%log_file_right4_%" NEQ ".txt" (
  if "%log_file_right4_%" NEQ ".log" (
    set "log_file=%log_file%.txt"
  )
)

if "%log_file:~1,2%" NEQ ":\" set "log_file=%mbt_script_dir%%log_file%"

:check_arg_1

REM ck arg_1 == err
if /i "%arg_1%" == "err" (
  set "mbt_err=%arg_2%"
  if "%arg_2%" == "" set "mbt_err=unknow_err"
)
if "%mbt_err%" NEQ "" goto write_err


if "%mbt_caller_file_name%" == "" set "mbt_caller_file_name=%~n0"
REM check file_name_left
if /i "!mbt_caller_file_name:~0,%mbt_name_len%!" neq "%mbt_name%_"  set "mbt_err=file_name_left_err [!mbt_caller_file_name:~0,%mbt_name_len%!] NEQ [%mbt_name%]" & goto write_err



REM check file version
call:is_str_cludes ",1,2,3,4,5," ",!mbt_caller_file_name:~%mbt_name_len%,1!,"
if "!val_is_str_cludes!" NEQ  "" set "mbt_version_major=!mbt_caller_file_name:~%mbt_name_len%,1!"


call:is_str_cludes ",1,2,3,4,5," ",%mbt_version_major%,"
if "!val_is_str_cludes!" ==  "" set "mbt_version_major=%mbt_script_version:~0,1%"

set /a mbt_name_len=%mbt_name_len%+1

REM echo "mbt_name_len %mbt_name_len%"

set "bat_right__=!mbt_caller_file_name:~%mbt_name_len%!"

if "%bat_right__%" EQU "" set "mbt_err=file_name_err[!mbt_caller_file_name!]" & goto write_err

call:cut_left_chr "%bat_right__%" "%sp_cut_left__%" "bat_right__"

set /a cut_i_=-1

call:index_of "%bat_right__%" "%mbt_path_sp%"
if %val_index_of% LSS 0 set "mbt_err=file_name must metch[%mbt_name%_%mbt_version_major%%mbt_path_sp%ac_type%mbt_path_sp%ac_name.bat]"

if "%mbt_err%" NEQ "" goto write_err


set "mbt_ac_type=!bat_right__:~0,%val_index_of%!"

REM check ac_type
call:is_str_cludes ",%mbt_ac_type_list%," ",%mbt_ac_type%,"

if "!val_is_str_cludes!" ==  "" set "mbt_err=[%mbt_ac_type%] not in [%mbt_ac_type_list%]"

if "%mbt_err%" NEQ "" goto write_err


REM check bat_name_right_string
set /a val_index_of=%val_index_of%+%sp_len__%
set "mbt_ac_name=!bat_right__:~%val_index_of%!"
call:cut_left_chr "%mbt_ac_name%" "%sp_cut_left__%" "mbt_ac_name"


REM echo "mfbak_ac_name0  %mbt_ac_name%"
set /a val_index_of=-1

call:index_of "%mbt_ac_name%" "%mbt_path_sp%"

if %val_index_of% GTR -1  (

  set "bat_right__=!mbt_ac_name:~%val_index_of%!"
  set "mbt_ac_dir=!bat_right__:~%sp_len__%!"
  set "mbt_ac_name=!mbt_ac_name:~0,%val_index_of%!"

)


call:cut_left_chr "%mbt_ac_dir%" "%sp_cut_left__%" "mbt_ac_dir"

REM check job target_dir
if /i "%mbt_ac_type%" == "job" (

  if "%mbt_ac_dir%" NEQ ""  (

    if /i "!mbt_ac_dir:~1,2!" EQU "%mbt_path_chr%%mbt_path_chr%" set "mbt_ac_dir=!mbt_ac_dir:~0,1!:\!mbt_ac_dir:~3!"

    set "mbt_ac_dir=!mbt_ac_dir:%mbt_path_chr%=\!"

    if "!mbt_ac_dir:~1,2!" NEQ ":\" (

      if "!mbt_ac_dir:~0,2!" NEQ "\\" set "mbt_ac_dir=%mbt_script_dir%!mbt_ac_dir!"

    )

    if not exist "!mbt_ac_dir!" set "mbt_err=ac_dir [!mbt_ac_dir!] not find"

  )
)

if "%mbt_err%" NEQ "" goto write_err


REM check mbt_tool_dir

if "%mbt_tool_dir%" EQU "" set "mbt_tool_dir=%mbt_script_dir%"
if "%mbt_tool_dir:~1,2%" NEQ ":\" set "mbt_tool_dir=%mbt_script_dir%%mbt_tool_dir%"
if "%mbt_tool_dir:~-1%" NEQ "\"  set "mbt_tool_dir=%mbt_tool_dir%\"

REM check mbt_tool_dir\job_2.bat exist

set "mbt_bat=%mbt_tool_dir%%mbt_ac_type%_%mbt_version_major%.bat"

if not exist "%mbt_bat%" set "mbt_err=%mbt_bat% %%mbt_bat%% not_fined"

if "%mbt_err%" NEQ "" goto write_err


if %mbt_debug_level% GTR 0 (
  echo.
  echo. "--- --- %mbt_ac_type% : %mbt_ac_name%  --- ---"
  echo.
  echo. "mbt_debug_level: %mbt_debug_level%"
  echo. "mbt_bat: %mbt_bat%"
  echo. "mbt_script_dir: %mbt_script_dir%"
  echo. "mbt_ac_type: %mbt_ac_type%"
  echo. "mbt_ac_name: %mbt_ac_name%"
  echo. "mbt_ac_dir:  %mbt_ac_dir%"
  echo. "mbt_version:  %mbt_version%"
  echo. "mbt_version_major: %mbt_version_major%"
  echo. "mbt_caller_file_name: %mbt_caller_file_name%"
  echo. "mbt_name_len: %mbt_name_len%"
  echo. "log_file: %log_file%"

  if %mbt_debug_level% GTR 1 goto :EOF

)

REM job_2.bat "f2" "mbt_2_job_f2.bat" "g:\test 1\log.txt"
"%mbt_bat%" "%mbt_ac_name%" "%~dpnx0" "%log_file%"

goto :EOF

:write_err

  set "mfbak_ymd=%date:~,4%-%date:~5,2%-%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"

  echo.
  echo. "--- error ---"
  echo.
  echo. "%mbt_err%" 
  echo. "%mfbak_ymd% ; %computername%"

  echo. err: "%mbt_err%" ; %mfbak_ymd% ; %computername% >> "%log_file%"

goto :EOF


REM ---- ---- label funtion ---- ----

goto :EOF
:cut_left_chr [1.cut_left_str__ 2.cut_left_chr__ 3.result_var]
  set val_cut_left_chr=

  if "%~1" == ""  goto :EOF
  if "%~2" == ""  goto :EOF
  set cut_left_str__=%~1
  if "%cut_left_str__:~0,1%" NEQ "%~2" goto :EOF

  set cut_left_chr__=%~2

  call:get_str_len "%cut_left_str__%"
  set /a cut_left_len_=%val_get_str_len%
  set /a cut_left_i__=0

  for /l %%j in ( 0,1,%cut_left_len_% ) do (
    if "!cut_left_str__:~%%j,1!" NEQ "%cut_left_chr__%" (
      if !cut_left_i__! lss 1 (
        set /a cut_left_i__=%%j
      )
    )
  )
  set val_cut_left_chr=!cut_left_str__:~%cut_left_i__%!
  if "%~3" neq "" set %~3=%val_cut_left_chr%

goto :EOF


:is_str_cludes

  set "val_is_str_cludes="

  if "%~1" == ""  goto :EOF
  if "%~2" == ""  goto :EOF

  set is_cludes_str__=%~1
  set "is_cludes_dif__=!is_cludes_str__:%~2=&rem.!"

  set is_cludes_dif__=#%is_cludes_dif__%

  if "%is_cludes_dif__%" EQU "#%~1" goto :EOF

  set val_is_str_cludes=yes
  set "is_cludes_str__="
  set "is_cludes_dif__="

goto :EOF

:get_str_len

  set str_len_str__=%~1
  set /a val_get_str_len=0
  if "%str_len_str__%"=="" goto :EOF

:get_str_len_substr
  set str_len_n_=%str_len_str__:~0,1%
  if "%str_len_n_%"=="" (
          goto :EOF
  ) else if "%str_len_n_%"==" " (
          set /a val_get_str_len=%val_get_str_len%+1
  ) else (
          set /a val_get_str_len=%val_get_str_len%+1
  )
  set str_len_str__=%str_len_str__:~1,600%
  if "%str_len_str__%"=="" (
          goto :EOF
  ) else (
          goto get_str_len_substr
  )
goto :EOF

:index_of

set /a val_index_of=-1
set "index_str_=%~1"
set "index_of_chr_=!index_str_:%~2=&rem.!"
set index_of_chr_=#%index_of_chr_%

if "%index_of_chr_%" EQU "#%~1" goto :EOF

set "indexof_i_=0"
REM for %%A in (2187 729 243 81 27 9 3 1) do (
for %%A in (729 243 81 27 9 3 1) do (
  set /A mod=2*%%A
  for %%Z in (!mod!) do (
    if "!index_of_chr_:~%%Z,1!" neq "" (
      set /a "indexof_i_+=%%Z"
      set "index_of_chr_=!index_of_chr_:~%%Z!"
    ) else (
      if "!index_of_chr_:~%%A,1!" neq "" (
        set /a "indexof_i_+=%%A"
        set "index_of_chr_=!index_of_chr_:~%%A!"
      )
    )
  )
)
set /a val_index_of=%indexof_i_%

goto :EOF