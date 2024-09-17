@echo off

setlocal enabledelayedexpansion

REM mfbaktool exeute job
REM run_job_2.bat
REM version 2.0.0
REM w(a)ibar.cn 2024-09-04 12:37:17

REM inputs arguments
REM run_job_2.bat 
REM run_[ac_type]_[mbt_version].bat 
REM   "[ac_name]" "[caller_bat]"      "[_log_file]"
REM   "f2"        "mbt_2_job_f2.bat"  "c:\test 1\log.txt"


REM ---- ---- user setting ----
REM set "fastcopy_dir=G:\localAppRun\green\fastcopy\4.2.2\"
set "fastcopy_dir=fastcopy\4.2.2\"
set "write_log_bat="




REM --- --- need no modification ---

set "ac_name=%~1"
set "caller_bat=%~2"
set "_log_file=%~3"

set "_mbt_this_dir=%~dp0"
REM mfbaktool setting

set "_log_info="
set "_mbt_err="
set "_mbt_suatus=ok "
set "val_is_str_cludes="


REM add write to log_info
REM set "mbt_log_note="

set /a _mbt_debug_level_stop=3

if "%mbt_debug_echo%"=="" set /a mbt_debug_echo=0
if "%mbt_debug_level%" == "" set /a mbt_debug_level=0
if "%mbt_pushd_count%" == "" set /a mbt_pushd_count=0

if "%mbt_log_lines_max%" =="" set /a mbt_log_lines_max=20
if %mbt_log_lines_max% LSS 3 set /a mbt_log_lines_max=3

if "%mbt_sucess_sleep%" =="" (
  if %mbt_debug_level% GTR 0 (
    set /a mbt_sucess_sleep=3
  )else (
    set /a mbt_sucess_sleep=0
  )
)


set "mbt_fpc_exec_err_name=fastcopy_fpc_exec_err_ify"
set "mbt_fpc_exec_post=fcp_err_ify"
set "mbt_fpc_exec_err_log="

if "%mbt_script_version%" =="" set "mbt_script_version=2.0.0"

set "ac_type="
set "ac_typee_def=info"
if "%mbt_ac_type_list%"=="" set "mbt_ac_type_list=info,cmd,job,queue,list,folder,file-list"


REM execute 

set /a mbt_debug_level=3

set "_bat_file_name=%~n0"




REM get ac_type by _bat_file_name

REM run_job_2.1bat underline _ 1
call:index_of "%_bat_file_name%" "_"
if %val_index_of% LSS 0 set "_mbt_err=run_bat_name must have _ 1" & goto write_err
set /a _bat_underline_1= %val_index_of%+1

REM run_job_2.1bat underline _ 2
call:index_of "!_bat_file_name:~%_bat_underline_1%!" "_"
if %val_index_of% LSS 0 set "_mbt_err=run_bat_name must have _ 2" & goto write_err
set /a _bat_underline_2= %val_index_of%

set "ac_type=!_bat_file_name:~%_bat_underline_1%,%_bat_underline_2%!"

REM echo "%ac_type%"

call:is_str_cludes ",%mbt_ac_type_list%," ",%ac_type%,"
if "!val_is_str_cludes!" == "" set "_mbt_err=[%ac_type%] not in [%mbt_ac_type_list%]"

if "%_mbt_err%" NEQ "" goto write_err

REM set "mbt_version_major="
REM echo. "mbt_version_major1:%mbt_version_major%"

REM check mbt_versoin_major in run_bat_file_name
if "%mbt_version_major%" NEQ "" goto check_mbt_version_major

set /a _bat_underline_3=%_bat_underline_1% + %_bat_underline_2% + 1
set "mbt_version_major=!_bat_file_name:~%_bat_underline_3%,1!"


call:is_str_cludes ",1,2,3,4,5,6," ",%mbt_version_major%,"
if "!val_is_str_cludes!" == "" (
  echo. "warning: mbt_script_version in run_bat_name is err!"
  set "mbt_version_major=%mbt_script_version:~0,1%"
)
REM echo "----mbt_version_major: %mbt_version_major%"

:check_mbt_version_major

REM echo. "mbt_version_major-2:%mbt_version_major%"
REM echo. "mbt_version_major-3:%mbt_version_major:~1,1%"
REM echo. "mbt_version_major_1:%mbt_version_major_1%"
REM echo "----1%_mbt_err%"

REM set "mbt_version_major_1=%mbt_version_major%"

REM if mbt_version_major is 2.x
if "%mbt_version_major_1%" == "" (
  if "%mbt_version_major:~1,1%" == "." set "mbt_version_major_1=%mbt_version_major:~0,1%"
  call:is_str_cludes ",1,2,3,4,5,6," ",!mbt_version_major_1!,"
  if "!val_is_str_cludes!" == "" set "_mbt_err=mbt_version_major: !mbt_version_major_1! is error value"
  if "%write_log_bat%" == "" set "write_log_bat=run_write_log_!mbt_version_major_1!.bat"

) else (
  call:is_str_cludes ",1,2,3,4,5,6," ",%mbt_version_major%,"
  if "!val_is_str_cludes!" == "" set "_mbt_err=mbt_version_major: %mbt_version_major% is error value"
  if "%write_log_bat%" == "" set "write_log_bat=run_write_log_!mbt_version_major!.bat"
)


if "%write_log_bat:~1,2%" NEQ ":\" set "write_log_bat=%_mbt_this_dir%%write_log_bat%"
if "%write_log_bat:~-4%" NEQ ".bat" set "write_log_bat=%write_log_bat%.bat"

if "%_log_file%" == "" set "_log_file=%~dpn2.log"
if "%_log_file:~-1%" == "\" set "_log_file=%_log_file%%~n2.log"

if "%_mbt_err%" NEQ "" goto write_err


if %mbt_debug_level% GTR 0 (
  set /a mbt_debug_echo=%mbt_debug_echo% + 1
  echo.
  echo.
  echo. "--- --- mfbooktool !mbt_debug_echo! [run1 action]--- ---"
  echo. "dp0: %~dp0"
  REM echo. "_bat_file_name:  %~n0"
  echo. "_bat_file_name: %_bat_file_name%"
  echo. "_mbt_this_dir:  %_mbt_this_dir%"
  echo. "mbt_debug_level:  %mbt_debug_level%"
  echo. "cd: %cd%"
  REM echo. "n0: %~n0"
  REM echo. "nx0: %~nx0"
  REM echo. "pnx0: %~pnx0"
  REM echo. "d0: %~d0"
  REM echo. "dpnx0:%~dpnx0"
  echo. "ac_type:  %ac_type%"
  echo. "ac_name:  %ac_name%"
  echo. "caller_bat: %caller_bat%"
  echo. "mbt_ac_type_list: %mbt_ac_type_list%"
  echo. "mbt_script_version:  %mbt_script_version%"
  echo. "mbt_version_major: %mbt_version_major%"
  echo. "mbt_version_major_1: %mbt_version_major_1%"
  echo. "fastcopy_dir:  %fastcopy_dir%"
  echo. "mbt_log_note: %mbt_log_note%"
  echo. "_log_file: %_log_file%"

  REM if %mbt_debug_level% GTR 1 goto :EOF
)


REM check ac_name
if "%ac_name%" == "" set "_mbt_err=%ac_type% is nul" &  goto write_err


if /i "%ac_name%" == "err" (
  if "%caller_bat%" == "" (
    set "_mbt_err=input%%2 unknow_error_info"
  ) else (
    set "_mbt_err=%caller_bat%"
  )
  goto write_err
)

REM check fastcopy_dir
if "%fastcopy_dir%" == "" set "fastcopy_dir=%_mbt_this_dir%"
if "%fastcopy_dir:~1,2%" NEQ ":\" set "fastcopy_dir=%_mbt_this_dir%%fastcopy_dir%"
if "%fastcopy_dir:~-1%" NEQ "\" set "fastcopy_dir=%fastcopy_dir%\"

set "fastcopy_fcp_exe=%fastcopy_dir%fcp.exe"
set "fastcopy_ini=%fastcopy_dir%fastcopy2.ini"


if not exist "%fastcopy_fcp_exe%" (
  set "_mbt_err=%fastcopy_fcp_exe% not exist"
) else (
  set "find_job_name=title=""%ac_name%"""
  find /i "!find_job_name!" "%fastcopy_ini%" >nul || set "_mbt_err=%ac_type% : [%ac_name%] not find in fastcopy2.ini"
)



if %mbt_debug_level% GTR 0 (
  set /a mbt_debug_echo=%mbt_debug_echo% + 1

  echo.
  echo.
  echo. "--- --- mfbooktool !mbt_debug_echo! [run2 action]--- ---"
  echo. "_mbt_this_dir: %_mbt_this_dir%"
  echo. "fastcopy_dir: %fastcopy_dir%"
  echo. "mbt_fpc_exec_err_name: %mbt_fpc_exec_err_name%"
  echo. "mbt_fpc_exec_err_log: %mbt_fpc_exec_err_log%"
  echo. "_mbt_err: %_mbt_err%"
  echo. "mbt_write_log_bat: %write_log_bat%"
  echo. "mbt_pushd_count: %mbt_pushd_count%"
  echo. "cd: !cd!"

  if %mbt_debug_level% GEQ %_mbt_debug_level_stop% goto end_popd
  REM if %mbt_debug_level% GTR 1 goto end_popd
)


if "%_mbt_err%" NEQ "" goto write_err

REM check_fcp_exec_err_file:  _error.%mbt_fpc_exec_err_name%.log

if exist "%_mbt_this_dir%%mbt_fpc_exec_err_name%.bat" (
    set "mbt_fpc_exec_err_log=%_mbt_this_dir%_error.%mbt_fpc_exec_err_name%.log"
    if exist "!mbt_fpc_exec_err_log!" (
      del "!mbt_fpc_exec_err_log!"
    )
)

REM set "_mbt_err="

if %mbt_pushd_count% LSS 1 (
  pushd %_mbt_this_dir%
  set /a mbt_pushd_count=!mbt_pushd_count! + 1
)


"%fastcopy_fcp_exe%" /%ac_type%="%ac_name%" /postproc="%mbt_fpc_exec_post%"

if %errorlevel% NEQ 0 set "_mbt_err=%ac_type% shell_fpc_exec fild"

if "%_mbt_err%" NEQ "" goto write_err

if %mbt_sucess_sleep% GTR 1 ping 127.0.0.1 -n %mbt_sucess_sleep% 1>nul

if "%mbt_fpc_exec_err_log%" NEQ "" (
  if exist "!mbt_fpc_exec_err_log!" set "_mbt_err=%ac_type% call_fpc_exec error"
)

if "%_mbt_err%" NEQ "" goto write_err


set "_log_info=%ac_type% sucess!"

REM if "%caller_bat%" NEQ "" (
REM   if /i "%caller_bat:~-4%" == ".bat" (
REM     if exist "%~dp2%mbt_caller_dir_err_file%" (
REM       del "%~dp2%mbt_caller_dir_err_file%"
REM     )
REM   )
REM )

goto write_log


REM ---- ---- ---- label ---- ---- ----
goto :EOF

:write_err
  set "_mbt_suatus=err"
  goto write_log

goto :EOF

REM log
:write_log

  REM EQU等于 NEQ不等于  LSS小于  LEQ小于或等于  GTR大于  GEQ大于或等于

  if %mbt_pushd_count% LSS 1 (
    pushd %_mbt_this_dir%
    set /a mbt_pushd_count=!mbt_pushd_count! + 1
  )

  if "%_log_info%" == "" (
    if "%_mbt_err%" NEQ "" (
      set "_mbt_suatus=err"
      set "_log_info=%_mbt_err%"
    ) else (
      set "_log_info=unknow_log_info"
    )
  )


  if "%ac_name%" == "" (
    set "ac_name=job_name_is_null"
  ) else if /i "%ac_name%" =="err" (
    set "ac_name=input_err"
  )

  if "%mbt_log_note%" NEQ "" (
    set "_log_info=%_mbt_suatus%: [%ac_name%] %_log_info% %mbt_log_note%"
  ) else (
    set "_log_info=%_mbt_suatus%: [%ac_name%] %_log_info%"
  )


  if "%_mbt_err%" NEQ "" (
    echo.
    echo. "--- --- error --- ---"
    echo.
    echo. "action: %ac_type%"
    echo. "%_log_info%"
  )


  if not exist "%write_log_bat%" (
    echo.
    echo. "--- --- --- %ac_type% exe log --- --- ---"
    echo.
    echo. "write_log_bat: %write_log_bat% not exist"
    echo. %ac_type% info: "%_log_info%"
    echo.

    if !mbt_pushd_count! GTR 0 (
      popd
      set /a mbt_pushd_count=!mbt_pushd_count! - 1
    )

    goto end_popd

  )

  set "mbt_log_file_right4=%_log_file:~-4%"
  if "%mbt_log_file_right4%" NEQ ".txt" (
    if "%mbt_log_file_right4%" NEQ ".log" (
      set "_log_file=%_log_file%.txt"
    )
  )

  "%write_log_bat%" "%_log_info%" "%ac_type%" "%_log_file%"

  goto end_popd

goto :EOF


REM ---- check pushd and back
goto :EOF

:end_popd

  if !mbt_pushd_count! GTR 0 (
    popd
    set /a mbt_pushd_count=!mbt_pushd_count! - 1
  )

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

for %%A in (2187 729 243 81 27 9 3 1) do (
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