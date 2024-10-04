@echo off

REM setlocal enabledelayedexpansion

REM mfbaktool exeute job
REM run_job_2.bat
REM version 2.2.1
REM w(a)ibar.cn 2024-09-22 11:37:45

REM inputs arguments
REM run_job_2.bat 
REM run_[ac_type]_[_mbt_version].bat
REM   "[ac_name]" "[caller_bat]"      "[_log_file]"
REM   "f2"        "mbt_2_job_f2.bat"  "c:\test 1\log.txt"


REM --- --- need no modification ---



REM add write to log_info
REM set "mbt_log_note="



set "_arg_1=%~1"
set "_arg_2=%~2"


REM init
set "_mbt_err="
set "_is_str_cludes="
set "_log_info="
set "_mbt_suatus=ok "

set /a _mbt_debug_level_stop=3

echo. & echo. "--- --- %~n0 --- ---" & echo.

echo. "_arg_1:%_arg_1%"
echo. "_arg_2:%_arg_2%"
echo.
echo. "_mbt_debug_level_stop:%_mbt_debug_level_stop%"

echo. "mbt_caller_bat:%mbt_caller_bat%"
echo. "mbt_caller_dir:%mbt_caller_dir%"

echo. "mbt_debug_level__i:%mbt_debug_level__i%"
echo. "mbt_sucess_sleep__i:%mbt_sucess_sleep__i%"
echo. "mbt_log_lines_max__i:%mbt_log_lines_max__i%"

echo.
echo. "mbt_ac_name:%mbt_ac_name%"
echo. "_mbt_ac_dir:%_mbt_ac_dir%"
echo.


echo. "mbt_write_log_bat:%mbt_write_log_bat%"
echo. "mbt_fastcopy_ini:%mbt_fastcopy_ini%"
echo. "mbt_fpc_exec_name:%mbt_fpc_exec_name%"
echo. "mbt_fpc_exec_post:%mbt_fpc_exec_post%"
REM echo. "mbt_fpc_exec_err_name:%mbt_fpc_exec_err_name%"
echo. "mbt_fpc_exec_err_bat:%mbt_fpc_exec_err_bat%"
echo. "mbt_log_file:%mbt_log_file%"
echo. "mbt_log_note:!mbt_log_note!"



goto :EOF

