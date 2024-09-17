@echo off

setlocal enabledelayedexpansion

REM mfbaktool exeute job
REM mbt_run_job_2.bat
REM version 2.0.0
REM w@ibar.cn 2024-08-26 17:47:30

REM inputs arguments
REM mbt_run_job_2.bat 
REM mbt_run_[ac_type]_[mbt_version].bat 
REM   "[ac_name]" "[caller_bat]"      "[log_file]"
REM   "f2"        "mbt_2_job_f2.bat"  "c:\test 1\log.txt"


REM ---- ---- user setting ----
set "fastcopy_dir=fastcopy422\"
REM set "fastcopy_dir=G:\localSites_g\shell\mfbaktool\fastcopy_for_bak\"
set "write_log_bat="




REM --- --- need no modification ---

set "ac_name=%~1"
set "caller_bat=%~2"
set "log_file=%~3"

set "mbt_script_dir=%~dp0"
REM mfbaktool setting

set "mbt_log_info="
set "mbt_err="
set "mbt_suatus=ok "


set /a mbt_debug_level_stop=3
if "%mbt_debug_echo%"=="" set /a mbt_debug_echo=0


if "%mbt_debug_level%" == "" set /a mbt_debug_level=0
if "%mbt_pushd_count%" == "" set /a mbt_pushd_count=0

set /a mbt_sucess_sleep=3




set "mbt_fastcopy_exec_err_name=mbt_fastcopy_err_ify"
set "mbt_fastcopy_exec_err_log="

if "%mbt_script_version%" =="" set "mbt_script_version=2.0.0"

set "ac_type="
set "ac_typee_def=info"
set "ac_type_list=info,job,list,folder"


REM execute 

set "val_is_str_cludes="


set "_bat_file_name=%~n0"
set "_bat_file_name=%_bat_file_name:~8%"
set "_bat_name_end=%_bat_file_name:~-2%"

REM ac_type is job_2 substring job

if "%_bat_name_end:~0,1%" == "_" (
  set "ac_type=%_bat_file_name:~0,-2%"
  if "%mbt_version_major%" == "" set "mbt_version_major=%_bat_name_end:~-1%"
)

if "%mbt_version_major%" == "" set "mbt_version_major=%mbt_script_version:~0,1%"




set "mbt_log_var=_dev/v2 :ver.%mbt_version_major%_%mbt_script_version%"


if "%ac_type%" == "" (
  set "ac_type=%ac_type_def%"
) else (
  call:is_str_cludes ",%ac_type_list%," ",%ac_type%,"
  if "!val_is_str_cludes!" == "" set "ac_type=%ac_type_def%"
)


call:is_str_cludes ",1,2,3,4,5,6," ",%mbt_version_major%,"
if "!val_is_str_cludes!" == "" set "mbt_version_major=1"


REM set mbt_write_log_bat
if "%write_log_bat%" == "" set "write_log_bat=run_write_log_%mbt_version_major%.bat"
if "%write_log_bat:~1,2%" NEQ ":\" set "write_log_bat=%mbt_script_dir%%write_log_bat%"
if "%write_log_bat:~-4%" NEQ ".bat" set "write_log_bat=%write_log_bat%.bat"


if "%log_file%" == "" set "log_file=%~dpn2.log"

if "%log_file:~-1%" == "\" set "log_file=%log_file%%~n2.log"


set /a mbt_debug_echo=%mbt_debug_echo% + 1
if %mbt_debug_level% GTR 0 (

  echo.
  echo.
  echo. "--- --- mfbooktool [run %mbt_debug_echo%]--- ---"
  echo. "dp0: %~dp0"
  echo. "_bat_file_name:  %~n0"
  echo. "mbt_script_dir:  %mbt_script_dir%"
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
  echo. "mbt_script_version:  %mbt_script_version%"
  echo. "mbt_version_major: %mbt_version_major%"
  echo. "fastcopy_dir:  %fastcopy_dir%"
  echo. "mbt_log_var: %mbt_log_var%"
  echo. "log_file: %log_file%"

  REM if %mbt_debug_level% GTR 1 goto :EOF
)


REM check ac_name
if "%ac_name%" == "" set "mbt_err=%ac_type% is nul" &  goto write_err


if /i "%ac_name%" == "err" (
  if "%caller_bat%" == "" (
    set "mbt_err=input%%2 unknow_error_info"
  ) else (
    set "mbt_err=%caller_bat%"
  )
  goto write_err
)

REM check fastcopy_dir
if "%fastcopy_dir%" == "" set "fastcopy_dir=%mbt_script_dir%"
if "%fastcopy_dir:~1,2%" NEQ ":\" set "fastcopy_dir=%mbt_script_dir%%fastcopy_dir%"
if "%fastcopy_dir:~-1%" NEQ "\" set "fastcopy_dir=%fastcopy_dir%\"

set "fastcopy_fcp_exe=%fastcopy_dir%fcp.exe"
set "fastcopy_ini=%fastcopy_dir%fastcopy2.ini"


if not exist "%fastcopy_fcp_exe%" (
  set "mbt_err=%fastcopy_fcp_exe% not exist"
) else (
  set "find_job_name=title=""%ac_name%"""
  find /i "!find_job_name!" "%fastcopy_ini%" >nul || set "mbt_err=%ac_type% : %ac_name% not find in fastcopy2.ini"
)



if %mbt_debug_level% GTR 0 (
  set /a mbt_debug_echo=%mbt_debug_echo% + 1

  echo.
  echo.
  echo. "--- --- mfbooktool [run !mbt_debug_echo!]--- ---"
  echo. "mbt_script_dir: %mbt_script_dir%"
  echo. "fastcopy_dir: %fastcopy_dir%"
  echo. "mbt_fastcopy_exec_err_name: %mbt_fastcopy_exec_err_name%"
  echo. "mbt_fastcopy_exec_err_log: %mbt_fastcopy_exec_err_log%"
  echo. "mbt_err: %mbt_err%"
  echo. "mbt_write_log_bat: %write_log_bat%"
  echo. "mbt_pushd_count: %mbt_pushd_count%"
  echo. "cd: !cd!"

  if %mbt_debug_level% GTR 1 goto end_popd
)


if "%mbt_err%" NEQ "" goto write_err

REM check_fcp_exec_err_file:  _error.%mbt_fastcopy_exec_err_name%.log

if exist "%mbt_script_dir%%mbt_fastcopy_exec_err_name%.bat" (
    set "mbt_fastcopy_exec_err_log=%mbt_script_dir%_error.%mbt_fastcopy_exec_err_name%.log"
    if exist "!mbt_fastcopy_exec_err_log!" (
      del "!mbt_fastcopy_exec_err_log!"
    )
)

REM set "mbt_err="

if %mbt_pushd_count% LSS 1 (
  pushd %mbt_script_dir%
  set /a mbt_pushd_count=!mbt_pushd_count! + 1
)


REM start "" /min /wait "%fastcopy_exe%" /no_ui /job="%ac_name%"
"%fastcopy_fcp_exe%" /%ac_type%="%ac_name%" /postproc=fcp_err_ify

REM fastcopy422\fcp /job=test-notfind /postproc=fcp_err_ify
REM start "" /min ... postproc=%ac_name%

if %errorlevel% NEQ 0 set "mbt_err=%ac_type% fpc_exec fild"

if "%mbt_err%" NEQ "" goto write_err

if %mbt_debug_level% LSS 1 ping 127.0.0.1 -n %mbt_sucess_sleep% 1>nul

if "%mbt_fastcopy_exec_err_log%" NEQ "" (
  if exist "!mbt_fastcopy_exec_err_log!" set "mbt_err=%ac_type% fpc_exec error"
)

if "%mbt_err%" NEQ "" goto write_err


set "mbt_log_info=%ac_type% sucess!"

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
  set "mbt_suatus=err"
  goto write_log

goto :EOF

REM log
:write_log

  REM EQU等于 NEQ不等于  LSS小于  LEQ小于或等于  GTR大于  GEQ大于或等于

  if %mbt_pushd_count% LSS 1 (
    pushd %mbt_script_dir%
    set /a mbt_pushd_count=!mbt_pushd_count! + 1
  )

  if "%mbt_log_info%" == "" (
    if "%mbt_err%" NEQ "" (
      set "mbt_suatus=err"
      set "mbt_log_info=%mbt_err%"
    ) else (
      set "mbt_log_info=unknow_log_info"
    )
  )


  if "%ac_name%" == "" (
    set "ac_name=job_name_is_null"
  ) else if /i "%ac_name%" =="err" (
    set "ac_name=input_err"
  )

  set "mbt_log_info=%mbt_suatus%: [%ac_name%] %mbt_log_info% %mbt_log_var%"

  if "%mbt_err%" NEQ "" (
    echo.
    echo. "--- --- error --- ---"
    echo.
    echo. "action: %ac_type%"
    echo. "%mbt_log_info%"
  )


  if not exist "%write_log_bat%" (
    echo.
    echo. "--- --- --- %ac_type% exe log --- --- ---"
    echo.
    echo. "write_log_bat: %write_log_bat% not exist"
    echo. %ac_type% info: "%mbt_log_info%"
    echo.

    if !mbt_pushd_count! GTR 0 (
      popd
      set /a mbt_pushd_count=!mbt_pushd_count! - 1
    )

    goto end_popd

  )

  set "mbt_log_file_right4=%log_file:~-4%"
  if "%mbt_log_file_right4%" NEQ ".txt" (
    if "%mbt_log_file_right4%" NEQ ".log" (
      set "log_file=%log_file%.txt"
    )
  )

  "%write_log_bat%" "%mbt_log_info%" "%ac_type%" "%log_file%"

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