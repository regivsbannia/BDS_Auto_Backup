# ���� Send-ServerCommand ����
function Send-ServerCommand {
    param (
        [string]$pipeName,
        [string]$command
    )
    $pipe = new-object System.IO.Pipes.NamedPipeClientStream(".", $pipeName, [System.IO.Pipes.PipeDirection]::Out)
    $pipe.Connect()
    $writer = new-object System.IO.StreamWriter($pipe)
    $writer.WriteLine($command)
    $writer.Flush()
    $writer.Close()
    $pipe.Close()
}

# ���÷������ͱ���·��
$serverPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\bedrock_server.exe"
$worldPath = "C:\Users\Administrator\Desktop\bedrock-server-1.17.40.06\worlds\sevicer"
$backupPath = "C:\Users\Administrator\Desktop\debug"
$pipeName = "bedrockPipe"

# ���������������������ܵ�ͨ��
$serverProcess = Start-Process -FilePath $serverPath -ArgumentList "--pipe $pipeName" -PassThru

# ����ѭ��
while ($true) {
    # �ȴ�����������
    Start-Sleep -Seconds 15

    # ���� save hold ����
    Send-ServerCommand -pipeName $pipeName -command "save hold"

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
    Send-ServerCommand -pipeName $pipeName -command "save resume"

    # ͣ��3Сʱ
    Start-Sleep -Seconds 10800

    # ����ɱ����ļ�
    $backups = Get-ChildItem -Path $backupPath -Directory | Sort-Object -Property CreationTime -Descending
    if ($backups.Count -gt 5) {
        $backupsToDelete = $backups | Select-Object -Skip 5
        $backupsToDelete | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
    }
}