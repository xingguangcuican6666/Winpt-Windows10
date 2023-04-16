import os,time
print("已检测到python，无需安装依赖")
print("请重新启动软件")
time.sleep(3)
os.system("echo 1 > ok.lock")
os.system("taskkill /f /im cmd.exe")
