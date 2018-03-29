@echo off

::begin
    setlocal
    pushd "%~dp0"
    set SUF=^>nul
    
::baseconfig
    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build

    for /d %%P in (.) do set ProjectName=%%~nP
    if %ProjectName%=="" (
        echo !!!!!!!! Empty project name !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got project name [ %ProjectName% ]
    setlocal enabledelayedexpansion
    for %%I in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set ProjectName=!ProjectName:%%I=%%I!
    setlocal disabledelayedexpansion

    set MyPath=%CD%

    for /d %%P in ("%MyPath%\\%ProjectName%*") do set VPATH=%%~fP
    if %VPATH%=="" (
        echo !!!!!!!! Src no found !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got source folder [ %VPATH% ]
    echo.

::biuldconfig
    set CC=cl
    set AR=lib

    set CFLAGS=/c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo 

    set ARFLAGS=/LTCG /ERRORREPORT:NONE /NOLOGO

::makeinclude
    echo ==== ==== ==== ==== Prepare include folder and files...
    set IncludePath=%MyPath%\\include

    if exist "%IncludePath%" rd /s /q "%IncludePath%" %SUF%
    if exist "%IncludePath%" (
        echo !!!!!!!! Can't clear include folder !!!!!!!!
        goto end
    )

    set IncludePath=%MyPath%\\include\\%ProjectName%
    set SIncludePath=%VPATH%\\include\\%ProjectName%

    md "%IncludePath%" %SUF%

    copy "%SIncludePath%\\*.h" "%IncludePath%" %SUF%

    echo.

::main
    call :do x64
    if not %errorlevel%==0 goto end
    call :do x86
    if not %errorlevel%==0 goto end

:end
    popd
    endlocal
    if %errorlevel%==0 echo done.
    pause >nul
    goto :eof

:do
    setlocal

::localbuildconfig
    set PLAT=%1
    set GPATH=%MyPath%\\%PLAT%

    set CFLAGS=%CFLAGS% /wd4127 /wd4006 /D "_LIB" /D "CURL_STATICLIB" /D "BUILDING_LIBCURL" /D "USE_IPV6" /D "USE_WINDOWS_SSPI" /D "USE_SCHANNEL"
    if "%PLAT%" == "x86" set CFLAGS=%CFLAGS% /D "_USING_V110_SDK71_"

    set ARFLAGS=%ARFLAGS% /MACHINE:%PLAT%

::prepare
    echo ==== ==== ==== ==== Prepare dest folder(%PLAT%)...

    if exist "%GPATH%" rd /s /q "%GPATH%" %SUF%
    if exist "%GPATH%" (
        echo !!!!!!!! Can't clear dest folder !!!!!!!!
        goto end
    )
    md "%GPATH%" %SUF%

    echo ==== ==== ==== ==== Prepare environment(%PLAT%)...

    cd /d "%VCPath%"
    if "%PLAT%" == "x64" (
        call vcvarsall.bat amd64 %SUF%
    ) else (
        call vcvarsall.bat x86 %SUF%
    )

    cd /d "%VPATH%"

::lib
    set CIN= /I"%VPATH%\\lib" /I"%VPATH%\\src" /I"%VPATH%\\include" "%VPATH%\\lib\\*.c" "%VPATH%\\lib\\vtls\\*.c" "%VPATH%\\lib\\vauth\\*.c" "%VPATH%\\src\\*.c"

    set COUT= /Fo"%GPATH%\\" /Fd"%GPATH%\\%ProjectName%.pdb"

    set ARIN= "%GPATH%\\*.obj" "ws2_32.lib" "wldap32.lib" "advapi32.lib" "crypt32.lib"

    set AROUT= /OUT:"%GPATH%\\%ProjectName%.lib"

    echo ==== ==== ==== ==== Building LIB(%PLAT%)...

    if not defined SUF echo on
    %CC% %CFLAGS% %COUT% %CIN% %SUF%
    @echo off
    if not %errorlevel%==0 goto compile_error

    if not defined SUF echo on
    %AR% %ARFLAGS% %AROUT% %ARIN% %SUF%
    @echo off
    if not %errorlevel%==0 goto link_error

    del "%GPATH%\\*.obj" %SUF%

    goto done

:compile_error
    echo !!!!!!!! Compile error !!!!!!!!
    goto done

:link_error
    echo !!!!!!!! Link error !!!!!!!!
    goto done

:done
    endlocal
    echo.
    exit /B %errorlevel%