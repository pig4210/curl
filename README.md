﻿# curl

curl 提供了 Windows 下的编译支持，具体参考相关说明。

本工程是一个特化编译 For Windows 。

---- ---- ---- ----

## 特化编译

参考 curl 提供的 windows 下的编译手段，实现特化 Makefile 。

`Makefile` 使用 GNU make 编译 curl 。

`Makefile.bat` 检测当前环境，决定编译结果：

  - 在 对应的编译环境 下，编译对应平台版本，有编译回显。
  - 无编译环境时，自行编译 x64 & x86 版本，无编译回显。

---- ---- ---- ----

## NMake编译

curl 支持 NMake 编译。生成结果：`./builds/*lib/libcurl.lib` 。

```cmd
cd /d C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
call vcvarsall.bat amd64
cd /d ./curl/curl-7.61.1/winbuild
nmake /f Makefile.vc mode=static
```

---- ---- ---- ----

## VisualStudio编译

curl 支持 VisualStudio 编译。

目录 `./projects/Windows` ，其下有不同版本的 VS 工程。
