@echo off

REM read vars list from file.txt
REM w(a)ibar.cn 2024-09-06 03:37:53

REM call "mf_var_of_file.bat" "val.config.txt" val_pre val_sp val_echo_info
REM call "mf_var_of_file.bat" ["%~dp0\file.config.txt" "-" "=" 0]
REM "val_pre"  "-" means "filename_pre";  "" or "null" means "no_pre"
REM "val_sp" "default: ="
REM "val_echo_info" "default: 0 hide info"

set "__vof_file=%~1"
set "__vof_pre=%~2"
set "__vof_sp=%~3"
set "__vof_err="

set /a __vof_test_code=0

if "%~4" neq "" set /a __vof_test_code=%~4

set "__vof_pre_1="

if "%__vof_sp%" == "" set "__vof_sp=="

if "%__vof_file%" == "" (
  set "__vof_err=file name is null"
) else (
  if not exist "%__vof_file%" (
    set "__vof_err=not find [%__vof_file%]"
  )
)

if "%__vof_err%" neq "" goto end_with_err

REM if __vof_pre == "-" __vof_pre=_[filename]:~0,3

if /i "%__vof_pre%" == "null" (
  set "__vof_pre="
) else if "%__vof_pre%" == "-" (
  set "__vof_pre_1=%~n1"
  set "__vof_pre=_!__vof_pre_1:~0,3!"
)

REM replace specil_chr: _blank  .
if "%__vof_pre%" neq "" set "__vof_pre=%__vof_pre: =_%"
if "%__vof_pre%" neq "" set "__vof_pre=%__vof_pre:.=_%"

if "%__vof_pre%" neq "" (
  if "%__vof_pre:~-1%" neq "_" (
    set "__vof_pre=%__vof_pre%_"
  )
)

if  %__vof_test_code% gtr 1 (
  echo.
  echo. "---- %~nx0"
  echo. "%~dp1%"
  echo. "%~nx1"
  echo. "---- var of file :"
  echo.
)

for /f "usebackq tokens=1* delims=%__vof_sp%" %%i in ("%__vof_file%") do (
  if "%%~i" neq "" (
    set "__vof_key_=%%~i"
    if "%%~j" neq "" (
      set "__vof_val_=%%~j"
      if /i "!__vof_val_!" == "null" (
        call set "%%__vof_pre%%%%__vof_key_: =_%%="
      ) else if /i "!__vof_key_:~-3!" == "__i" (
        REM echo. "[!__vof_key_!] vars is num"
        call set /a "%%__vof_pre%%%%__vof_key_: =_%%=!__vof_val_!"
      ) else (
        call set "%%__vof_pre%%%%__vof_key_: =_%%=!__vof_val_!"
      )
      if %__vof_test_code% gtr 0 (
        call echo. " %%__vof_pre%%%%__vof_key_: =_%% = !__vof_val_! "
      )
    )
  )
)

:end_sucess

set "__vof_file="
set "__vof_pre="
set "__vof_pre_1="
set "__vof_sp="
set "__vof_key_="
set "__vof_err="
set /a __vof_test_code=0
if "%__vof_load_cout%" NEQ "" (
  set /a __vof_load_cout=%__vof_load_cout%+1
) else (
  set /a __vof_load_cout=1
)

exit /b 0

:end_with_err

if %__vof_test_code% gtr 0 (
  echo.
  echo. "--- --- error [%~nx0] "
  echo.
  echo. "%__vof_err%"
)

set "__vof_file="
set "__vof_pre="
set "__vof_pre_1="
set "__vof_sp="
set "__vof_key_="
set "__vof_err="
set /a __vof_test_code=0
if "%__vof_load_cout%" NEQ "" (
  set /a __vof_load_cout=%__vof_load_cout%+1
) else (
  set /a __vof_load_cout=1
)

exit /b 404