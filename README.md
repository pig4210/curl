# curl

�����ṩ��[Makefile.bat](./Makefile.bat)������ʹ��VS2013�����б���curl

����Ҫʹ������VS���������汾�����޸�֮

    set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
    set VPATH=%MyPath%\\curl-7.58.0

���ڸ����濼�ǣ���ʹ�ùٷ��ṩ��makefile����CURL

---- ---- ---- ----

## �ٷ�ʹ��VS����curl�ķ���

```
rem ��VC������(x64/x86)
cd curl-x.x.x\winbuild
nmake /f Makefile.vc mode=static VC=12
rem ���ɵ��ļ�����curl-x.x.x\builds\
```

---- ---- ---- ----

## unix����curl�ķ���

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

