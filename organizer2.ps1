$coreFolders = @(
    "lib\core\constants",
    "lib\core\theme", 
    "lib\core\utils",
    "lib\core\services",
    "lib\core\models"
)

foreach ($folder in $coreFolders) {
    Write-Host "Processing: $folder" -ForegroundColor Yellow
    
    # Create folder if it doesn't exist
    if (-not (Test-Path $folder)) {
        Write-Host "  Creating folder: $folder" -ForegroundColor Green
        New-Item -Path $folder -ItemType Directory -Force | Out-Null
    }
    
    # Create .gitkeep file
    $gitkeepPath = Join-Path $folder ".gitkeep"
    Write-Host "  Creating: $gitkeepPath" -ForegroundColor Green
    "" | Out-File -FilePath $gitkeepPath -Encoding utf8
    
    # Verify it was created
    if (Test-Path $gitkeepPath) {
        Write-Host "  ✅ Success: $gitkeepPath" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Failed: $gitkeepPath" -ForegroundColor Red
    }
}