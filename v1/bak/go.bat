

@echo off
setlocal enabledelayedexpansion

:: mfbak_caller
:: version 1.2
:: g:\test_1\test-2
:: w@ibar.cn

set "mbt_call_file_name=%~n0"



::set "mbt_call_file_name=mf_bak_tool_2----------job-----f2"
set "mbt_call_file_name=mf_bak_tool_1----------job-----f2----bak test 1"
set "mbt_call_file_name=mf_bak_tool_1----------job-----f3----bak test 1"
::set "mbt_call_file_name=mf_bak_tool_2----------job-----f2----bak test 2"

set "mbt_name=mf_bak_tool"

set "mbt_tool_dir=C:\c_share\c_share\%mbt_name%\"

set "mbt_version=1.2"
set "mbt_version_major=%mbt_version:~0,1%"


set "mbt_path_sp=----"
set /a sp_len__=4
set "sp_cut_left__=%mbt_path_sp:~0,1%"

::set "mfbak_ac_type_def=job"
set "mbt_ac_type_list=info,cmd,job,list,folder"
set "mbt_ac_type="
set "mbt_ac_name="
set "mbt_ac_dir="
set "mbt_bat="

set "mfbak_call_err_file=error.%mbt_name%.log.txt"
set "arg_1=%~1"
set "arg_2=%~2"

set "mfbak_err="


:: ck arg_1 == err
if /i "%arg_1%" == "err" (
  set "mfbak_err=%arg_2%"
  if "%arg_2%" == "" set "mfbak_err=unknow_err"
)
if "%mfbak_err%" NEQ "" goto write_err

:: check file_name_left
if /i "%mbt_call_file_name:~0,12%" neq "%mbt_name%_"  set "mfbak_err=file_name_head_err" & goto write_err

:: check file version
call:is_str_cludes ",1,2,3,4,5," ",%mbt_call_file_name:~12,1%,"
if defined val_is_str_cludes set "mbt_version_major=%mbt_call_file_name:~12,1%"


set "bat_right__=%mbt_call_file_name:~13%"

call:cut_left_chr "%bat_right__%" "%sp_cut_left__%" "bat_right__"

set /a cut_i_=-1

call:index_of "%bat_right__%" "%mbt_path_sp%"

if %val_index_of% LSS 0 set "mfbak_err=file_right_err[ac_type%mbt_path_sp%ac_name]"

if "%mfbak_err%" NEQ "" goto write_err



set "mbt_ac_type=!bat_right__:~0,%val_index_of%!"

set /a val_index_of=%val_index_of%+%sp_len__%
set "mbt_ac_name=!bat_right__:~%val_index_of%!"
call:cut_left_chr "%mbt_ac_name%" "%sp_cut_left__%" "mbt_ac_name"

::echo "mfbak_ac_name0  %mbt_ac_name%"

set /a val_index_of=-1

call:index_of "%mbt_ac_name%" "%mbt_path_sp%"

if %val_index_of% GTR -1  (

  set "bat_right__=!mbt_ac_name:~%val_index_of%!"
  set "mbt_ac_dir=!bat_right__:~%sp_len__%!"
  set "mbt_ac_name=!mbt_ac_name:~0,%val_index_of%!"

)

::echo "mbt_ac_name: %mbt_ac_name%"
::echo "mbt_ac_dir: %mbt_ac_dir%"

call:cut_left_chr "%mbt_ac_dir%" "%sp_cut_left__%" "mbt_ac_dir"

:: check target_dir
if "%mbt_ac_dir%" NEQ ""  (

  set "mbt_ac_dir=%mbt_ac_dir:#=\%"

  if not exist "%~dp0!mbt_ac_dir!" set "mfbak_err=[%~dp0!mbt_ac_dir!] not find" & goto write_err

)

if "%mfbak_err%" NEQ "" goto write_err



::echo "val_is_str_cludes: %val_is_str_cludes%"
::echo "mbt_ac_type: %mbt_ac_type%"
::goto :eof

:: check ac_type
call:is_str_cludes ",%mbt_ac_type_list%," ",%mbt_ac_type%,"

if not defined val_is_str_cludes set "mfbak_err=[%mbt_ac_type%] not in [%mbt_ac_type_list%]"

if "%mfbak_err%" NEQ "" goto write_err

::check mbt_tool_dir

if "%mbt_tool_dir%" == "" set "mbt_tool_dir=%~dp0%mbt_name%\"
if "%mbt_tool_dir:~1,2%" NEQ ":\" set "mbt_tool_dir=%~dp0%mbt_tool_dir%"

if "%mbt_tool_dir:~-1%" NEQ "\"  set "mbt_tool_dir=%mbt_tool_dir%\"

:: check mbt_bat

set "mbt_bat=%mbt_tool_dir%%mbt_ac_type%_%mbt_version_major%.bat"

if not exist "%mbt_bat%" (
  set "mbt_bat=%mbt_tool_dir%%mbt_ac_type%_1.bat"
)

if not exist "%mbt_bat%" set "mfbak_err=%mbt_bat% %%mbt_bat%% not_fined"

if "%mfbak_err%" NEQ "" goto write_err

  ::echo "mbt_bat 4: %mbt_bat%"
  ::echo "mbt_ac_name 4: %mbt_ac_name%"
  ::echo "mbt_ac_type 4: %mbt_ac_type%"
  ::echo "mbt_ac_dir 4:  %mbt_ac_dir%"
  ::echo "mbt_version_major 4: %mbt_version_major%"
  ::echo "mbt_call_file_name 4: %mbt_call_file_name%"
  ::goto :eof

"%mbt_bat%" "%mbt_ac_name%" "%~dpnx0"

goto :EOF

:write_err
  ::pushd %~dp0
  set "mfbak_ymd=%date:~,4%-%date:~5,2%-%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"

  echo. "--- err ---"
  echo. err: "%mfbak_err%" ; %mfbak_ymd% ; %computername%

  echo. err: "%mfbak_err%" ; %mfbak_ymd% ; %computername% >> "%~dp0%mfbak_call_err_file%"

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
::for %%A in (2187 729 243 81 27 9 3 1) do (
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