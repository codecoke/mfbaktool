@echo off
setlocal enabledelayedexpansion

REM mfbaktool caller
REM version 2.0.1
REM w(a)ibar.cn 2024-09-21 16:28:59

REM mbt_2---job---jobname---G##check target dir#.bat

REM ---- user setting ----
REM set "mbt_tool_dir="
set "mbt_tool_dir=G:\localSites_g\shell\mfbaktool_dev\v2"
REM File directory where run_job_2.bat is stored

REM set "mbt_fastcopy_dir="
REM set "mbt_fastcopy_dir=fastcopy\3.9.2 caller\"

set "mbt_log_file="
REM The directory where your backup logs are stored:
REM set "mbt_log_file=G:\test_1\t_job_2_string.log"
REM set "mbt_log_file=C:\some path\your bak dir\any your bakname.log.txt"

REM Maximum number of records in mbt_log_file
set /a mbt_log_lines_max__i=12

REM Wait time in seconds after successful execute
set /a mbt_sucess_sleep__i=0

set "mbt_run_confirm="
REM null: default,this bat run not need confirm
REM Y: %agr_1% must not null ,can be any string
REM confirm_str: %agr_1% must ==  [%mbt_run_confirm%]

REM add write to log_info
set "mbt_log_note=t_job.2.2"




REM --- ---  don't modification if not necessary --- ---

REM The following vars does not require editing
REM if u don't know what's meaning

REM just 1 chr
set "_mbt_path_chr=#"

REM split_chr
set "_mbt_path_sp=---"

set "mbt_script_version=2.2.1"
REM 0 : default 0
REM 1 : show debug info

REM 4:  mbt_this_bat exec stop
REM 3:  mbt_run_job_bat exec stop
REM 2:  mbt_write_log_bat exec stop

REM set /a mbt_debug_echo=0
set /a _mbt_debug_level_stop=4

set "_mbt_err="
set "_is_str_cludes="

set "mbt_allow_ac_type=info,cmd,job,queue,list,folder,file-list"
REM set "mbt_ac_type_list=info,cmd,job,queue,list,folder,file-list"


set "_mbt_this_dir=%~dp0"
set "_mbt_this_n0=%~n0"
set "_mbt_this_bat="

set "_mbt_this_pre="
set "_mbt_this_pre=mbt"
REM set "mbt_mf_vars_of_bat=G:\test_1\mf_var_of_file.1.bat"
set "mbt_mf_vars_of_bat=mf_var_of_file.2.2.bat"
REM G:\localSites_g\shell\mfbaktool_dev\v2\mf_var_of_file.1.bat


set /a _mbt_this_pre_len=0

REM --- --- for test
REM set "_mbt_this_bat=mbt_2---job---test-notfind---G##test_1#"
REM set "_mbt_this_bat=mbt_2---job---copy t-demo-2---G##test_1"
set "_mbt_this_bat=job---delete test b1---G##test_1"
set "_mbt_this_bat=mbt_2.2---job"
set "_mbt_this_bat=job---test-notfind"
set "_mbt_this_bat=mbt_2.2---job---delete test b1---G##test_1"
set "_mbt_this_bat=mbt_2.2---info---delete test b1---test 2#f1#fastcopy392#"
set "_mbt_this_bat=mbt_2.2---job---test-notfind"
set "_mbt_this_bat=mbt_2.2---job---delete test b1---G##test_1"
REM set /a mbt_debug_level__i=0


REM vars init
set "_mbt_ac_type="
set "_mbt_ac_name="
set "_mbt_ac_dir="
set "_mbt_run_bat="
set "_mbt_version_def=2"


REM get mbt_version from _mbt_this_bat

set "_arg_1=%~1"

if /i "%_arg_1%" == "err" (
  set "_mbt_err=%~2"
  if "!_mbt_err!" == "" set "_mbt_err=unknow_err,arg_2 is null!"
  goto write_err
)
call:is_str_cludes ",0,1,2,3,4,5," ",%_arg_1%,"
if "!_is_str_cludes!" NEQ  "" set /a mbt_debug_level__i=%_arg_1%



if "%_mbt_this_bat%" == "" set "_mbt_this_bat=%_mbt_this_n0%"

REM check  bat_name pre_version
call:get_str_len "%_mbt_this_pre%"
set /a _mbt_this_pre_len=%val_get_str_len%+1

if %_mbt_this_pre_len% LEQ 1 (
   set "mbt_version=%_mbt_version_def:~0,1%"
   set "bat_right__=%_mbt_this_bat%"
   goto skip_get_mbt_version
)
REM _mbt_this_pre not null
if /i "!_mbt_this_bat:~0,%_mbt_this_pre_len%!" neq "%_mbt_this_pre%_"  set "_mbt_err=the_bat_name_per [!_mbt_this_bat:~0,%_mbt_this_pre_len%!] NEQ [%_mbt_this_pre%_]" & goto write_err
set /a _mbt_pre_len_2=%_mbt_this_pre_len%+1
REM if mbt_version = 2.x mbt_2.1_job---xxx.bat
if "!_mbt_this_bat:~%_mbt_pre_len_2%,1!"=="." (
  set "mbt_version=!_mbt_this_bat:~%_mbt_this_pre_len%,3!"
  set /a _mbt_this_pre_len=%_mbt_this_pre_len%+3
) else (
  set "mbt_version=!_mbt_this_bat:~%_mbt_this_pre_len%,1!"
  set /a _mbt_this_pre_len=%_mbt_this_pre_len%+1
)
set "bat_right__=!_mbt_this_bat:~%_mbt_this_pre_len%!"
:skip_get_mbt_version

REM _check_mbt_version_main
set "sp_cut_left__=%_mbt_path_sp:~0,1%"
set mbt_version_main=%mbt_version:~0,1%

call:is_str_cludes ",1,2,3,4,5," ",%mbt_version_main%,"
if "!_is_str_cludes!" ==  "" set "_mbt_err=mbt_version[%mbt_version%] is error" & goto write_err

if "%bat_right__:~0,1%" == "%sp_cut_left__%" call:cut_left_chr "%bat_right__%" "%sp_cut_left__%" "bat_right__"

REM echo. "mbt_version:%mbt_version%"
REM echo. "mbt_version_main:%mbt_version_main%"
REM echo. "bat_right__:%bat_right__%"
REM echo. "sp_cut_left__:%sp_cut_left__%"


REM check mbt_tool_dir

if "%mbt_tool_dir%" == "" set "mbt_tool_dir=%_mbt_this_dir%"
if "%mbt_tool_dir:~1,2%" NEQ ":\" set "mbt_tool_dir=%_mbt_this_dir%%mbt_tool_dir%"
if "%mbt_tool_dir:~-1%" NEQ "\"  set "mbt_tool_dir=%mbt_tool_dir%\"

if "%mbt_mf_vars_of_bat:~1,2%" NEQ ":\" set "mbt_mf_vars_of_bat=%mbt_tool_dir%%mbt_mf_vars_of_bat%"
if not exist "%mbt_mf_vars_of_bat%" set "_mbt_err=mf_vars_of_bat not find, ck [mbt_tool_dir] seeting" & goto write_err

REM echo. "mbt_tool_dir:%mbt_tool_dir%"
REM echo. "mbt_mf_vars_of_bat:%mbt_mf_vars_of_bat%"

REM get ac_type
call:index_of "%bat_right__%" "%_mbt_path_sp%"
if %val_index_of% LSS 1 set "_mbt_err=file_name must metch[%_mbt_this_pre%_%mbt_version%%_mbt_path_sp%ac_type%_mbt_path_sp%ac_name.bat, ac_type fild]" & goto write_err

set "_mbt_ac_type=!bat_right__:~0,%val_index_of%!"
REM check ac_type
call:is_str_cludes ",%mbt_allow_ac_type%," ",%_mbt_ac_type%,"
if "!_is_str_cludes!" ==  "" set "_mbt_err=[%_mbt_ac_type%] not in [%mbt_allow_ac_type%]" & goto write_err

REM ac_name---g##test#
set /a val_index_of=%val_index_of%+1
set "bat_right__=!bat_right__:~%val_index_of%!"
if "%bat_right__:~0,1%" == "%sp_cut_left__%" call:cut_left_chr "%bat_right__%" "%sp_cut_left__%" "bat_right__"

if "%bat_right__%" =="" set "_mbt_err=file_name must metch [ac_type]%_mbt_path_sp%[ac_name] , ac_name fild" & goto write_err

REM echo. "after ac_type bat_right__:%bat_right__%"

REM :get_ac_name
REM get ac_name from bat_right__
call:index_of "%bat_right__%" "!_mbt_path_sp!"
if %val_index_of% LSS 0 (
  set "_mbt_ac_name=%bat_right__%"
  set "_mbt_ac_dir="
  goto skip_get_ac_dir
)
set "_mbt_ac_name=!bat_right__:~0,%val_index_of%!"
set /a val_index_of=%val_index_of%+1
set "_mbt_ac_dir=!bat_right__:~%val_index_of%!"
if "!_mbt_ac_dir:~0,1!" == "%sp_cut_left__%" call:cut_left_chr "%_mbt_ac_dir%" "%sp_cut_left__%" "_mbt_ac_dir"
:skip_get_ac_dir

REM echo.
REM echo. "_mbt_ac_name:%_mbt_ac_name%"
REM echo. "_mbt_ac_dir:%_mbt_ac_dir%"

set "_ck_ac_dir_ify="
if "%_mbt_ac_dir%" == "" goto skip_check_ac_dir
if /i "!_mbt_ac_dir:~1,2!" == "%_mbt_path_chr%%_mbt_path_chr%" set "_mbt_ac_dir=!_mbt_ac_dir:~0,1!:\!_mbt_ac_dir:~3!"
set "_mbt_ac_dir=!_mbt_ac_dir:%_mbt_path_chr%=\!"
if "!_mbt_ac_dir:~1,2!" NEQ ":\" (
  if "!_mbt_ac_dir:~0,2!" NEQ "\\" set "_mbt_ac_dir=%_mbt_this_dir%!_mbt_ac_dir!"
)
REM if not exist "%_mbt_ac_dir%" set "_mbt_err=_mbt_ac_dir [%_mbt_ac_dir%] not find" & goto write_err
set "_ck_ac_dir_ify=find"
if not exist "%_mbt_ac_dir%" set "_ck_ac_dir_ify=not_find"
:skip_check_ac_dir


REM echo.
REM echo. "_mbt_ac_name:%_mbt_ac_name%"
REM echo. "_mbt_ac_dir:%_mbt_ac_dir%"
REM echo.

if /i "%_mbt_ac_type%" == "job" (
  if "%_ck_ac_dir_ify%" == "not_find" set "_mbt_err=_mbt_ac_dir[%_mbt_ac_dir%] not_find" & goto write_err
)


REM load config by mbt_mf_vars_of_bat
set "_mbt_cof_file="
set "_mbt_cof_pre_=config.mbt_"
REM echo.
REM echo. "%_mbt_this_dir%%_mbt_this_bat%.ini"
REM REM echo. "%mbt_tool_dir%%_mbt_this_bat%.ini"
REM echo. "%_mbt_this_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version%.ini"
REM echo. "%mbt_tool_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version%.ini"
REM echo. "%_mbt_this_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version_main%.ini"
REM echo. "%_mbt_this_dir%%_mbt_this_n0%.ini"
REM echo.

if "%_mbt_cof_file%" NEQ "" goto skip_get_mbt_cof_file
  REM _mbt_this_dir\mbt.2.1_job_test 1.ini
if exist "%_mbt_this_dir%%_mbt_this_bat%.ini" (
  set "_mbt_cof_file=%_mbt_this_dir%%_mbt_this_bat%.ini"
  REM mbt_tool_dir\mbt.2.1_job_test 1.ini
) else if exist "%mbt_tool_dir%%_mbt_this_bat%.ini" (
  set "_mbt_cof_file=%mbt_tool_dir%%_mbt_this_bat%.ini"
  REM _mbt_this_dir\config.mbt_job_2.1.ini
) else if exist "%_mbt_this_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version%.ini" (
  set "_mbt_cof_file=%_mbt_this_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version%.ini"
  REM _mbt_this_dir\config.mbt_job_2.ini mbt_version_main
) else if exist "%_mbt_this_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version_main%.ini" (
  set "_mbt_cof_file=%_mbt_this_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version_main%.ini"
  REM mbt_tool_dir\config.mbt_job_2.1.ini
) else if exist "%mbt_tool_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version%.ini" (
  set "_mbt_cof_file=%mbt_tool_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version%.ini"
  REM mbt_tool_dir\config.mbt_job_2.ini mbt_version_main
) else if exist "%mbt_tool_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version_main%.ini" (
  set "_mbt_cof_file=%mbt_tool_dir%%_mbt_cof_pre_%%_mbt_ac_type%_%mbt_version_main%.ini"
  REM _mbt_this_dir\t_job.2.1.ini mbt_version_main
) else if exist "%_mbt_this_dir%%_mbt_this_n0%.ini" (
  set "_mbt_cof_file=%_mbt_this_dir%%_mbt_this_n0%.ini"
  REM mbt_tool_dir\t_job.2.1.ini mbt_version_main
) else if exist "%mbt_tool_dir%%_mbt_this_n0%.ini" (
  set "_mbt_cof_file=%mbt_tool_dir%%_mbt_this_n0%.ini"
)
:skip_get_mbt_cof_file


if not exist "%_mbt_cof_file%" set "_mbt_err=_mbt_cof_file not find" & goto write_err

call "%mbt_mf_vars_of_bat%" "%_mbt_cof_file%" "_cof" "=" 1
if "%ERRORLEVEL%" NEQ "0" set "_mbt_err=read_fild: [%_mbt_cof_file%]" & goto write_err




REM todo check fcp.exe

REM _cof_mbt_log_note
if "%_cof_mbt_log_note%" NEQ "" (
  if "%mbt_log_note%" NEQ "" set "_cof_mbt_log_note= ; %_cof_mbt_log_note%"
)
set "mbt_log_note=%mbt_log_note%%_cof_mbt_log_note%"

REM _cof_mbt_debug_level__i
if "%_cof_mbt_debug_level__i%" NEQ "" (
  if "%mbt_debug_level__i%" == "" set /a mbt_debug_level__i=%_cof_mbt_debug_level__i%
)
if "%mbt_debug_level_def__i%" NEQ "" (
  if "%mbt_debug_level__i%" == "" set /a mbt_debug_level__i=%mbt_debug_level_def__i%
)
if "%mbt_debug_level__i%" == "" set /a mbt_debug_level__i=0


REM _cof_mbt_sucess_sleep__i


if "%mbt_sucess_sleep__i%" == "" (
  if "%_cof_mbt_sucess_sleep__i%" NEQ "" set /a mbt_sucess_sleep__i=%_cof_mbt_sucess_sleep__i%
)
if "%mbt_sucess_sleep__i%" == "" (
  if "%mbt_sucess_sleep_def__i%" NEQ "" set /a mbt_sucess_sleep__i=%mbt_sucess_sleep_def__i%
)
if "%mbt_sucess_sleep__i%" == "" set /a mbt_sucess_sleep__i=0


REM mbt_log_lines_max__i
if "%mbt_log_lines_max__i%" == "" (
  if "%_cof_mbt_log_lines_max__i%" NEQ "" set /a mbt_log_lines_max__i=%_cof_mbt_log_lines_max__i%
)
if "%mbt_log_lines_max__i%" == "" (
  if "%mbt_log_lines_max_def__i%" NEQ "" set /a mbt_log_lines_max__i=%mbt_log_lines_max_def__i%
)
if "%mbt_log_lines_max__i%" == "" set /a mbt_log_lines_max__i=9


REM mbt_log_file
if "%mbt_log_file%" == "" (
  if "%_cof_mbt_log_file%" NEQ "" set "mbt_log_file=%_cof_mbt_log_file%"
)
if "%mbt_log_file%" == "" (
  if "%mbt_log_file_def%" NEQ "" set "mbt_log_file=%mbt_log_file_def%"
)

if /i "%mbt_log_file%" == "_actype_name_" (
  set "mbt_log_file=%mbt_tool_dir%_%_mbt_ac_type%_%mbt_version%.log"
  goto skip_check_log_file
) else if /i "%mbt_log_file%" == "_caller_name_" (
  set "mbt_log_file=%_mbt_this_dir%_%_mbt_this_bat%.log"
  goto skip_check_log_file
) else if /i "%mbt_log_file%" == "_bat_name_" (
  set "mbt_log_file=%~dp0_%~n0.log"
  goto skip_check_log_file
) else if "%mbt_log_file%" == "" (
  set "mbt_log_file=%~dp0_%~n0.log"
  goto skip_check_log_file
)
REM check log file path
if "%mbt_log_file:~-1%" == "\" set "mbt_log_file=%mbt_log_file%%~n0.log"
if "%mbt_log_file:~0,1%" == "\" set "mbt_log_file=%_mbt_this_dir%%mbt_log_file:~1%"
set "log_file_right4_=%mbt_log_file:~-4%"
if "%log_file_right4_%" NEQ ".txt" (
  if "%log_file_right4_%" NEQ ".log" (
    set "mbt_log_file=%mbt_log_file%.txt"
  )
)
if "%mbt_log_file:~1,2%" NEQ ":\" set "mbt_log_file=%_mbt_this_dir%%mbt_log_file%"
:skip_check_log_file



REM mbt_run_confirm
if "%mbt_run_confirm%" == "" (
  if "%_cof_mbt_run_confirm%" NEQ "" set "mbt_run_confirm=%_cof_mbt_run_confirm%"
)
if "%mbt_run_confirm%" == "" (
  if "%mbt_run_confirm_def%" NEQ "" set "mbt_run_confirm=%mbt_run_confirm_def%"
)
if /i "%mbt_run_confirm%" == "N" set "mbt_run_confirm="

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

REM check mbt_fastcopy_dir
REM mbt_fastcopy_dir
if "%mbt_fastcopy_dir%" == "" (
  if "%_cof_mbt_fastcopy_dir%" NEQ "" set "mbt_fastcopy_dir=%_cof_mbt_fastcopy_dir%"
)
if "%mbt_fastcopy_dir%" == "" (
  if "%mbt_fastcopy_dir_def%" NEQ "" set "mbt_fastcopy_dir=%mbt_fastcopy_dir_def%"
)
if "%mbt_fastcopy_dir%" == "" (
  set "mbt_fastcopy_dir=%mbt_tool_dir%fastcopy\"
  goto skip_check_fastcopy_dir_path
)

if "%mbt_fastcopy_dir%" =="" set "_mbt_err=mbt_fastcopy_dir is null" & goto write_err
if "%mbt_fastcopy_dir:~1,2%" NEQ ":\" set "mbt_fastcopy_dir=%mbt_tool_dir%%mbt_fastcopy_dir%"
if "%mbt_fastcopy_dir:~-1%" NEQ "\" set "mbt_fastcopy_dir=%mbt_fastcopy_dir%\"
:skip_check_fastcopy_dir_path

REM check fastcopy2.ini
set "mbt_fastcopy_ini=%mbt_fastcopy_dir%%mbt_fastcopy_ini%"
REM echo. & echo. "mbt_fastcopy_ini:%mbt_fastcopy_ini%"
if not exist "%mbt_fastcopy_ini%" set "_mbt_err=mbt_fastcopy_ini not find" & goto write_err

REM check _mbt_ac_run
set "_mbt_ac_run=%mbt_tool_dir%%mbt_ac_run_pre%%_mbt_ac_type%"
if not exist "%_mbt_ac_run%_%mbt_version%.bat" (
  set "_mbt_ac_run=%_mbt_ac_run%_%mbt_version_main%.bat"
) else (
  set "_mbt_ac_run=%_mbt_ac_run%_%mbt_version%.bat"
)
if not exist "%_mbt_ac_run%" set "_mbt_err=_mbt_ac_run not find" & goto write_err

REM echo. & echo. "_mbt_ac_run:%_mbt_ac_run%"

set "mbt_write_log_bat=%mbt_tool_dir%%mbt_write_log_bat_pre%"

echo. "----%mbt_write_log_bat%%mbt_version%.bat"


REM echo. "_cof_mbt_fastcopy_dir:%_cof_mbt_fastcopy_dir%"
REM echo. "_cof_mbt_log_note:%_cof_mbt_log_note%"
REM echo. "_cof_mbt_run_confirm:%_cof_mbt_run_confirm%"

echo. "----------------"
echo.
echo. "_mbt_ac_run:%_mbt_ac_run%"
REM echo. "mbt_fastcopy_ini:%mbt_fastcopy_ini%"
REM echo. "mbt_fastcopy_dir:%mbt_fastcopy_dir%"
echo. "mbt_debug_level__i:%mbt_debug_level__i%"
echo. "mbt_sucess_sleep__i:%mbt_sucess_sleep__i%"

REM echo. "mbt_allow_ac_type:%mbt_allow_ac_type%"

echo. "mbt_debug_level__i:%mbt_debug_level__i%"
echo. "mbt_log_lines_max__i:%mbt_log_lines_max__i%"
REM echo. "mbt_run_confirm:%mbt_run_confirm%"
echo. "mbt_debug_level__i:%mbt_debug_level__i%"
echo. "mbt_log_note:%mbt_log_note%"
echo. "mbt_log_file:%mbt_log_file%"
echo.
echo. "mbt_write_log_bat_pre:%mbt_write_log_bat_pre%"
echo. "mbt_fpc_exec_name:%mbt_fpc_exec_name%"
echo. "mbt_fpc_exec_post:%mbt_fpc_exec_post%"
echo.
echo. "mbt_fastcopy_dir_def:%mbt_fastcopy_dir_def%"
echo. "mbt_run_confirm_def:%mbt_run_confirm_def%"
echo. "mbt_run_confirm:%mbt_run_confirm%"
echo. "_cof_mbt_run_confirm:%_cof_mbt_run_confirm%"
echo. "mbt_log_lines_max_def__i:%mbt_log_lines_max_def__i%"
echo. "mbt_log_lines_max__i:%mbt_log_lines_max__i%"
echo. "mbt_sucess_sleep_def__i:%mbt_sucess_sleep_def__i%"
echo. "mbt_sucess_sleep__i:%mbt_sucess_sleep__i%"
REM echo. "__vof_load_cout:%__vof_load_cout%"
echo.
echo. "_mbt_ac_name:%_mbt_ac_name%"
echo. "_mbt_ac_dir:%_mbt_ac_dir%"


REM if "%mbt_debug_level__i%" NEQ "" set /a mbt_debug_level__i=%mbt_debug_level__i%

REM if "%_v_caller_confirm%" NEQ "" set "mbt_run_confirm=%_v_caller_confirm%"





REM input arguments 1











REM echo.
REM REM echo. "--- !bat_right__:~%val_index_of%!"
REM echo. "_mbt_ac_name:%_mbt_ac_name%"
REM echo. "bat_right__:%bat_right__%"
REM echo. "mbt_log_file:%mbt_log_file%"





goto :EOF


REM check bat_name_right_string
set /a val_index_of=%val_index_of%+%sp_len__%
set "_mbt_ac_name=!bat_right__:~%val_index_of%!"
call:cut_left_chr "%_mbt_ac_name%" "%sp_cut_left__%" "_mbt_ac_name"


REM echo "_mbt_ac_name  %_mbt_ac_name%"
REM set /a val_index_of=-1

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

    if not exist "!_mbt_ac_dir!" set "_mbt_err=_mbt_ac_dir [!_mbt_ac_dir!] not find"

  )
)

if "%_mbt_err%" NEQ "" goto write_err


REM check mbt_tool_dir

REM if "%mbt_tool_dir%" EQU "" set "mbt_tool_dir=%_mbt_this_dir%"
REM if "%mbt_tool_dir:~1,2%" NEQ ":\" set "mbt_tool_dir=%_mbt_this_dir%%mbt_tool_dir%"
REM if "%mbt_tool_dir:~-1%" NEQ "\"  set "mbt_tool_dir=%mbt_tool_dir%\"

set "_mbt_run_bat=%mbt_tool_dir%run_%_mbt_ac_type%_%mbt_version_major%.bat"



REM check mbt_tool_dir\run_job_2.bat exist
if not exist "%_mbt_run_bat%" set "_mbt_err=%_mbt_run_bat% %%_mbt_run_bat%% not_fined"

if "%_mbt_err%" NEQ "" goto write_err

if "%mbt_debug_level__i%" == "" set /a mbt_debug_level__i=0

if %mbt_debug_level__i% GTR 0 (
  set /a mbt_debug_echo=%mbt_debug_echo% + 1
  echo.
  echo. "--- --- mfbooktool !mbt_debug_echo! [caller %_mbt_this_pre%]--- ---"
  echo.
  echo. "mbt_debug_level__i: %mbt_debug_level__i%"
  echo. "mbt_version_major: %mbt_version_major%"
  echo. "mbt_log_file: %mbt_log_file%"
  echo. "exec_action: %_mbt_ac_type% / %_mbt_ac_name%"
  echo. "_mbt_ac_type: %_mbt_ac_type%"
  echo. "_mbt_ac_name: %_mbt_ac_name%"
  echo. "_mbt_debug_level_stop: %_mbt_debug_level_stop%"
  echo. "_mbt_this_bat: %_mbt_this_bat%"
  echo. "_mbt_run_bat: %_mbt_run_bat%"
  echo. "_mbt_this_dir: %_mbt_this_dir%"
  echo. "_mbt_ac_dir:  %_mbt_ac_dir%"
  echo. "_mbt_this_pre_len: %_mbt_this_pre_len%"

  if %mbt_debug_level__i% GEQ %_mbt_debug_level_stop% goto :EOF

)

REM run_job_2.bat "f2" "mbt_2_job_f2.bat" "g:\test 1\log.txt"
REM run_job_2.bat "[_mbt_ac_name]" "d:\a\_this_bat_name.bat" "g:\test 1\log.txt"

"%_mbt_run_bat%" "%_mbt_ac_name%" "%~dpnx0" "%mbt_log_file%"

goto :EOF

:write_err

  set "mfbak_ymd=%date:~,4%-%date:~5,2%-%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"
  echo.
  echo. "--- error ---"
  echo.
  echo. "%_mbt_err%" 
  echo. "%mfbak_ymd% ; %computername%"
  if  "%mbt_log_file%" == "" goto :EOF
  if %mbt_debug_level__i% GEQ %_mbt_debug_level_stop% goto :EOF
  if "%mbt_log_note%" NEQ "" set "_mbt_err=%_mbt_err% ; %mbt_log_note%"
  echo. err^: "%_mbt_err%" ; %mfbak_ymd% ; %computername% >> "%mbt_log_file%"

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