@echo off


REM ..\localSites_g\shell\mfbaktool_dev_v2\mfbaktool\v2\fastcopy\4.2.2
REM del /q "test b1\*"
REM @echo off
REM  rmdir /s /q "C:\path\to\your\folder"

set "_dir_fcp=..\localSites_g\shell\mfbaktool_dev_v2\mfbaktool\v2\fastcopy\4.2.2\"

set "_exe_fcp=%_dir_fcp%fcp.exe"

set "_ini_file="

set "_srcfile=%~dpn0.srcfile.txt"

set "_target_1=C:\test_1\test b1\"

if not exist "%_exe_fcp%" echo. "fcp.exe not find"
if not exist "%_srcfile%" echo. "_srcfile not find"

REM echo "%~dpn0.srcfile.txt"

REM cmd noexist_only | update | diff

REM /postproc=

"%_exe_fcp%"  /cmd=diff /srcfile="%_srcfile%" /to="%_target_1%"

goto :EOF
REM  "%_exe_fcp%"  /cmd=diff /srcfile_w="files.txt

