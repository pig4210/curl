
@echo off
setlocal

if "%1" == "" set PLAT=x64
if not "%1" == "" set PLAT=x86
set MyPath=%~dp0

rem ==== ==== 以下仿MakeFile定义宏 ==== ====
set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set VPATH=%MyPath%\\curl-7.58.0\\lib
set GPATH=%MyPath%\\%PLAT%

set CC=cl

rem /c      只编译
rem /MP     多线程编译
rem /GS-    禁用安全检查
rem /Qpar   并行代码
rem /GL     链接时代码生成
rem /analyze-   禁用本机分析
rem /W4     4级警告
rem /Gy     分隔链接器函数
rem /Zi     启用调试信息
rem /Gm-    关闭最小重新生成
rem /Ox     最大优化
rem /Fd     PDB文件输出
rem /fp     浮点
rem /errorReprot    无错误报告
rem /GF     字符串池
rem /WX-    关闭警告错误
rem /Zc-    强制C++标准
rem /GR-    关闭RTTI
rem /Gd     默认调用约定 cdecl
rem /Oy     省略帧指针
rem /Oi     启用内部函数
rem /MT     运行时
rem /EHsc   C++异常
rem /Fo     输出

set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo /Fo"%GPATH%/"

set MyCFLAGS= /I"%VPATH%" /I"%VPATH%/../include" /wd4127 /D "_LIB" /D "CURL_STATICLIB" /D "BUILDING_LIBCURL" /D "USE_IPV6" /D "USE_WINDOWS_SSPI" /D "USE_SCHANNEL"

if not "%1" == "" set MyCFLAGS= %MyCFLAGS% /D "_USING_V110_SDK71_"

rem /LTCG           链接时间代码生成
rem /MACHINE        x86/x64
rem /ERRORREPORT    错误报告

set LFLAGS= /LTCG "ws2_32.lib" "wldap32.lib" "advapi32.lib" "crypt32.lib" /MACHINE:%PLAT% /ERRORREPORT:NONE /NOLOGO

set IncludePath=%MyPath%\\include

if not "%1" == "" echo ==== ==== ==== ==== Include文件准备...
if not "%1" == "" rd /S /Q "%IncludePath%"
if not "%1" == "" mkdir "%IncludePath%\\curl"
if not "%1" == "" copy "%VPATH%\\..\\include\\curl\\*.h" "%IncludePath%\\curl" >nul

echo ==== ==== ==== ==== 开始编译%PLAT%...

echo ==== ==== ==== ==== 准备编译环境(%PLAT%)...
cd /d %VCPath%
if "%1" == "" call vcvarsall.bat amd64
if not "%1" == "" call vcvarsall.bat x86

echo ==== ==== ==== ==== 准备目标目录(%PLAT%)...
if not exist "%GPATH%" mkdir %GPATH%
del /q "%GPATH%\\*.*"

cd /d %VPATH%

echo ==== ==== ==== ==== 编译并生成LIB(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\curl.pdb" "%VPATH%\\*.c" "%VPATH%\\vtls\\*.c" "%VPATH%\\vauth\\*.c" >nul

if not %errorlevel%==0 goto compile_error

lib %LFLAGS% /OUT:"%GPATH%/curl.lib" "%GPATH%/*.obj" >nul

if not %errorlevel%==0 goto link_error

del "%GPATH%\\*.obj"

rem ==== ==== ==== ====

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo 完成

goto end

:compile_error
echo !!!!!!!!编译失败!!!!!!!!
goto end

:link_error
echo !!!!!!!!链接失败!!!!!!!!
goto end

:end

pause >nul