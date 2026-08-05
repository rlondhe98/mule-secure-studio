@echo off
setlocal EnableExtensions

REM =========================================================
REM Only this value is static. Update it once if the JAR moves.
REM =========================================================
set "JAR_PATH=C:\Users\qlg9915\OneDrive - Takeda\Documents\Takeda documents\MuleSoft\Secure properties jar\secure-properties-tool-j17.jar"

REM =========================================================
REM Validate the fixed JAR location before asking for inputs.
REM =========================================================
if not exist "%JAR_PATH%" (
    echo.
    echo ERROR: Secure Properties Tool JAR was not found.
    echo Expected location:
    echo %JAR_PATH%
    echo.
    echo Update JAR_PATH in this batch file if the JAR was moved.
    pause
    exit /b 1
)

:START
cls
echo =========================================================
echo            MuleSoft Secure Properties Tool
echo =========================================================
echo.
echo JAR location:
echo %JAR_PATH%
echo.

REM Ask for the action
set "ACTION="
set /p "ACTION=Action [decrypt/encrypt] (default: decrypt): "

if "%ACTION%"=="" set "ACTION=decrypt"

if /I not "%ACTION%"=="decrypt" if /I not "%ACTION%"=="encrypt" (
    echo.
    echo ERROR: Action must be decrypt or encrypt.
    pause
    goto START
)

REM Ask for encryption algorithm
set "ALGORITHM="
set /p "ALGORITHM=Algorithm (default: AES): "

if "%ALGORITHM%"=="" set "ALGORITHM=AES"

REM Ask for encryption mode
set "MODE="
set /p "MODE=Mode (default: CBC): "

if "%MODE%"=="" set "MODE=CBC"

REM Ask for encryption key
set "KEY="
set /p "KEY=Encryption key: "

if "%KEY%"=="" (
    echo.
    echo ERROR: The encryption key cannot be empty.
    pause
    goto START
)

REM =========================================================
REM Open Windows file picker to select the input YAML file.
REM Pick-InputFile.ps1 must be in the same folder as this BAT file.
REM =========================================================
set "INPUT_FILE="

for /f "usebackq delims=" %%I in (`
    powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Pick-InputFile.ps1"
`) do set "INPUT_FILE=%%I"

if not defined INPUT_FILE (
    echo.
    echo No input file was selected. Operation cancelled.
    pause
    goto START
)

if not exist "%INPUT_FILE%" (
    echo.
    echo ERROR: The selected input file was not found:
    echo %INPUT_FILE%
    pause
    goto START
)

echo.
echo Selected input file:
echo %INPUT_FILE%


REM =========================================================
REM Open Windows Save As dialog for the output file.
REM =========================================================
set "OUTPUT_FILE="

for /f "usebackq delims=" %%I in (`
    powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Pick-OutputFile.ps1"
`) do set "OUTPUT_FILE=%%I"

if not defined OUTPUT_FILE (
    echo.
    echo No output file was selected. Operation cancelled.
    pause
    goto START
)

echo.
echo Selected output file:
echo %OUTPUT_FILE%


echo.
echo =========================================================
echo Review settings
echo =========================================================
echo Action      : %ACTION%
echo Algorithm   : %ALGORITHM%
echo Mode        : %MODE%
echo Input file  : %INPUT_FILE%
echo Output file : %OUTPUT_FILE%
echo.

set "CONFIRM="
set /p "CONFIRM=Continue? [Y/N]: "

if /I not "%CONFIRM%"=="Y" (
    echo.
    echo Operation cancelled.
    pause
    goto START
)

echo.
echo Running secure properties tool...
echo.

java -cp "%JAR_PATH%" com.mulesoft.tools.SecurePropertiesTool file %ACTION% %ALGORITHM% %MODE% "%KEY%" "%INPUT_FILE%" "%OUTPUT_FILE%"

if errorlevel 1 (
    echo.
    echo =========================================================
    echo FAILED: The secure properties command returned an error.
    echo =========================================================
) else (
    echo.
    echo =========================================================
    echo SUCCESS: File created successfully.
    echo Output: %OUTPUT_FILE%
    echo =========================================================
)

echo.
set "RUN_AGAIN="
set /p "RUN_AGAIN=Run another operation? [Y/N]: "

if /I "%RUN_AGAIN%"=="Y" goto START

endlocal
