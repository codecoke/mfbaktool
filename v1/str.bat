@echo off
setlocal enabledelayedexpansion

set "a=Z:\test_1\mfbak_log\mf.log.test1.txt"
set "a=Z!!\test_1\mfbak_log\mf.log.test1.txt"
set "a=Z##c test_1#mfbak_log##mf.log.test1.txt"

set "mbt_ac_dir=%mbt_ac_dir:#=\%"

::set "a=!a:~=:!"
set "d=#"

if /i "%a:~1,2%" EQU "##" set "a=%a:~0,1%:\%a:~3%"
set "a=!a:%d%=\!"

echo "%a%"

::set "b=\\r3.lan\transmission2\"
::set "b=##r3.lan#transmission#"
::
::set "b=%b:#=\%"
::echo "%b%"
::if exist %b% echo "yes b"

echo "%a%"

@REM echo "%a:~1,2%"
@REM set "a=!a:#=\!"
@REM set "a=!a:$=:!"
@REM echo "a is !a:$=:!"


goto :EOF




:ck_path

  echo. "--- --- ---"
  echo. "%%~1: %~1"
  echo. "path %%~dp1: %~dp1"
  echo. "file %%~nx1: %~nx1"
  echo. ".txt %%~x1: %~x1"
  echo. "--- --- ---"



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