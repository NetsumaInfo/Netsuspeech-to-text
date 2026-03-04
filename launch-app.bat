@echo off
setlocal

cd /d "%~dp0"

set "LIBCLANG_PATH="
set "VULKAN_SDK="
set "CMAKE_BIN="

where bun >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Bun is not installed or not available in PATH.
  echo Install Bun from https://bun.sh/ and run this script again.
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo [INFO] Installing dependencies...
  call bun install
  if errorlevel 1 goto :error
)

if not exist "src-tauri\resources\models" (
  mkdir "src-tauri\resources\models"
  if errorlevel 1 goto :error
)

if not exist "src-tauri\resources\models\silero_vad_v4.onnx" (
  echo [INFO] Downloading required VAD model...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; Invoke-WebRequest -Uri 'https://blob.handy.computer/silero_vad_v4.onnx' -OutFile 'src-tauri/resources/models/silero_vad_v4.onnx'"
  if errorlevel 1 goto :error
)

call :find_libclang
if not defined LIBCLANG_PATH (
  echo [INFO] libclang.dll not found. Installing LLVM...
  call :install_llvm
  if errorlevel 1 (
    echo [ERROR] LLVM installation failed.
    echo Install LLVM manually, then run this script again.
    pause
    exit /b 1
  )
  call :find_libclang
)

if not defined LIBCLANG_PATH (
  echo [ERROR] LLVM was installed but libclang.dll is still not found.
  echo Set LIBCLANG_PATH to the folder that contains libclang.dll, then run this script again.
  pause
  exit /b 1
)

call :find_vulkan_sdk
if not defined VULKAN_SDK (
  echo [INFO] Vulkan SDK not found. Installing Vulkan SDK...
  call :install_vulkan_sdk
  if errorlevel 1 (
    echo [ERROR] Vulkan SDK installation failed.
    echo Install the Vulkan SDK manually, then run this script again.
    pause
    exit /b 1
  )
  call :find_vulkan_sdk
)

if not defined VULKAN_SDK (
  echo [ERROR] Vulkan SDK was installed but VULKAN_SDK is still not found.
  echo Set VULKAN_SDK to the SDK folder, then run this script again.
  pause
  exit /b 1
)

call :ensure_cmake
if errorlevel 1 (
  echo [ERROR] CMake is required but was not found.
  echo Install CMake manually, then run this script again.
  pause
  exit /b 1
)

echo [INFO] Using LIBCLANG_PATH=%LIBCLANG_PATH%
echo [INFO] Using VULKAN_SDK=%VULKAN_SDK%
where cmake >nul 2>&1
if not errorlevel 1 echo [INFO] CMake is available

echo [INFO] Launching application...
call bun run tauri dev
if errorlevel 1 goto :error

exit /b 0

:find_libclang
for %%D in (
  "C:\Program Files\LLVM\bin"
  "C:\Program Files (x86)\LLVM\bin"
  "%ProgramFiles%\LLVM\bin"
  "%ProgramFiles(x86)%\LLVM\bin"
) do (
  if exist "%%~D\libclang.dll" (
    set "LIBCLANG_PATH=%%~D"
    goto :eof
  )
)
goto :eof

:find_vulkan_sdk
if defined VULKAN_SDK (
  if exist "%VULKAN_SDK%\Lib\vulkan-1.lib" goto :eof
  if exist "%VULKAN_SDK%\Lib\vk.xml" goto :eof
  set "VULKAN_SDK="
)

for %%R in (
  "C:\VulkanSDK"
  "%ProgramFiles%\VulkanSDK"
  "%ProgramFiles(x86)%\VulkanSDK"
) do (
  if exist "%%~R" (
    for /f "delims=" %%D in ('dir /b /ad /o-n "%%~R" 2^>nul') do (
      if exist "%%~R\%%D\Lib\vulkan-1.lib" (
        set "VULKAN_SDK=%%~R\%%D"
        goto :eof
      )
      if exist "%%~R\%%D\Lib\vk.xml" (
        set "VULKAN_SDK=%%~R\%%D"
        goto :eof
      )
    )
  )
)
goto :eof

:ensure_cmake
where cmake >nul 2>&1
if not errorlevel 1 exit /b 0

call :find_cmake_bin
if defined CMAKE_BIN (
  set "PATH=%CMAKE_BIN%;%PATH%"
  where cmake >nul 2>&1
  if not errorlevel 1 exit /b 0
)

echo [INFO] CMake not found. Installing CMake...
call :install_cmake
if errorlevel 1 exit /b 1

call :find_cmake_bin
if defined CMAKE_BIN (
  set "PATH=%CMAKE_BIN%;%PATH%"
)

where cmake >nul 2>&1
if errorlevel 1 exit /b 1

exit /b 0

:find_cmake_bin
set "CMAKE_BIN="
if exist "C:\Program Files\CMake\bin\cmake.exe" (
  set "CMAKE_BIN=C:\Program Files\CMake\bin"
  goto :eof
)
if exist "C:\Program Files (x86)\CMake\bin\cmake.exe" (
  set "CMAKE_BIN=C:\Program Files (x86)\CMake\bin"
  goto :eof
)
goto :eof

:install_llvm
where winget >nul 2>&1
if errorlevel 1 (
  echo [ERROR] winget is not available on this machine.
  exit /b 1
)

winget install LLVM.LLVM --accept-package-agreements --accept-source-agreements --silent
if errorlevel 1 exit /b 1

exit /b 0

:install_vulkan_sdk
where winget >nul 2>&1
if errorlevel 1 (
  echo [ERROR] winget is not available on this machine.
  exit /b 1
)

winget install KhronosGroup.VulkanSDK --accept-package-agreements --accept-source-agreements --silent
if errorlevel 1 exit /b 1

exit /b 0

:install_cmake
where winget >nul 2>&1
if errorlevel 1 (
  echo [ERROR] winget is not available on this machine.
  exit /b 1
)

winget install Kitware.CMake --accept-package-agreements --accept-source-agreements --silent
if errorlevel 1 exit /b 1

exit /b 0

:error
echo.
echo [ERROR] The application failed to start.
pause
exit /b 1
