# Auto Backup Tool for Minecraft Bedrock Server on Windows Server System
# 我的世界基岩版windows服务器自动备份工具

### 使用方法 |  How to use
1. 下载 **.\debug\test_pw2.ps1**和**close.bat**两个文件，将其放置在服务器桌面可以快速点击的位置  
Download **.\debug\test_pw2.ps1** and **close.bat**. Place them on sever desktop where you can easily click
2. 运行官方BDS基岩版服务器程序，使用记事本打开**test_pw2.ps1**设置3文件路径和备份时间间隔  
Run officail BDS program, open **test_pw2.ps1** by txt to set the 3 file path and the frenquence of backup    
```
    $serverPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\bedrock_server.exe"
    $worldPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\worlds\sevicer_test"
    $backupPath = "C:\Users\Administrator\Desktop\debug"
    ...
        # 停顿3小时 | 3 hours interval
        Start-Sleep -Seconds 3600
```

3. 以管理员身份运行**test_pw2.ps1**，等待一段时间直到其程序运作正常  
Run **test_pw2.ps1** as administrator and wait for a while
4. 如果你想断开windows远程连接，需要小心操作以下步骤  
If you wants to disconnect remotely from windows server, you should follow steps carefully
    - **运行close.bat，在被断开连接之前快速将test_pw2.ps1的powershell窗口切换至前台**  
    **Run _close.bat_ to quickly switch the powershell window of _test_pw2.ps1_ to the foreground before being disconnected**
    - <span style="color:red">如果没有来得及将test_pw2.ps1的powershell窗口切换至前台即被断开连接（手慢了），则无法自动备份存档</span>  
    <span style="color:red">If you don't have time to switch the PowerShell window of test_pw2.ps1 to the foreground and it is disconnected (slow hand), you can't back up the archive automatically</span>

### 注意事项 |  Attention
本程序利用BDS自带的Backup功能，理论上是热备份且安全的。**但是我仍旧无法保证其不会损坏存档。**  
This program takes advantage of BDS's built-in Backup feature, which is theoretically hot and safe. **But I still can't guarantee that it won't corrupt the archive.**

### 文件说明 |  Files Introduction
├── close.bat [**断开服务器连接脚本**]  
├── readme.md [**说明文档**]  
└── debug/
- ├── test_pw.ps1 [**1:一次备份，无法离线 sendkey**]  
├── test_pw2.ps1 [**循环备份，无法离线 sendkey 1pro 结合桌面close.bat使用，运行close.bat，快速将ps1切换至前台**]  
├── test_pw3.ps1 [**循环备份，无法离线 sendkey 2改进失败**]  
├── test_pw4.ps1 [**命令管道 失败**]  
├── test_pw5.ps1 [**文件传递 失败**]  
└── test_pw6.ps1 [**伪客户端 失败**]

