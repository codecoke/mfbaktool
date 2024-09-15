@echo off

set "_mbt_fcp_err_ify_info=%~1"

set "_log_ymd=%date:~,4%/%date:~5,2%/%date:~8,2% %time:~,2%:%time:~3,2%:%time:~-2%"

if "%_mbt_fcp_err_ify_info%" == "" (
  echo. "%%1 cannot by empty"
  goto :EOF
)

echo. "err: %_mbt_fcp_err_ify_info% ; %_log_ymd% ; %computername%" >> "_error.%~n0.log"