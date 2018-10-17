# 这个 Makefile 用于使用 GNU make 在 Windows 编译 curl 静态库。
# https://www.lua.org

# 如果只是单纯的 clean ，则无需 环境 和 路径。
ifneq "$(MAKECMDGOALS)" "clean"

  # inc 的情况，无需环境。
  ifeq "$(MAKECMDGOALS)" "inc"
  else ifeq "$(MAKECMDGOALS)" "clean inc"
  else ifeq "$(MAKECMDGOALS)" "inc clean"
  	$(error Are you kidding me ?!)
  else
    ifeq "$(filter x64 x86,$(Platform))" ""
      $(error Need VS Environment)
    endif
  endif

  ifeq "$(SRCPATH)" ""
    $(error Need SRCPATH)
  endif

endif


.PHONY : all
all : lib inc
	@echo make done.

######## 以下参考 winbuild/Makefile.vc ########
## 改造不同目录。
-include $(SRCPATH)/lib/Makefile.inc
LIBCURL_OBJS:=$(CSOURCES:%.c=%.obj)
LIBCURL_OBJS:=$(LIBCURL_OBJS:vauth/%=%)
LIBCURL_OBJS:=$(LIBCURL_OBJS:vtls/%=%)
################################################

######## 以下参考 include/curl/Makefile.am ########
## 直接 include am 会有语法错误
pkginclude_HEADERS = \
	curl.h curlver.h easy.h mprintf.h stdcheaders.h multi.h \
	typecheck-gcc.h system.h
################################################


DESTPATH	:= $(Platform)

CC 			:= cl.exe
AR			:= lib.exe

######## CFLAGS
CFLAGS		= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /DWIN32 /DNDEBUG /D_UNICODE /DUNICODE /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo
CFLAGS		+= /D_LIB /DCURL_STATICLIB /DBUILDING_LIBCURL /DUSE_IPV6 /DUSE_WINDOWS_SSPI /DUSE_SCHANNEL
CFLAGS		+= /I"$(SRCPATH)/src" \
	/I"$(SRCPATH)/lib" \
	/I"$(SRCPATH)/include"
CFLAGS		+= /Fd"$(DESTPATH)/"
CFLAGS		+= /wd4127 /wd4090

ifeq "$(Platform)" "x86"
CFLAGS		+= /D_USING_V110_SDK71_
endif

######## ARFLAGS
ARFLAGS		= /LTCG /ERRORREPORT:NONE /NOLOGO /MACHINE:$(Platform)
ARFLAGS		+= /LIBPATH:"$(DESTPATH)"
ARFLAGS		+= "ws2_32.lib" "wldap32.lib" "advapi32.lib" "crypt32.lib"

# 源文件搜索路径
vpath %.c 	$(SRCPATH)/lib
vpath %.h 	$(SRCPATH)/lib

# 最终目标文件搜索路径
vpath %.obj	$(DESTPATH)
vpath %.lib $(DESTPATH)

######## INC
INCPATH			:= include
INCLUDES		:= $(pkginclude_HEADERS:%=$(INCPATH)/%)

.PHONY : inc
inc : $(INCLUDES)

$(INCPATH) :
	@mkdir "$@"

$(INCPATH)/%.h : $(SRCPATH)/include/curl/%.h | $(INCPATH)
	copy /y "$(?D)\\$(?F)" "$(@D)\\$(@F)"

######## 格式匹配规则
## 不使用更为通用的 %.obj : %.c 。一是考虑到需要建立对应目录，二是考虑到增加头文件依赖。
## 由于 curl 本身没有严格的头文件依赖，cl 又没有 -MM 的功能，所以就统一依赖。而为了尽量减少依赖，则把不同目录区分开来。
BASEH			:= $(pkginclude_HEADERS:%=$(SRCPATH)/include/curl/%)
%.obj : %.c $(LIB_HFILES) $(BASEH) | $(DESTPATH)
	$(CC) $(CFLAGS) /Fo"$(DESTPATH)/$(@F)" "$<"

%.obj : vauth/%.c $(LIB_VAUTH_HFILES) $(BASEH) | $(DESTPATH)
	$(CC) $(CFLAGS) /Fo"$(DESTPATH)/$(@F)" "$<"
	
%.obj : vtls/%.c $(LIB_VTLS_HFILES) $(BASEH) | $(DESTPATH)
	$(CC) $(CFLAGS) /Fo"$(DESTPATH)/$(@F)" "$<"

$(DESTPATH) :
	@mkdir "$@"

######## LIB
.PHONY : lib
lib : curl.lib

curl.lib : $(LIBCURL_OBJS)
	$(AR) $(ARFLAGS) /OUT:"$(DESTPATH)/$(@F)" $^

######## CLEAN
.PHONY : clean
clean :
	@if exist x64 @rd /s /q x64
	@if exist x86 @rd /s /q x86
	@if exist include @rd /s /q include