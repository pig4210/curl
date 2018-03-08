# curl

这里提供的[Makefile.bat](./Makefile.bat)，用于使用VS2017命令行编译Lua

如需要使用其它VS编译其它版本，请修改如下参考：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\curl-7.58.0

由于各方面考虑，不采用官方提供的方法编译curl

---- ---- ---- ----

## 官方使用VS编译curl的方法

## 官方使用VS命令行编译curl

```
rem 打开VC命令行(x64/x86)
cd curl-x.x.x\winbuild
nmake /f Makefile.vc mode=static VC=12
rem 生成的文件处于curl-x.x.x\builds\
```

## 官方使用VS编译curl

VS工程目录`curl-x.x.x/projects/Windows`，其下有不同版本的VS工程

---- ---- ---- ----

## unix编译curl的方法

```
wget http://curl.haxx.se/download/curl-7.50.3.tar.gz
tar zxvf curl-7.50.3.tar.gz
cd curl-7.50.3
./configure --prefix=/usr/local/curl --disable-shared --enable-static --without-libidn --without-ssl --without-librtmp --without-gnutls --without-nss --without-libssh2 --without-zlib --without-winidn --disable-ftp --disable-rtsp --disable-tftp --disable-ldap --disable-ldaps --disable-ipv6 --disable-telnet --disable-largefile --disable-smtp --disable-imap --disable-pop3
make
sudo make install

vi a.c

#include <curl/curl.h>

int main() {

printf("%s\n", curl_version());

return 0;

}

curl-config --static-libs

gcc a.c -static $(/usr/local/curl/bin/curl-config --static-libs --cflags)

file a.out

./a.out
```

