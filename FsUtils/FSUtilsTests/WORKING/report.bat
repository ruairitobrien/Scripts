@echo off
:: Author: Ruairí O Brien
:: 07/02/2013
:: Script to iterate through all dtl files in the DTL_FILE_DIR and create seperate reports for each config file in the CONFIGS_DIR
:: The reports will be stored in the REPORTS_DIR in the format REPORTS_DIR\DTL_FILE_NAME\CONFIG_FILE_NAME

SET DTL_FILE_DIR=dtl_files
SET CONFIGS_DIR=configs
SET REPORTS_DIR=reports

call:IterateDTLFiles

goto End

:IterateDTLFiles
echo Iterating through dtl files

for /f %%F in ('dir /b %DTL_FILE_DIR%') do (call:GenerateReports "%%F") 

echo Finished iterating through dtl files
GOTO:EOF


:GenerateReports
echo Generating report files from scan using all configurations in configs folder.
for /f %%F in ('dir /b %CONFIGS_DIR%') do (call:CreateAndStoreReport "%%F" "%~1") 

echo Finished generating reports.
GOTO:EOF

:CreateAndStoreReport
if exist %REPORTS_DIR%\%~2\%~1( rmdir %REPORTS_DIR%\%~2\%~1 )
mkdir %REPORTS_DIR%\%~2\%~1
fsReport.exe -dtl "%DTL_FILE_DIR%\%~2" -cfg "%CONFIGS_DIR%\%~1" -rdir %REPORTS_DIR%\%~2\%~1
GOTO:EOF

:END
echo Script finished
pause
