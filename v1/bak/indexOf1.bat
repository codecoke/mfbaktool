@echo off 
@REM setlocal 

setlocal enableDelayedExpansion

set "test=/name1;/name2/name3/;hhhhhh/c/" 
set "char=;" 

::1st test simply prints the result 
::call :lastIndexOf test char 

::2nd test stores the result in a variable 

::set "string=<ax2697:tenantDomain>org_12345678"
::set "x=%string:tenantDomain>=" & set "substring=%"
::echo %substring%



call :lastIndexOf test char rtn1 
echo rtn1=%rtn1% 

goto :EOF

:lastIndexOf strVar charVar [rtnVar] 
     

    :: Get the string values 
    set "lastIndexOf.char=!%~2!" 
    set "str=!%~1!" 
    set "chr=!lastIndexOf.char:~0,1!" 

    :: Determine the length of str - adapted from function found at: 
    :: http://www.dostips.com/DtCodeCmdLib.php#Function.strLen

    set "str2=.!str!" 
    set "len=0" 
    for /L %%A in (12,-1,0) do (
      set /a "len|=1<<%%A" 
      for %%B in (!len!) do if "!str2:~%%B,1!"=="" set /a "len&=~1<<%%A" 
    ) 

    :: Find the last occurrance of chr in str 
    for /l %%N in (%len% -1 0) do if "!str:~%%N,1!" equ "!chr!" (
      set rtn=%%N 
      goto :break 
    ) 
    set rtn=-1 

:break - Return the result if 3rd arg specified, else print the result 
    (
      endlocal 
      ::if "%~3" neq "" (set %~3=%rtn%) else echo %rtn% 
      if "%~3" neq "" set %~3=%rtn%
    ) 
goto :EOF
::exit /b 