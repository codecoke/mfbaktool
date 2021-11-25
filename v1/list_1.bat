@echo off

setlocal enabledelayedexpansion

:: mfBakTool exeute
:: var_pre mbt
:: list_1.bat
:: version 1.3.3


:: ---- ---- user setting ---- ----


set "fastcopy_dir=fastcopy392\"
::set "fastcopy_dir=G:\localSites_g\shell\mfbaktool\fastcopy_for_bak\"
set "write_log_bat="

:: --- --- need no modification ---

:: noexist_only | diff| update | force_copy| sync| move | delete
:: action if_not | diff | update | sync | move | copy | delete
:: list_bat 1 source 2 dest 3 [action ] 4[caller_bat] 5[custom_log]
:: inputs arguments

set "source=%~1"
set "dest=%~2"
set "ac_type=%~3"
set "caller_bat=%~4"
set "mbt_log_custom=%~5"

:: mfbaktool setting

set "mbt_log_info="
set "mbt_err="
set "mbt_name=mbt"
set "mbt_suatus=ok"
set "mbt_version=1.3.3"
set "mbt_version_major=%mbt_version:~0,1%"
set "mbt_caller_dir_err_file=error.%mbt_name%.log.txt"
set "mbt_log_var=_dev/v1/list:%mbt_version%"

:: setting def
set /a mbt_debug_level=2

set "write_log_bat_def=%mbt_name%_write_log_1.bat"
set "ac_typee_def=if_not"
set "ac_type_list=if_not,diff,update,sync,move,copy,delete"

:: execute 
set val_is_str_cludes=


set "bat_file_name=%~n0"
set "bat_name_end=%bat_file_name:~-2%"


:: mbt_call_type is list_1.bat substring list
set "mbt_call_type=list"
if "%bat_name_end:~0,1%" == "_" (
  set "mbt_call_type=%bat_file_name:~0,-2%"
  set "mbt_version_major=%bat_name_end:~-1%"
)


set "fastcopy_cmd=%ac_type%"

if /i "%source%" == "err" (
  set "mbt_err=inputs_null_info"
  set "ac_type=inputs_err"
  if "%dest%" NEQ "" set "mbt_err=%dest%"
  goto write_err
)

if "%ac_type%" == "" set "ac_type=%ac_typee_def%"
if /i "%ac_type%" == "if_not" set "fastcopy_cmd=noexist_only"
if /i "%ac_type%" == "copy" set "fastcopy_cmd=force_copy"


::check fastcopy_dir
if "%fastcopy_dir%" == "" set "fastcopy_dir=%~dp0"
if "%fastcopy_dir:~1,2%" NEQ ":\" set "fastcopy_dir=%~dp0%fastcopy_dir%"
if "%fastcopy_dir:~-1%" NEQ "\" set "fastcopy_dir=%fastcopy_dir%\"

set "fastcopy_exe=%fastcopy_dir%fastcopy.exe"
:: set "fastcopy_ini=%fastcopy_dir%fastcopy2.ini"

if not exist "%fastcopy_exe%" set "mbt_err=%fastcopy_exe% not exist" & goto write_err



if "%mbt_err%" NEQ "" goto write_err


goto write_log

goto :EOF
:: --- --- --- label --- --- ---

:write_err

  set "mbt_suatus=err"
  if "%mbt_err%" == ""  set "mbt_err=unknow_err_info"
  set "mbt_log_info=[%mbt_call_type%_%ac_type%] !mbt_err!"

  echo.
  echo. "--- ---  err info --- ---"
  echo. "mbt_err: %mbt_err%"
  echo.

::goto :EOF

:write_log

  if "%mbt_log_info%" == "" set "mbt_log_info=[%mbt_call_type%_%ac_type%] (%source%)__2__(%dest%)  sucess."
 
  set "mbt_log_info=%mbt_suatus%: !mbt_log_info!"

  if %mbt_debug_level% GTR 0 (

    echo.
    echo. "--- ---  debug info --- ---"
    echo. "mbt_debug_level: %mbt_debug_level%"
    echo. "source: %source%"
    echo. "dest: %dest%"
    echo. "ac_type: %ac_type%"
    echo. "caller_bat: %caller_bat%"
    echo. "mbt_log_custom: %caller_bat%"
    echo. "mbt_call_type: %mbt_call_type%"
    echo. "fastcopy_cmd: %fastcopy_cmd%"
    echo. "fastcopy_exe: %fastcopy_exe%"
    echo.
    echo. "mbt_log_info: %mbt_log_info%"
    echo.

    if %mbt_debug_level% GTR 1 goto :EOF

  )



goto :EOF


:: ---- ---- label funtion ---- ----
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

  set val_is_str_cludes=


  if "%~1" == ""  goto :EOF
  if "%~2" == ""  goto :EOF

  set is_cludes_str__=%~1

  set "is_cludes_dif__=!is_cludes_str__:%~2=&rem.!"
  set is_cludes_dif__=#%is_cludes_dif__%

  if "%is_cludes_dif__%" EQU "#%~1" goto :EOF

  set val_is_str_cludes=yes

  set is_cludes_str__=


  set is_cludes_dif__=



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