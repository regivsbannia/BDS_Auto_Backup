# ���÷������ͱ���·��
$serverPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\bedrock_server.exe"
$worldPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\worlds\sevicer"
$backupPath = "C:\Users\Administrator\Desktop\debug"
$commandFilePath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\command.txt"

# ��������������ʾ����
Start-Process -FilePath $serverPath -NoNewWindow
Write-Host "Server started."

# ����ѭ��
while ($true) {
    Write-Host "Waiting for server to initialize..."
    # �ȴ�����������
    Start-Sleep -Seconds 15

    # ���� save hold ����
    Set-Content -Path $commandFilePath -Value "save hold"
    Write-Host "Command 'save hold' written to command file."

    # �ȴ�10��
    Start-Sleep -Seconds 10

    # ��鲢����Ŀ���ļ���
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $destination = Join-Path -Path $backupPath -ChildPath $timestamp
    if (!(Test-Path -Path $destination -PathType Container)) {
        New-Item -ItemType Directory -Path $destination -Force
        Write-Host "Created backup directory: $destination."
    }

    # ���Ʋ�ѹ���ļ���
    if (Test-Path -Path $worldPath -PathType Container) {
        Copy-Item -Path $worldPath -Destination $destination -Recurse
        Write-Host "Copied world data to backup directory: $destination."
    } else {
        Write-Host "Error: World folder path is invalid or does not exist."
    }

    # ���� save resume ����
    Set-Content -Path $commandFilePath -Value "save resume"
    Write-Host "Command 'save resume' written to command file."

    # ͣ��3Сʱ
    Write-Host "Sleeping for 3 hours..."
    Start-Sleep -Seconds 10800

    # ����ɱ����ļ�
    $backups = Get-ChildItem -Path $backupPath -Directory | Sort-Object -Property CreationTime -Descending
    if ($backups.Count -gt 5) {
        $backupsToDelete = $backups | Select-Object -Skip 5
        $backupsToDelete | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
            Write-Host "Deleted old backup: $($_.FullName)."
        }
    }
}