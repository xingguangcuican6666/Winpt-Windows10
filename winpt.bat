@echo off
::apt for windows
set sdb=%cd%
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
    echo 32λ����ϵͳ
    set systemfie="x86"
) else (
    echo 64λ����ϵͳ
    set systemfie="x86_64"
)
if not exist ok.lock (
    python .\check.py
    powershell Invoke-WebRequest https://www.python.org/ftp/python/3.11.0/python-3.11.0.exe
    start /wait python-3.11.0.exe /q
    python-3.11.0.exe
    exit
    if not exist python-3.11.0.exe (
        echo =================================
        echo ��������������
        echo ERROR 404
        echo =================================
        timeout 5
        goto q
    )
    echo 1 > ok.lock
    exit
) else (
    if "%1" == "" goto 1
    if "%1" == "clear" goto clear
    if "%1" == "update" goto upd
    if "%1" == "upd" goto upd
    if "%1" == "in" goto in
    if "%1" == "install" goto in
    if "%1" == "download" goto dl
    if "%1" == "dl" goto dl
)
:1
echo ==================================================
echo �÷�:
echo winpt [install/remove/update/upgrade/download/in/re/upd/upg/dl] [package name]
echo install/in  ��װһ�����������
echo remove/re   ж��һ�����������
echo update/upd  �������Դ�����ļ�
echo upgrade/upg �������������
echo download/dl ���������������װ
echo clear ������л�������
echo.
echo ʵ����
echo winpt instal1 wechat
echo ===================================================
goto q
:dl
for /f "delims=" %%i in ('powershell cat mirrorlist.json ^| python -c "import sys, json; print(json.load(sys.stdin)['Server'])"') do set Server=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\w\list.json ^| python install.py --ins %2') do set ins=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\list.json ^| python install.py --ins %2') do set ins1=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\%2\version.json ^| python install.py --ins %systemfie%') do set ins2=%%i
if not exist package.json (
    echo ����winpt dl
    goto q

)
if "%ins%" == "%2" (
    .\aria2-1.36.0-win-32bit-build1\aria2c.exe "%Server%"repo/iso/"%2"/"%ins2%"


) else (
    .\aria2-1.36.0-win-32bit-build1\aria2c.exe "%Server%"repo/w/"%ins%"
    echo ���
)
:upd
for /f "delims=" %%i in ('powershell cat .\mirrorlist.json ^| python -c "import sys, json; print(json.load(sys.stdin)['Server'])"') do set Server=%%i
echo ��ȡ1:%Server%package.json
curl %Server%package.json > .\mirror\package.json > nul
for /f "delims=" %%i in ('powershell cat package.json ^| python -c "import sys, json; print(json.load(sys.stdin)['repow'])"') do set repow=%%i
mkdir .\mirror\w\
echo ��ȡ2:%Server%%repow%
curl %Server%%repow% > .\mirror\w\list.json > nul
for /f "delims=" %%i in ('powershell cat package.json ^| python -c "import sys, json; print(json.load(sys.stdin)['iso'])"') do set iso=%%i
mkdir .\mirror\iso\
echo ��ȡ3:%Server%%iso%
curl %Server%%iso% > .\mirror\iso\list.json > nul
for /f "delims=" %%i in ('powershell cat .\iso\list.json ^| python -c "import sys, json; print(json.load(sys.stdin)['arch'])"') do set arch=%%i
mkdir .\mirror\iso\arch
echo ��ȡ4:%Server%/repo/iso/%arch%
curl %Server%/repo/iso/%arch% > .\mirror\iso\arch\version.json > nul


if not exist package.json (
    echo �޷�����%Server%/package.json
    echo �����������ӻ�mirrorlist.json
    timeout 3
    goto q
) else (
    echo ���Դ�������
    goto q
)
:in
for /f "delims=" %%i in ('powershell cat mirrorlist.json ^| python -c "import sys, json; print(json.load(sys.stdin)['Server'])"') do set Server=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\w\list.json ^| python install.py --ins %2') do set ins=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\list.json ^| python install.py --ins %2') do set ins1=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\%2\version.json ^| python install.py --ins %systemfie%') do set ins2=%%i
if not exist package.json (
    echo ����winpt upd
    goto q

)
if "%ins%" == "%2" (
    .\aria2-1.36.0-win-32bit-build1\aria2c.exe "%Server%"repo/iso/"%2"/"%ins2%"


) else (
    .\aria2-1.36.0-win-32bit-build1\aria2c.exe "%Server%"repo/w/"%ins%"
    .\7z\7z.exe x *.zip -o%temp%
    del /s /q *.zip
    ping 127.0.0.1 /n 3 > nul
    cd %temp%
    call install.bat
    del /s /q %temp%\*.exe
    del /s /q %temp%\*.bat
)

goto q

:clear
del /s /q .\mirror
del /s /q .\package.json
goto q
:q
cd %sdb%