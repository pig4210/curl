# curl

这里提供的[Makefile.bat](./Makefile.bat)，使用VS2017命令行编译项目

如需使用其它VS，请修改如下配置：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build

源代码目录自动定位，如需指定其它源代码目录，请修改或替换如下代码的VPATH：

    for /d %%P in ("%MyPath%\\%ProjectName%*") do set VPATH=%%~fP

由于各方面考虑，不采用官方提供的方法编译

---- ---- ---- ----

## 官方使用VS编译curl的方法

- 官方使用VS命令行编译curl

  1. 打开VC命令行(x64/x86)
  2. 进入winbuild目录。`cd curl-x.x.x\winbuild`
  3. 编译curl。`nmake /f Makefile.vc mode=static VC=12`
  4. 生成的文件处于`curl-x.x.x\builds\`

- 官方使用VS编译curl

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

