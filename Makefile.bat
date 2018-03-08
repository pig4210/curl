@echo off

:begin
    setlocal
    set MyPath=%~dp0

:config
    if "%1" == "" (
      set PLAT=x64
    ) else (
      set PLAT=x86
    )

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\curl-7.58.0
    set GPATH=%MyPath%\\%PLAT%

    set CC=cl
    set AR=lib
    set LNK=link

:compileflags
    set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo /Fo"%GPATH%\\"

    set MyCFLAGS= /I"%VPATH%\\lib" /I"%VPATH%\\src" /I"%VPATH%\\include" /wd4127 /D "_LIB" /D "CURL_STATICLIB" /D "BUILDING_LIBCURL" /D "USE_IPV6" /D "USE_WINDOWS_SSPI" /D "USE_SCHANNEL"

    if not "%1" == "" set MyCFLAGS=%MyCFLAGS% /D "_USING_V110_SDK71_"

:arflags
    set ARFLAGS= /LTCG "ws2_32.lib" "wldap32.lib" "advapi32.lib" "crypt32.lib" /MACHINE:%PLAT% /ERRORREPORT:NONE /NOLOGO

:makeinclude
    set IncludePath=%MyPath%\\include

    if not "%1" == "" (
        echo ==== ==== ==== ==== Prepare Include Folder and Files...
        rd /S /Q "%IncludePath%"
        mkdir "%IncludePath%\\curl"

        copy "%VPATH%\\include\\curl\\*.h" "%IncludePath%\\curl" >nul

        echo.
    )

:start
    echo ==== ==== ==== ==== Start compiling %PLAT%...

    echo ==== ==== ==== ==== Prepare environment(%PLAT%)...
    cd /d %VCPath%
    if "%1" == "" (
        call vcvarsall.bat amd64 >nul
    ) else (
        call vcvarsall.bat x86 >nul
    )

    echo ==== ==== ==== ==== Prepare dest folder(%PLAT%)...
    if not exist "%GPATH%" mkdir %GPATH%
    del /q "%GPATH%\\*.*"

    cd /d %VPATH%

:lib
    echo ==== ==== ==== ==== Building LIB(%PLAT%)...

    %CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\curl.pdb" "%VPATH%\\lib\\*.c" "%VPATH%\\lib\\vtls\\*.c" "%VPATH%\\lib\\vauth\\*.c" "%VPATH%\\src\\*.c" >nul
    if not %errorlevel%==0 goto compile_error

    %AR% %ARFLAGS% /OUT:"%GPATH%\\curl.lib" "%GPATH%\\*.obj" >nul
    if not %errorlevel%==0 goto link_error

    del "%GPATH%\\*.obj"

:done
    echo.

    endlocal

    if "%1" == "" (
        cmd /C %~f0 x86
    ) else (
        exit /B 0
    )

    echo done.

    goto end

:compile_error
    echo !!!!!!!!Compile error!!!!!!!!
    goto end

:link_error
    echo !!!!!!!!Link error!!!!!!!!
    goto end

:end
    pause >nul