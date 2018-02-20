set NowVer=.\curl-7.58.0

rd          /S  /Q          .\src
mklink      /H /J           .\src               %NowVer%\lib

rd          /S /Q           .\include
mklink      /H /J           .\include           %NowVer%\include
pause
