@echo off
setlocal enabledelayedexpansion

::fastcopy test ver 1


set "fastcopy_dir=fastcopy392"
set "fastcopy_exe=fastcopy392\fastcopy.exe"

set "arg_1=%~1"
if "%arg_1%" == "" set "arg_1=default_1"

set "f_log="
::set "to_dir=G:\\test_1\test-b\*"
set "to_dir=G:\\test_1\test-b\"
set "to_dir=G:\\test_1\test-b\"
::/cmd=(noexist_only| diff| update| force_copy| sync| move| delete)
:: /no_ui /no_exec
:: /srcfile="files.txt"
:: echo "%~dp0"

set "f_log=to_dir is %to_dir%\n arg_1 is %arg_1%"

if "%arg_1%" == "dir_clear" (

  set "f_log=!f_log!\n fastcopy_exe is %fastcopy_exe%"

  if not exist "%to_dir%" goto write_log

  if "%to_dir:~-1%" NEQ "\" set "to_dir=!to_dir!\"
  if "%to_dir:~-1%" NEQ "*" set "to_dir=!to_dir!*"

  set "f_log=!f_log!\n to_dir now is !to_dir!"
  
  "%fastcopy_exe%" /cmd=delete /auto_close /no_confirm_del "!to_dir!"


)


if "%arg_1%" == "copy_if_not" (
  set "f_log=!f_log!\n copy_if_not"

  if "%to_dir:~-1%" == "*" set "to_dir=%to_dir:~0,-1%"

  set "f_log=!f_log!\n %~dp0%fastcopy_dir%\fastcopy_cn.htm"

  "%fastcopy_exe%" /cmd=noexist_only /auto_close "%~dp0%fastcopy_dir%\fastcopy_cn.htm" /to="!to_dir!"

)

if "%arg_1%" == "list_diff" (
  set "f_log=!f_log!\n list_file_diff"

  if "%to_dir:~-1%" == "*" set "to_dir=%to_dir:~0,-1%"

  set "f_log=!f_log!\n %~dp0%fastcopy_dir%\fastcopy_cn.htm"

  set "src_file=%~dp0baklist.txt"

  set "f_log=!f_log!\n src_file: !src_file!"
  
  
  "%fastcopy_exe%" /cmd=diff /auto_close /srcfile="!src_file!" /to="!to_dir!"


)


::FastCopy.exe /cmd=diff /srcfile="G:\localSites_g\shell\mfbaktool_dev\v1\baklist.txt" /to="g:\test_1\test_b\"
::set "f_log=%f_log%\n3line"

:write_log

if "%f_log%" NEQ "" (
  echo.
  echo. "--- --- --- log --- --- ---"
  ::echo. "%f_log%"
  call:mlecho "%f_log%"
  echo.
)

goto:EOF

:mlecho
set text=%*
set nl=^


echo %text:\n=!nl!%
goto:eof

::if exist "%fastcopy%"  echo %arg_1%

