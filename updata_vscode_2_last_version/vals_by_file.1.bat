@echo off

@REM read value list from file.txt
@REM call "%share_c_cmd_module%\rff.1.bat" "%~dp0\file.txt" val_pre val_sp
@REM "val_pre" "-" means "no_pre"; "" means "filename_pre"
@REM "val_sp" "default: blank_"


set "__vbf_file=%~1"
set "__vbf_pre=%~2"
set "__vbf_sp=%~3"
set "__vbf_err="


set /a __vbf_test_code=0

if "%mf_mod_cmd_test_code%" neq "" (
  set /a __vbf_test_code=%mf_mod_cmd_test_code%
)


if "%__vbf_sp%" == "" set "__vbf_sp=="

if "%__vbf_file%" == "" (
  set "__vbf_err=file name is null"
) else (
  if not exist "%__vbf_file%" (
    set "__vbf_err=not find [%__vbf_file%]"
  )
)

if "%__vbf_err%" neq "" goto end_with_err

if "%__vbf_pre%" == "" (
  set "__vbf_pre=%~n1"
) else (
  if "%__vbf_pre%" == "-" (
    set "__vbf_pre="
  )
)

if "%__vbf_pre%" neq "" (
  set "__vbf_pre=%__vbf_pre: =_%"

  set "__vbf_pre=%__vbf_pre:.=_%"
)

if "%__vbf_pre%" neq "" (
  if "%__vbf_pre:~-1%" neq "_" (
    set "__vbf_pre=%__vbf_pre%_"
  )
)

for /f "usebackq tokens=1* delims=%__vbf_sp%" %%i in ("%__vbf_file%") do (
  if "%%~i" neq "" (
    if "%%~j" neq "" (
      set "__vbf_key_=%%~i"
      call set "%%__vbf_pre%%%%__vbf_key_: =_%%=%%~j"
      if %__vbf_test_code% gtr 0 (
        call echo "%%__vbf_pre%%%%__vbf_key_: =_%%=%%~j"
      )
    )
  )
)

:end_sucess

set "__vbf_file="
set "__vbf_pre="
set "__vbf_sp="
set "__vbf_err="
set "__vbf_key_="
set /a __vbf_test_code=0

exit /b 0

:end_with_err
if %__vbf_test_code% gtr 0 (
  echo "--- error --- : %__vbf_err%"
)
exit /b 404