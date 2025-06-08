# 设置服务器和备份路径
$serverPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\bedrock_server.exe"
$worldPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\worlds\sevicer"
$backupPath = "C:\Users\Administrator\Desktop\debug"

# 启动服务器并显示窗口
Start-Process -FilePath $serverPath -NoNewWindow

# 无限循环
while ($true) {
    # 等待服务器启动
    Start-Sleep -Seconds 15

    # 发送 save hold 命令
    $obj = new-object -ComObject WScript.Shell
    $obj.SendKeys("save hold{ENTER}")

    # 等待10秒
    Start-Sleep -Seconds 10

    # 检查并创建目标文件夹
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $destination = Join-Path -Path $backupPath -ChildPath $timestamp
    if (!(Test-Path -Path $destination -PathType Container)) {
        New-Item -ItemType Directory -Path $destination -Force
    }

    # 复制并压缩文件夹
    if (Test-Path -Path $worldPath -PathType Container) {
        Copy-Item -Path $worldPath -Destination $destination -Recurse
    } else {
        Write-Host "错误：世界文件夹路径无效或不存在。"
    }

    # 发送 save resume 命令
    $obj = new-object -ComObject WScript.Shell
    $obj.SendKeys("save resume{ENTER}")

    # 停顿3小时
    Start-Sleep -Seconds 60

    # 清理旧备份文件
    $backups = Get-ChildItem -Path $backupPath -Directory | Sort-Object -Property CreationTime -Descending
    if ($backups.Count -gt 5) {
        $backupsToDelete = $backups | Select-Object -Skip 5
        $backupsToDelete | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
    }
}