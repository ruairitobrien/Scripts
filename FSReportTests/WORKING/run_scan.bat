@echo off

:: Variables
SET ROOT_TEST_SCAN_LOCATION=C:\fsReportTest
SET DTL_FILE=dtl_files\fscan.dtl
SET SCAN_TAG=FSMA_RPT


:: Script needs to run in admin mode.
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"


REM --> Create some test files, run a scan.
call:CreateTestFiles
call:RunScan


goto End

:CreateTestFiles
if exist %ROOT_TEST_SCAN_LOCATION% (
echo Test files already exist.
) else (
echo Creating test files
mkdir %ROOT_TEST_SCAN_LOCATION%

xcopy /E Test_files %ROOT_TEST_SCAN_LOCATION%

mklink /h %ROOT_TEST_SCAN_LOCATION%\Pic2\A.jpg %ROOT_TEST_SCAN_LOCATION%\Pictures\Desert.jpg
mklink %ROOT_TEST_SCAN_LOCATION%\Pic2\B.jpg %ROOT_TEST_SCAN_LOCATION%\Pictures\Jellyfish.jpg
mklink /h %ROOT_TEST_SCAN_LOCATION%\Pic2\C.jpg %ROOT_TEST_SCAN_LOCATION%\Pictures\Lighthouse.jpg
mklink /h %ROOT_TEST_SCAN_LOCATION%\Pic2\D.jpg %ROOT_TEST_SCAN_LOCATION%\Pictures\Desert.jpg
mklink %ROOT_TEST_SCAN_LOCATION%\Pic2\E.jpg %ROOT_TEST_SCAN_LOCATION%\Pictures\Lighthouse.jpg

mklink /d %ROOT_TEST_SCAN_LOCATION%\Junctions\Pic_Sym %ROOT_TEST_SCAN_LOCATION%\Pictures
mklink /J %ROOT_TEST_SCAN_LOCATION%\Junctions\Texts_Junc %ROOT_TEST_SCAN_LOCATION%\Texts
mklink /J %ROOT_TEST_SCAN_LOCATION%\Junctions\Pic2_Junc %ROOT_TEST_SCAN_LOCATION%\Pic2
mkdir %ROOT_TEST_SCAN_LOCATION%\fsReportTest2

xcopy /E Test_files %ROOT_TEST_SCAN_LOCATION%\fsReportTest2

mklink /h %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic2\A.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Desert.jpg
mklink %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic2\B.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Jellyfish.jpg
mklink /h %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic2\C.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Lighthouse.jpg
mklink /h %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic2\D.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Desert.jpg
mklink %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic2\E.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Lighthouse.jpg

mklink /d %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Junctions\Pic_Sym %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures
mklink /d %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Junctions\Texts_Junc %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Texts

mkdir %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic3
copy %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Desert.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic3\B.jpg
mklink /d %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic3\Pic_Sym %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures
mklink /h %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic3\C.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Lighthouse.jpg
mklink /h %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pic3\D.jpg %ROOT_TEST_SCAN_LOCATION%\fsReportTest2\Pictures\Lighthouse.jpg
mkdir %ROOT_TEST_SCAN_LOCATION%\empty1
mkdir %ROOT_TEST_SCAN_LOCATION%\empty2
echo Finished creating test files.
)
GOTO:EOF

:RunScan
echo Running a scan on test files.

fsScan "%ROOT_TEST_SCAN_LOCATION%" -dtl %DTL_FILE% -tag %SCAN_TAG%

echo Finished running scan on test files.
GOTO:EOF

:END
echo Script finished
pause