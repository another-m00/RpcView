@echo off
setlocal enabledelayedexpansion

echo Finding Qt

REM This is probably useless, but i will leave it in, in case someone actually uses it this way
echo Searching ^%PATH^%
echo %path%|findstr /i ".*\\qt\\*" >nul||goto pfailed
REM sanityzing
set san=%path:(=^^(%
set san=%san:)=^^)%
set san=%san:^^=^^^^(%

for %%i in (^"%san:;=" "%^") do echo %%i|findstr /i ".*\\Qt\\*" >nul&&set qtpath=%%i&&goto found
REM for %%i in ("%san:;=" "%") do echo %%i|findstr /i ".*\\Java\\*" >nul&&set qtpath=%%i&&goto found

:pfailed
echo Searching drives... (using the 1st found)

set pref_paths0=\Qt


for %%B in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do 2>nul cd %%B:\ && set "drives=!drives! %%B"
set drives=!drives:~1!

for %%Q in (!drives!) do if exist %%Q:%pref_paths0% (
echo exist
pushd .
cd %%Q:%pref_paths0% && (popd & set qtpath=%%Q:%pref_paths0% & goto found)
echo undesired
popd
)

echo Qt could not be found on the default installation path.
choice /m:"Enter it manually?"
if %errorlevel%==2 exit /b
:manual
set /p qtpath=Qt path (without version):
if not exist %qtpath% echo Folder does not exist. (Ctrl+c to abort)&& goto manual
pushd .
echo %cd%
cd %qtpath% 2>nul|| (echo That is not a folder. & goto manual)
popd

:found
echo qt path found:%qtpath%
pause