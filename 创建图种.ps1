param(
    [Parameter(Mandatory=$true)][string]$ImagePath,
    [Parameter(Mandatory=$true)][string]$ZipPath,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

# 验证输入文件是否存在
if (-not (Test-Path -Path $ImagePath -PathType Leaf)) {
    Write-Error "图片文件不存在: $ImagePath"
    exit 1
}

if (-not (Test-Path -Path $ZipPath -PathType Leaf)) {
    Write-Error "ZIP文件不存在: $ZipPath"
    exit 1
}

try {
    # 创建文件流进行二进制合并
    $imageStream = [System.IO.File]::OpenRead($ImagePath)
    $zipStream = [System.IO.File]::OpenRead($ZipPath)
    $outputStream = [System.IO.File]::Create($OutputPath)
    
    # 先写入图片数据
    $imageStream.CopyTo($outputStream)
    
    # 追加ZIP文件数据
    $zipStream.CopyTo($outputStream)
    
    Write-Host "图种创建成功: $OutputPath"
}
catch {
    Write-Error "合并过程中出错: $_"
}
finally {
    # 确保所有流都被关闭
    if ($null -ne $imageStream) { $imageStream.Close() }
    if ($null -ne $zipStream) { $zipStream.Close() }
    if ($null -ne $outputStream) { $outputStream.Close() }
}