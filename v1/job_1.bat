@echo off

setlocal enabledelayedexpansion

:: mfBakTool exeute
:: var_pre mbt
:: job_1.bat
:: version 1.3.3

:: ---- ---- user setting ---- ----


set "fastcopy_dir=fastcopy392\"
::set "fastcopy_dir=G:\localSites_g\shell\mfbaktool\fastcopy_for_bak\"
set "write_log_bat="


:: --- --- need no modification ---
:: inputs arguments

:: job_1 "f2" "mbt_1_job_f2.bat" "c:\test 1\log.txt"

set "job_name=%~1"
set "call_bat=%~2"
set "mbt_log_custom=%~3"

:: mfbaktool setting

set "mbt_log_info="
set "mbt_err="
set "mbt_name=mbt"
set "mbt_suatus=ok"
set "mbt_version=1.3.3"
set "mbt_version_major=%mbt_version:~0,1%"
set "mbt_caller_dir_err_file=error.%mbt_name%.log.txt"
set "mbt_log_var=_dev/v1:%mbt_version%"

set "write_log_bat_def=%mbt_name%_write_log_1.bat"
set "ac_type="
set "ac_typee_def=info"
set "ac_type_list=info,job,list,folder"


:: execute 

set "val_is_str_cludes="
set "bat_file_name=%~n0"
set "bat_name_end=%bat_file_name:~-2%"


:: ac_type is job_1 substring job
if "%bat_name_end:~0,1%" == "_" (
  set "ac_type=%bat_file_name:~0,-2%"
  set "mbt_version_major=%bat_name_end:~-1%"
)


if "%ac_type%" == "" (
  set "ac_type=%ac_type_def%"
) else (
  call:is_str_cludes ",%ac_type_list%," ",%ac_type%,"
  if "!val_is_str_cludes!" == "" set "ac_type=%ac_type_def%"
)

call:is_str_cludes ",1,2,3,4,5,6," ",%mbt_version_major%,"
if "!val_is_str_cludes!" == "" set "mbt_version_major=1"


:: set write_log_bat

if "%write_log_bat%" == "" set "write_log_bat=write_log_%mbt_version_major%.bat"
if "%write_log_bat:~1,2%" NEQ ":\" set "write_log_bat=%~dp0%write_log_bat%"
if "%write_log_bat:~-4%" NEQ ".bat" set "write_log_bat=%write_log_bat%.bat"


::check job_name

if "%job_name%" == "" set "mbt_err=job_name is nul" &  goto write_err


if /i "%job_name%" == "err" (
  if "%call_bat%" == "" (
    set "mbt_err=input%%2 unknow_error_info"
  ) else (
    set "mbt_err=%call_bat%"
  )
  goto write_err
)

::check fastcopy_dir
if "%fastcopy_dir%" == "" set "fastcopy_dir=%~dp0"
if "%fastcopy_dir:~1,2%" NEQ ":\" set "fastcopy_dir=%~dp0%fastcopy_dir%"
if "%fastcopy_dir:~-1%" NEQ "\" set "fastcopy_dir=%fastcopy_dir%\"

set "fastcopy_exe=%fastcopy_dir%fastcopy.exe"
set "fastcopy_ini=%fastcopy_dir%fastcopy2.ini"

if not exist "%fastcopy_ini%" set "mbt_err=%fastcopy_ini% not exist" & goto write_err

set "find_job_name=title=""%job_name%"""
find /i "%find_job_name%" "%fastcopy_ini%" >nul || set "mbt_err=job_name not find"

if "%mbt_err%" NEQ "" goto write_err


start "" /min /wait "%fastcopy_exe%" /no_ui /job="%job_name%"
::start "" /min ... postproc=%ac_name%

if %errorlevel% NEQ 0 set "mbt_err=%ac_type% fastcopy_exe fild"
if "%mbt_err%" NEQ "" goto write_err


set "mbt_log_info=%ac_type% sucess!"

if "%call_bat%" NEQ "" (
  if /i "%call_bat:~-4%" == ".bat" (
    if exist "%~dp2%mbt_caller_dir_err_file%" (
      del "%~dp2%mbt_caller_dir_err_file%"
    )
  )
)

goto write_log


:: ---- ---- ---- label ---- ---- ----
goto :EOF

:write_err

  set "mbt_suatus=err"
  goto write_log

goto :EOF

:: log
:write_log

  pushd %~dp0

  if "%mbt_log_info%" == "" (
    if "%mbt_err%" NEQ "" (
      set "mbt_suatus=err"
      set "mbt_log_info=%mbt_err%"
    ) else (
      set "mbt_log_info=unknow_log_info"
    )
  )
  

  if "%job_name%" == "" (
    set job_name=job_name_null
  ) else if /i "%job_name%" =="err" (
    set job_name=input_err
  )

  set "mbt_log_info=%mbt_suatus%: [%job_name%] %mbt_log_info% %mbt_log_var%"

  if not exist "%write_log_bat%" set "write_log_bat=%~dp0%write_log_bat_def%"

  if not exist "%write_log_bat%" (

    echo.
    echo. "--- --- --- %ac_type% exe log --- --- ---"
    echo.
    echo. "write_log_bat: %write_log_bat% not exist"
    echo. %ac_type% info: "%mbt_log_info%"
    echo.

    goto :EOF

  )

  if "%mbt_log_custom%" NEQ ""  (
    if /i "%~x3" EQU ".txt"  (
      
      "%write_log_bat%" "%mbt_log_info%" "%ac_type%" "%mbt_log_custom%"

      goto:EOF

    )
  )

  "%write_log_bat%" "%mbt_log_info%" "%ac_type%"

goto :EOF



::: ---- ---- label funtion ---- ----
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