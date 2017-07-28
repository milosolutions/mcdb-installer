@echo OFF

if %1 == -h (
  echo Usage: windowsBuild.bat qtIfwPath [doxygenPath]
  echo This will only work when invoked from root repo dir
  echo Builds all subproject documentation, cleans up build dirs, creates the 
  echo Milo DB installer
  pause
  goto :EOF
)

set argC=0
for %%x in (%*) do Set /A argC+=1

echo Argument count is %argC%

if "%argC%" LSS "1" (
  echo "Illegal number of parameters: %argC%. See -h"
  pause
  goto :EOF
)

set IFW=%1
set DOXY=%2

echo "Removing build artifacts from base package"
for /d %%G in ("packages\com.milosolutions.newprojecttemplate\build-*") do (rd /s /q "%%~G")

call :prepareSubproject packages\com.milosolutions.mbarcodescanner\data\milo\mbarcodescanner
call :prepareSubproject packages\com.milosolutions.mscripts\data\milo\mscripts
call :prepareSubproject packages\com.milosolutions.mcharts\data\milo\mcharts
call :prepareSubproject packages\com.milosolutions.mconfig\data\milo\mconfig
call :prepareSubproject packages\com.milosolutions.mcrypto\data\milo\mcrypto
call :prepareSubproject packages\com.milosolutions.mlog\data\milo\mlog
call :prepareSubproject packages\com.milosolutions.mrestapi\data\milo\mrestapi
call :prepareSubproject packages\com.milosolutions.newprojecttemplate\data

rem Get date on Windows. Code adapted from http://ss64.com/nt/syntax-getdate.html
rem Yes, this is complicated. Blame Microsoft, not me.
:: Check WMIC is available
WMIC.EXE Alias /? >NUL 2>&1 || GOTO s_error

:: Use WMIC to retrieve date and time
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
   IF "%%~L"=="" goto s_done
      Set _yyyy=%%L
      Set _mm=00%%J
      Set _dd=00%%G
      Set _hour=00%%H
      SET _minute=00%%I
)
:s_done

:: Pad digits with leading zeros
Set _mm=%_mm:~-2%
Set _dd=%_dd:~-2%
Set _hour=%_hour:~-2%
Set _minute=%_minute:~-2%

echo Building installer
%IFW% -v -c config\config.xml -p packages build\miloinstaller_%_yyyy%.%_mm%.%_dd%.exe 
echo Done. .bat syntax sucks.
pause
goto :EOF

:s_error
  Echo GetDate.cmd
  Echo Displays date and time independent of OS Locale, Language or date format.
  Echo Requires Windows XP Professional, Vista or Windows 7
  Echo Returns 6 environment variables containing isodate,Year,Month,Day,hour and minute.
  Echo Based on the sorted date code by Rob van der Woude.
  pause
  goto :EOF

rem Takes one argument: path to subproject
:prepareSubproject
  echo Subproject %1
  set TEMP=%CD%
  cd %1
  echo Removing build artifacts
  for /d %%G in ("build-*") do (rd /s /q "%%~G")
  for %%G in ("*.pro.user") do (del "%%~G")
  if not "%DOXY%" == "" (
	echo Building documentation
	for %%G in ("*.doxyfile") do (%DOXY% "%%~G")
  )
  echo Done
  cd %TEMP%
