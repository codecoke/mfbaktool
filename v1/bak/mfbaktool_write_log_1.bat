
@echo off
setlocal enabledelayedexpansion

:: mfBakTool write log
:: mfbaktool_write_log_1.bat
:: version 1.2
:: w@ibar.cn
:: ---- ----
:: "mfbooktool_write_log_1.bat" "log_string" "log_type"


set "mbt_log_info=%~1"
set "mbt_log_type=%~2"
set "mbt_log_custom=%~3"

::set "mbt_log_dir=mfbak_log"
::set "mbt_log_dir=G:\test_1\mfbak_log\"
::set "mbt_log_file=your_log_file_name.txt"

set "mbt_log_dir="
set "mbt_log_file="
set /a mbt_log_lines_max=15

:: setting default

set "mbt_version=1"
set "mbt_name=mfbaktool"

set "log_type_def=info"
set "log_type_list=job,info,list,folder"
set "log_write_type=add"
set "bat_name=%~n0"
set "bat_name_end=%bat_name:~-2%"


if "%bat_name_end:~0,1%" == "_" (
  set "mbt_version=%bat_name_end:~-1%"
)

if "%mbt_log_type%" == "" (
  set "mbt_log_type=%log_type_def%"
) else (

  call:is_str_cludes ",%log_type_list%," ",%mbt_log_type%,"
  if not defined val_is_str_cludes set "mbt_log_type=%log_type_def%"

)

  if "%mbt_log_custom%" NEQ ""  (
    if /i "%~x3" EQU ".txt"  (

      set "mbt_log_dir=%~dp3"
      set "mbt_log_file=%~dpnx3"
      goto check_log_lines

    )
  )



if "%mbt_log_info%" == "" set "mbt_log_info=loginfo_is_null"

if "%mbt_log_dir%" == "" set "mbt_log_dir=%~dp0"
if "%mbt_log_dir:~1,2%" NEQ ":\" set "mbt_log_dir=%~dp0%mbt_log_dir%"
if "%mbt_log_dir:~-1%" NEQ "\"  set "mbt_log_dir=%mbt_log_dir%\"

if "%mbt_name%" == "" set "mbt_name=log"

if "%mbt_log_file%" == "" set "mbt_log_file=log.%mbt_name%.%mbt_log_type%_%mbt_version%.txt"
if "%mbt_log_file:~-4%" NEQ ".txt" set "mbt_log_file=%mbt_log_file%.txt"

set "mbt_log_file=%mbt_log_dir%%mbt_log_file%"


:check_log_lines

if not exist "%mbt_log_file%" goto write_info

set /a log_lines__=-1
for /f "tokens=2 delims=:" %%i in ('find /v "" %mbt_log_file%') do (
    set /a log_lines__=!log_lines__!+1
)

if %log_lines__% GEQ %mbt_log_lines_max% set "log_write_type=clear"

::goto write_info
::goto :EOF

:write_info

  set "log_ymd=%date:~,4%/%date:~5,2%/%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"

  set "mbt_log_info=%mbt_log_info% ; %log_ymd% ; %computername%"

  ::  echo. "mbt_log_file: %mbt_log_file%"
  ::  echo. "mbt_log_dir: %mbt_log_dir%"
  ::  echo. "bat_name: %~n0"
  ::  echo. "%mbt_log_info%"    
  ::  goto :EOF

  if not exist "%mbt_log_dir%" md "%mbt_log_dir%"

  if /i "%log_write_type%" == "add" (

    echo. %mbt_log_info% >> "%mbt_log_file%"

  ) else (

    echo. %mbt_log_info% > "%mbt_log_file%"

  )

  :: echo. "mbt_log_file: %mbt_log_file%"
  :: echo. "mbt_log_dir: %mbt_log_dir%"
  :: echo. "%mbt_log_info%"

  

goto :EOF

:: --- --- --- label --- --- ---
:is_str_cludes2
  set val_is_str_cludes2=
  set in_1=%~1
  set v_1=%~2

  if "%in_1%"=="" goto :EOF
  if "%v_1%"=="" goto :EOF

  echo "%in_1%" | findstr "%v_1%">nul && (
    set val_is_str_cludes2="yes"
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


