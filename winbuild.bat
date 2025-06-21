@echo off
REM =============================
REM Yamata-no-OrochiC2 DLL Automated Builder
REM =============================

REM Set script to run from the core directory
cd /d "%~dp0\..\core"

REM Try to find MSBuild in common locations
set MSBUILD="%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
if not exist %MSBUILD% set MSBUILD="%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
if not exist %MSBUILD% set MSBUILD=MSBuild.exe

REM Build the DLL
%MSBUILD% nsfw.vcxproj /p:Configuration=Release /p:Platform=x64
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Build failed. Ensure Visual Studio Build Tools are installed and MSBuild is in your PATH.
    exit /b 1
)

REM Move the built DLL to the Release folder if needed
if exist x64\Release\nsfw.dll (
    echo [*] DLL built successfully: x64\Release\nsfw.dll
) else (
    echo [ERROR] DLL not found after build.
    exit /b 1
)

echo [*] Build process completed.
