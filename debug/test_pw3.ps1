# ���÷������ͱ���·��
$serverPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\bedrock_server.exe"
$worldPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\worlds\sevicer"
$backupPath = "C:\Users\Administrator\Desktop\debug"

# ��������������ʾ����
Start-Process -FilePath $serverPath -NoNewWindow

# ����ѭ��
while ($true) {
    # �ȴ�����������
    Start-Sleep -Seconds 15

    # ���� save hold ����
    $obj = new-object -ComObject WScript.Shell
    $obj.SendKeys("save hold{ENTER}")

    # �ȴ�10��
    Start-Sleep -Seconds 10

    # ��鲢����Ŀ���ļ���
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $destination = Join-Path -Path $backupPath -ChildPath $timestamp
    if (!(Test-Path -Path $destination -PathType Container)) {
        New-Item -ItemType Directory -Path $destination -Force
    }

    # ���Ʋ�ѹ���ļ���
    if (Test-Path -Path $worldPath -PathType Container) {
        Copy-Item -Path $worldPath -Destination $destination -Recurse
    } else {
        Write-Host "���������ļ���·����Ч�򲻴��ڡ�"
    }

    # ���� save resume ����
    $obj = new-object -ComObject WScript.Shell
    $obj.SendKeys("save resume{ENTER}")

    # ͣ��3Сʱ
    Start-Sleep -Seconds 60

    # ����ɱ����ļ�
    $backups = Get-ChildItem -Path $backupPath -Directory | Sort-Object -Property CreationTime -Descending
    if ($backups.Count -gt 5) {
        $backupsToDelete = $backups | Select-Object -Skip 5
        $backupsToDelete | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
    }
}