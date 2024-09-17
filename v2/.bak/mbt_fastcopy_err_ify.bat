@echo off

set "mbt_fcp_err_ify_info=%~1"
REM set "mbt_fcp_err_ify_log=_error.%~n0.log"
set "log_ymd=%date:~,4%/%date:~5,2%/%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"


if "%mbt_fcp_err_ify_info%" == "" (
  echo. "%%1 cannot by empty"
  goto :EOF
)

echo. "err:%mbt_fcp_err_ify_info% ; %log_ymd% ; %computername%" >> "_error.%~n0.log"