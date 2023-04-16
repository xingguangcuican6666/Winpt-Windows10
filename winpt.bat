@echo off
::apt for windows
set sdb=%cd%
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
    echo 32位操作系统
    set systemfie="x86"
) else (
    echo 64位操作系统
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
        echo 错误，请重新运行
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
echo 用法:
echo winpt [install/remove/update/upgrade/download/in/re/upd/upg/dl] [package name]
echo install/in  安装一个或多个软件包
echo remove/re   卸载一个或多个软件包
echo update/upd  更新软件源缓存文件
echo upgrade/upg 更新所有软件包
echo download/dl 下载软件包但不安装
echo clear 清除所有缓存数据
echo.
echo 实例：
echo winpt instal1 wechat
echo ===================================================
goto q
:dl
for /f "delims=" %%i in ('powershell cat mirrorlist.json ^| python -c "import sys, json; print(json.load(sys.stdin)['Server'])"') do set Server=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\w\list.json ^| python install.py --ins %2') do set ins=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\list.json ^| python install.py --ins %2') do set ins1=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\%2\version.json ^| python install.py --ins %systemfie%') do set ins2=%%i
if not exist package.json (
    echo 请先winpt dl
    goto q

)
if "%ins%" == "%2" (
    .\aria2-1.36.0-win-32bit-build1\aria2c.exe "%Server%"repo/iso/"%2"/"%ins2%"


) else (
    .\aria2-1.36.0-win-32bit-build1\aria2c.exe "%Server%"repo/w/"%ins%"
    echo 完成
)
:upd
for /f "delims=" %%i in ('powershell cat .\mirrorlist.json ^| python -c "import sys, json; print(json.load(sys.stdin)['Server'])"') do set Server=%%i
echo 获取1:%Server%package.json
curl %Server%package.json > .\mirror\package.json > nul
for /f "delims=" %%i in ('powershell cat package.json ^| python -c "import sys, json; print(json.load(sys.stdin)['repow'])"') do set repow=%%i
mkdir .\mirror\w\
echo 获取2:%Server%%repow%
curl %Server%%repow% > .\mirror\w\list.json > nul
for /f "delims=" %%i in ('powershell cat package.json ^| python -c "import sys, json; print(json.load(sys.stdin)['iso'])"') do set iso=%%i
mkdir .\mirror\iso\
echo 获取3:%Server%%iso%
curl %Server%%iso% > .\mirror\iso\list.json > nul
for /f "delims=" %%i in ('powershell cat .\iso\list.json ^| python -c "import sys, json; print(json.load(sys.stdin)['arch'])"') do set arch=%%i
mkdir .\mirror\iso\arch
echo 获取4:%Server%/repo/iso/%arch%
curl %Server%/repo/iso/%arch% > .\mirror\iso\arch\version.json > nul


if not exist package.json (
    echo 无法下载%Server%/package.json
    echo 请检查网络连接或mirrorlist.json
    timeout 3
    goto q
) else (
    echo 软件源更新完成
    goto q
)
:in
for /f "delims=" %%i in ('powershell cat mirrorlist.json ^| python -c "import sys, json; print(json.load(sys.stdin)['Server'])"') do set Server=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\w\list.json ^| python install.py --ins %2') do set ins=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\list.json ^| python install.py --ins %2') do set ins1=%%i
for /f "delims=" %%i in ('powershell cat .\mirror\iso\%2\version.json ^| python install.py --ins %systemfie%') do set ins2=%%i
if not exist package.json (
    echo 请先winpt upd
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