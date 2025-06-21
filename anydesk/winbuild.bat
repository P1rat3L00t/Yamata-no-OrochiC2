@echo off
REM =============================
REM Yamata-no-OrochiC2 Windows Builder
REM =============================

REM Step 1: Build/process anydesk folder
cd /d "%~dp0"
echo [*] Building anydesk components...
if exist anydesk\build.bat (
    call anydesk\build.bat
) else (
    echo [!] No build.bat in anydesk, skipping explicit build.
)

REM Step 2: Build core (Visual Studio C++ project)
echo [*] Building core project...
cd core
if exist nsfw.vcxproj (
    if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe" (
        set MSBUILD="%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
    ) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe" (
        set MSBUILD="%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
    ) else (
        set MSBUILD=MSBuild.exe
    )
    %MSBUILD% nsfw.vcxproj /p:Configuration=Release /p:Platform=x64
) else (
    echo [!] nsfw.vcxproj not found in core, skipping build.
)
cd ..

REM Step 3: Process driver folder
echo [*] Processing driver folder...
if exist driver\build.bat (
    call driver\build.bat
) else (
    echo [!] No build.bat in driver, skipping explicit build.
)

echo [*] Build process completed.
