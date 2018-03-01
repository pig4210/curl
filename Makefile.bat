
@echo off
setlocal

if "%1" == "" set PLAT=x64
if not "%1" == "" set PLAT=x86
set MyPath=%~dp0

rem ==== ==== ���·�MakeFile����� ==== ====
set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set VPATH=%MyPath%\\curl-7.58.0\\lib
set GPATH=%MyPath%\\%PLAT%

set CC=cl

rem /c      ֻ����
rem /MP     ���̱߳���
rem /GS-    ���ð�ȫ���
rem /Qpar   ���д���
rem /GL     ����ʱ��������
rem /analyze-   ���ñ�������
rem /W4     4������
rem /Gy     �ָ�����������
rem /Zi     ���õ�����Ϣ
rem /Gm-    �ر���С��������
rem /Ox     ����Ż�
rem /Fd     PDB�ļ����
rem /fp     ����
rem /errorReprot    �޴��󱨸�
rem /GF     �ַ�����
rem /WX-    �رվ������
rem /Zc-    ǿ��C++��׼
rem /GR-    �ر�RTTI
rem /Gd     Ĭ�ϵ���Լ�� cdecl
rem /Oy     ʡ��ָ֡��
rem /Oi     �����ڲ�����
rem /MT     ����ʱ
rem /EHsc   C++�쳣
rem /Fo     ���

set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo /Fo"%GPATH%/"

set MyCFLAGS= /I"%VPATH%" /I"%VPATH%/../include" /wd4127 /D "_LIB" /D "CURL_STATICLIB" /D "BUILDING_LIBCURL" /D "USE_IPV6" /D "USE_WINDOWS_SSPI" /D "USE_SCHANNEL"

if not "%1" == "" set MyCFLAGS= %MyCFLAGS% /D "_USING_V110_SDK71_"

rem /LTCG           ����ʱ���������
rem /MACHINE        x86/x64
rem /ERRORREPORT    ���󱨸�

set LFLAGS= /LTCG "ws2_32.lib" "wldap32.lib" "advapi32.lib" "crypt32.lib" /MACHINE:%PLAT% /ERRORREPORT:NONE /NOLOGO

set IncludePath=%MyPath%\\include

if not "%1" == "" echo ==== ==== ==== ==== Include�ļ�׼��...
if not "%1" == "" rd /S /Q "%IncludePath%"
if not "%1" == "" mkdir "%IncludePath%\\curl"
if not "%1" == "" copy "%VPATH%\\..\\include\\curl\\*.h" "%IncludePath%\\curl" >nul

echo ==== ==== ==== ==== ��ʼ����%PLAT%...

echo ==== ==== ==== ==== ׼�����뻷��(%PLAT%)...
cd /d %VCPath%
if "%1" == "" call vcvarsall.bat amd64
if not "%1" == "" call vcvarsall.bat x86

echo ==== ==== ==== ==== ׼��Ŀ��Ŀ¼(%PLAT%)...
if not exist "%GPATH%" mkdir %GPATH%
del /q "%GPATH%\\*.*"

cd /d %VPATH%

echo ==== ==== ==== ==== ���벢����LIB(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\curl.pdb" "%VPATH%\\*.c" "%VPATH%\\vtls\\*.c" "%VPATH%\\vauth\\*.c" >nul

if not %errorlevel%==0 goto compile_error

lib %LFLAGS% /OUT:"%GPATH%/curl.lib" "%GPATH%/*.obj" >nul

if not %errorlevel%==0 goto link_error

del "%GPATH%\\*.obj"

rem ==== ==== ==== ====

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo ���

goto end

:compile_error
echo !!!!!!!!����ʧ��!!!!!!!!
goto end

:link_error
echo !!!!!!!!����ʧ��!!!!!!!!
goto end

:end

pause >nul