param(
    [Parameter(Mandatory=$true)][string]$ImagePath,
    [Parameter(Mandatory=$true)][string]$ZipPath,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

# Validate input files exist
if (-not (Test-Path -Path $ImagePath -PathType Leaf)) {
    Write-Error "Image file not found: $ImagePath"
    exit 1
}

if (-not (Test-Path -Path $ZipPath -PathType Leaf)) {
    Write-Error "ZIP file not found: $ZipPath"
    exit 1
}

try {
    # Create file streams for binary merge
    $imageStream = [System.IO.File]::OpenRead($ImagePath)
    $zipStream = [System.IO.File]::OpenRead($ZipPath)
    $outputStream = [System.IO.File]::Create($OutputPath)
    
    # Write image data first
    $imageStream.CopyTo($outputStream)
    
    # Append ZIP file data
    $zipStream.CopyTo($outputStream)
    
    Write-Host "Image seed created successfully: $OutputPath"
}
catch {
    Write-Error "Error during merge operation: $_"
}
finally {
    # Ensure all streams are closed
    if ($null -ne $imageStream) { $imageStream.Close() }
    if ($null -ne $zipStream) { $zipStream.Close() }
    if ($null -ne $outputStream) { $outputStream.Close() }
}