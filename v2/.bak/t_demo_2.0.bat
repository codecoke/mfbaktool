@echo off
setlocal enabledelayedexpansion

REM mfbaktool caller
REM version 2.0.1
REM w@ibar.cn 2024-09-01 16:25:05

REM mbt_2---job---jobname---G##check target dir#.bat

REM ---- user setting ----
REM set "mbt_tool_dir="
set "mbt_tool_dir=G:\localSites_g\shell\mfbaktool_dev\v2"
REM File directory where run_job_2.bat is stored

set "mbt_run_confirm="
REM null: default,this bat run confirm not need confirm
REM Y: %agr_1% must not null ,can be any string
REM some_string: %agr_1% must ==  [%mbt_run_confirm%]

REM set "log_file=x:\test_1\"
set "log_file="
REM The directory where your backup logs are stored:
REM set "log_file=G:\test_1\t_demo.log"
REM set "log_file=C:\some path\your bak dir\any your bakname.log.txt"

REM add write to log_info
set "mbt_log_note=_test.2.1"

set /a mbt_log_lines_max=15
set /a mbt_sucess_sleep=0


REM --- ---  don't modification if not necessary --- ---
REM The following vars does not require editing
REM if u don't know what's meaning
set "_mbt_path_chr=#"
set "_mbt_path_sp=---"

set "mbt_script_version=2.0.1"
set /a mbt_debug_level=0
REM 0 : default 0
REM 1 : show debug info

REM 4:  mbt_this_bat exec stop
REM 3:  mbt_run_job_bat exec stop
REM 2:  mbt_write_log_bat exec stop

set /a mbt_debug_echo=0
set /a _mbt_debug_level_stop=4

set "mbt_ac_type_list=info,cmd,job,queue,list,folder,file-list"


set "_mbt_this_dir=%~dp0"
set "_mbt_this_bat_name="
set "_mbt_err="
set "_is_str_cludes="

set "_mbt_this_bat_pre=mbt"
REM set "_mbt_this_bat_pre="
set /a _mbt_this_bat_pre_len=0

REM --- --- for test
REM set "_mbt_this_bat_name=mbt_2---job---test-notfind---G##test_1#"
REM set "_mbt_this_bat_name=mbt_2---job---test-notfind"
REM set "_mbt_this_bat_name=mbt_2---job---copy t-demo-2---G##test_1"
REM set "_mbt_this_bat_name=job---delete test b1---G##test_1"
set "_mbt_this_bat_name=mbt_2---job---delete test b1---G##test_1"

REM vars init
set "_mbt_ac_type="
set "_mbt_ac_name="
set "_mbt_ac_dir="
set "_mbt_run_bat="


REM check input arguments 1
set "_arg_1=%~1"

REM check this bat run confirm
if "%mbt_run_confirm%" NEQ "" (
  if "%_arg_1%" == "" (
    set "_mbt_err=arg_1 must be %mbt_run_confirm%"
    if /i "%mbt_run_confirm%" =="y" set "_mbt_err=arg_1 must input"
    goto write_err
  )
  if /i "%mbt_run_confirm%" NEQ "y" (
    if /i "%mbt_run_confirm%" NEQ "%_arg_1%" (
      set "_mbt_err=arg_1 must be %mbt_run_confirm%"
      goto write_err
    )
  )
)

if "%_arg_1%" == "" (
  set /a mbt_debug_level=0
  goto check_log_file
) else if /i "%_arg_1%" == "err" (
  set "_mbt_err=%~2"
  if "!_mbt_err!" == "" set "_mbt_err=unknow_err,arg_2 is null!"
  goto write_err
) else (
  call:is_str_cludes ",0,1,2,3,4,5," ",%_arg_1%,"
  if "!_is_str_cludes!" NEQ  "" set /a mbt_debug_level=%_arg_1% & goto check_log_file
)

REM check custom log file
:check_log_file
if "%log_file%" == "" (
  set "log_file=%~dpn0.log"
  goto check_this_bat_name
)
if "%log_file:~-1%" == "\" set "log_file=%log_file%%~n0.log"
if "%log_file:~0,1%" == "\" set "log_file=%_mbt_this_dir%%log_file:~1%"
set "log_file_right4_=%log_file:~-4%"
if "%log_file_right4_%" NEQ ".txt" (
  if "%log_file_right4_%" NEQ ".log" (
    set "log_file=%log_file%.txt"
  )
)
if "%log_file:~1,2%" NEQ ":\" set "log_file=%_mbt_this_dir%%log_file%"


:check_this_bat_name

if "%_mbt_this_bat_name%" == "" set "_mbt_this_bat_name=%~n0"

if "%_mbt_this_bat_pre%" == "" (
  set "mbt_version_major=%mbt_script_version:~0,1%"
  goto check_bat_right
)

call:get_str_len "%_mbt_this_bat_pre%"
set /a _mbt_this_bat_pre_len=%val_get_str_len%+1

REM check file_name_left
if /i "!_mbt_this_bat_name:~0,%_mbt_this_bat_pre_len%!" neq "%_mbt_this_bat_pre%_"  set "_mbt_err=the_bat_name_per_err [!_mbt_this_bat_name:~0,%_mbt_this_bat_pre_len%!] NEQ [%_mbt_this_bat_pre%]" & goto write_err

REM check file version
call:is_str_cludes ",1,2,3,4,5," ",!_mbt_this_bat_name:~%_mbt_this_bat_pre_len%,1!,"
if "!_is_str_cludes!" NEQ  "" set "mbt_version_major=!_mbt_this_bat_name:~%_mbt_this_bat_pre_len%,1!"


call:is_str_cludes ",1,2,3,4,5," ",%mbt_version_major%,"
if "!_is_str_cludes!" ==  "" set "mbt_version_major=%mbt_script_version:~0,1%"


set /a _mbt_this_bat_pre_len=%_mbt_this_bat_pre_len%+1

:check_bat_right

set "sp_cut_left__=%_mbt_path_sp:~0,1%"

call:get_str_len "%_mbt_path_sp%"
set /a sp_len__=%val_get_str_len%

REM echo "_mbt_this_bat_pre_len %_mbt_this_bat_pre_len%"

set "bat_right__=!_mbt_this_bat_name:~%_mbt_this_bat_pre_len%!"

if "%bat_right__%" EQU "" set "_mbt_err=file_name_err[!_mbt_this_bat_name!]" & goto write_err

call:cut_left_chr "%bat_right__%" "%sp_cut_left__%" "bat_right__"

REM set /a cut_i_=-1

call:index_of "%bat_right__%" "%_mbt_path_sp%"
if %val_index_of% LSS 0 set "_mbt_err=file_name must metch[%_mbt_this_bat_pre%_%mbt_version_major%%_mbt_path_sp%ac_type%_mbt_path_sp%ac_name.bat]"

if "%_mbt_err%" NEQ "" goto write_err


set "_mbt_ac_type=!bat_right__:~0,%val_index_of%!"

REM check ac_type
call:is_str_cludes ",%mbt_ac_type_list%," ",%_mbt_ac_type%,"

if "!_is_str_cludes!" ==  "" set "_mbt_err=[%_mbt_ac_type%] not in [%mbt_ac_type_list%]"

if "%_mbt_err%" NEQ "" goto write_err


REM check bat_name_right_string
set /a val_index_of=%val_index_of%+%sp_len__%
set "_mbt_ac_name=!bat_right__:~%val_index_of%!"
call:cut_left_chr "%_mbt_ac_name%" "%sp_cut_left__%" "_mbt_ac_name"


REM echo "mfbak_ac_name0  %_mbt_ac_name%"
set /a val_index_of=-1

call:index_of "%_mbt_ac_name%" "%_mbt_path_sp%"

if %val_index_of% GTR -1  (

  set "bat_right__=!_mbt_ac_name:~%val_index_of%!"
  set "_mbt_ac_dir=!bat_right__:~%sp_len__%!"
  set "_mbt_ac_name=!_mbt_ac_name:~0,%val_index_of%!"

)


call:cut_left_chr "%_mbt_ac_dir%" "%sp_cut_left__%" "_mbt_ac_dir"

REM if [_mbt_ac_dir] in this_bat_name , check job target_dir
if /i "%_mbt_ac_type%" == "job" (

  if "%_mbt_ac_dir%" NEQ ""  (

    if /i "!_mbt_ac_dir:~1,2!" EQU "%_mbt_path_chr%%_mbt_path_chr%" set "_mbt_ac_dir=!_mbt_ac_dir:~0,1!:\!_mbt_ac_dir:~3!"

    set "_mbt_ac_dir=!_mbt_ac_dir:%_mbt_path_chr%=\!"

    if "!_mbt_ac_dir:~1,2!" NEQ ":\" (

      if "!_mbt_ac_dir:~0,2!" NEQ "\\" set "_mbt_ac_dir=%_mbt_this_dir%!_mbt_ac_dir!"

    )

    if not exist "!_mbt_ac_dir!" set "_mbt_err=ac_dir [!_mbt_ac_dir!] not find"

  )
)

if "%_mbt_err%" NEQ "" goto write_err


REM check mbt_tool_dir

if "%mbt_tool_dir%" EQU "" set "mbt_tool_dir=%_mbt_this_dir%"
if "%mbt_tool_dir:~1,2%" NEQ ":\" set "mbt_tool_dir=%_mbt_this_dir%%mbt_tool_dir%"
if "%mbt_tool_dir:~-1%" NEQ "\"  set "mbt_tool_dir=%mbt_tool_dir%\"

REM check mbt_tool_dir\job_2.bat exist

set "_mbt_run_bat=%mbt_tool_dir%run_%_mbt_ac_type%_%mbt_version_major%.bat"



if not exist "%_mbt_run_bat%" set "_mbt_err=%_mbt_run_bat% %%_mbt_run_bat%% not_fined"

if "%_mbt_err%" NEQ "" goto write_err



if "%mbt_debug_level%" == "" set /a mbt_debug_level=0


if %mbt_debug_level% GTR 0 (
  set /a mbt_debug_echo=%mbt_debug_echo% + 1
  echo.
  echo. "--- --- mfbooktool !mbt_debug_echo! [caller %_mbt_this_bat_pre%]--- ---"
  echo.
  echo. "mbt_debug_level: %mbt_debug_level%"
  echo. "mbt_version_major: %mbt_version_major%"
  echo. "log_file: %log_file%"
  echo. "exec_action: %_mbt_ac_type% / %_mbt_ac_name%"
  echo. "_mbt_ac_type: %_mbt_ac_type%"
  echo. "_mbt_ac_name: %_mbt_ac_name%"
  echo. "_mbt_debug_level_stop: %_mbt_debug_level_stop%"
  echo. "_mbt_this_bat_name: %_mbt_this_bat_name%"
  echo. "_mbt_run_bat: %_mbt_run_bat%"
  echo. "_mbt_this_dir: %_mbt_this_dir%"
  echo. "_mbt_ac_dir:  %_mbt_ac_dir%"
  echo. "_mbt_this_bat_pre_len: %_mbt_this_bat_pre_len%"

  if %mbt_debug_level% GEQ %_mbt_debug_level_stop% goto :EOF

)

REM run_job_2.bat "f2" "mbt_2_job_f2.bat" "g:\test 1\log.txt"
REM run_job_2.bat "[_mbt_ac_name]" "d:\a\_this_bat_name.bat" "g:\test 1\log.txt"

"%_mbt_run_bat%" "%_mbt_ac_name%" "%~dpnx0" "%log_file%"

goto :EOF

:write_err

  set "mfbak_ymd=%date:~,4%-%date:~5,2%-%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"

  echo.
  echo. "--- error ---"
  echo.
  echo. "%_mbt_err%" 
  echo. "%mfbak_ymd% ; %computername%"
  if  "%log_file%" == "" goto :EOF
  echo. err: "%_mbt_err%" ; %mfbak_ymd% ; %computername% >> "%log_file%"

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

  set "_is_str_cludes="

  if "%~1" == ""  goto :EOF
  if "%~2" == ""  goto :EOF

  set is_cludes_str__=%~1
  set "is_cludes_dif__=!is_cludes_str__:%~2=&rem.!"

  set is_cludes_dif__=#%is_cludes_dif__%

  if "%is_cludes_dif__%" EQU "#%~1" goto :EOF

  set _is_str_cludes=yes
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