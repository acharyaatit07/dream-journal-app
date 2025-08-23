# Dream Journal Flutter Project Structure Setup
# Run this script in your dream-journal-app root directory

Write-Host "🌙 Setting up Dream Journal Flutter project structure..." -ForegroundColor Cyan
Write-Host ""

# Create core application folders
Write-Host "📁 Creating core folders..." -ForegroundColor Yellow
New-Item -Path "lib\core\constants" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\core\theme" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\core\utils" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\core\services" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\core\models" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Core folders created" -ForegroundColor Green

# Create authentication feature folders
Write-Host "📁 Creating auth feature folders..." -ForegroundColor Yellow
New-Item -Path "lib\features\auth\models" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\auth\screens" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\auth\widgets" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\auth\services" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Auth feature folders created" -ForegroundColor Green

# Create dreams feature folders
Write-Host "📁 Creating dreams feature folders..." -ForegroundColor Yellow
New-Item -Path "lib\features\dreams\models" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\dreams\screens" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\dreams\widgets" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\dreams\services" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Dreams feature folders created" -ForegroundColor Green

# Create insights feature folders
Write-Host "📁 Creating insights feature folders..." -ForegroundColor Yellow
New-Item -Path "lib\features\insights\models" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\insights\screens" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\insights\widgets" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\insights\services" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Insights feature folders created" -ForegroundColor Green

# Create analytics feature folders
Write-Host "📁 Creating analytics feature folders..." -ForegroundColor Yellow
New-Item -Path "lib\features\analytics\models" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\analytics\screens" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\analytics\widgets" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\analytics\services" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Analytics feature folders created" -ForegroundColor Green

# Create settings feature folders
Write-Host "📁 Creating settings feature folders..." -ForegroundColor Yellow
New-Item -Path "lib\features\settings\models" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\settings\screens" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\settings\widgets" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\features\settings\services" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Settings feature folders created" -ForegroundColor Green

# Create shared folders
Write-Host "📁 Creating shared component folders..." -ForegroundColor Yellow
New-Item -Path "lib\shared\widgets" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\shared\utils" -ItemType Directory -Force | Out-Null
New-Item -Path "lib\shared\constants" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Shared folders created" -ForegroundColor Green

# Create asset folders
Write-Host "📁 Creating asset folders..." -ForegroundColor Yellow
New-Item -Path "assets\images" -ItemType Directory -Force | Out-Null
New-Item -Path "assets\icons" -ItemType Directory -Force | Out-Null
New-Item -Path "assets\fonts" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Asset folders created" -ForegroundColor Green

# Create documentation folders
Write-Host "📁 Creating documentation folders..." -ForegroundColor Yellow
New-Item -Path "docs" -ItemType Directory -Force | Out-Null
New-Item -Path "docs\architecture" -ItemType Directory -Force | Out-Null
New-Item -Path "docs\api" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Documentation folders created" -ForegroundColor Green

# Create test folders
Write-Host "📁 Creating test folders..." -ForegroundColor Yellow
New-Item -Path "test\unit" -ItemType Directory -Force | Out-Null
New-Item -Path "test\widget" -ItemType Directory -Force | Out-Null
New-Item -Path "test\integration" -ItemType Directory -Force | Out-Null
Write-Host "   ✅ Test folders created" -ForegroundColor Green

# Create .gitkeep files for empty folders (optional)
Write-Host "📄 Creating .gitkeep files for empty folders..." -ForegroundColor Yellow
$emptyFolders = @(
    "lib\features\auth\models",
    "lib\features\auth\screens", 
    "lib\features\auth\widgets",
    "lib\features\auth\services",
    "lib\features\insights\models",
    "lib\features\insights\screens",
    "lib\features\insights\widgets", 
    "lib\features\insights\services",
    "lib\features\analytics\models",
    "lib\features\analytics\screens",
    "lib\features\analytics\widgets",
    "lib\features\analytics\services",
    "lib\features\settings\models",
    "lib\features\settings\screens",
    "lib\features\settings\widgets",
    "lib\features\settings\services",
    "lib\shared\widgets",
    "lib\shared\utils",
    "lib\shared\constants",
    "assets\images",
    "assets\icons", 
    "assets\fonts",
    "docs\architecture",
    "docs\api",
    "test\unit",
    "test\widget",
    "test\integration"
)

foreach ($folder in $emptyFolders) {
    New-Item -Path "$folder\.gitkeep" -ItemType File -Force | Out-Null
}
Write-Host "   ✅ .gitkeep files created" -ForegroundColor Green

# Display the created structure
Write-Host ""
Write-Host "🎉 Dream Journal project structure created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Your project structure:" -ForegroundColor Cyan
Write-Host "lib/" -ForegroundColor White
Write-Host "├── core/                    # Core app functionality" -ForegroundColor Gray
Write-Host "│   ├── constants/          # App constants, colors, strings" -ForegroundColor Gray
Write-Host "│   ├── theme/              # App themes and styling" -ForegroundColor Gray
Write-Host "│   ├── utils/              # Utility functions" -ForegroundColor Gray
Write-Host "│   ├── services/           # Core services (API, storage)" -ForegroundColor Gray
Write-Host "│   └── models/             # Core data models" -ForegroundColor Gray
Write-Host "├── features/               # Feature-based organization" -ForegroundColor Gray
Write-Host "│   ├── auth/               # Authentication" -ForegroundColor Gray
Write-Host "│   ├── dreams/             # Dream management" -ForegroundColor Gray
Write-Host "│   ├── insights/           # AI insights" -ForegroundColor Gray
Write-Host "│   ├── analytics/          # Analytics & patterns" -ForegroundColor Gray
Write-Host "│   └── settings/           # App settings" -ForegroundColor Gray
Write-Host "├── shared/                 # Shared components" -ForegroundColor Gray
Write-Host "│   ├── widgets/            # Reusable widgets" -ForegroundColor Gray
Write-Host "│   ├── utils/              # Shared utilities" -ForegroundColor Gray
Write-Host "│   └── constants/          # Shared constants" -ForegroundColor Gray
Write-Host "└── main.dart               # App entry point" -ForegroundColor Gray
Write-Host ""
Write-Host "assets/" -ForegroundColor White
Write-Host "├── images/                 # App images" -ForegroundColor Gray
Write-Host "├── icons/                  # Custom icons" -ForegroundColor Gray
Write-Host "└── fonts/                  # Custom fonts" -ForegroundColor Gray
Write-Host ""
Write-Host "docs/" -ForegroundColor White
Write-Host "├── architecture/           # Architecture documentation" -ForegroundColor Gray
Write-Host "└── api/                    # API documentation" -ForegroundColor Gray
Write-Host ""
Write-Host "test/" -ForegroundColor White
Write-Host "├── unit/                   # Unit tests" -ForegroundColor Gray
Write-Host "├── widget/                 # Widget tests" -ForegroundColor Gray
Write-Host "└── integration/            # Integration tests" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update pubspec.yaml with dependencies" -ForegroundColor White
Write-Host "2. Create core app files (constants, themes, models)" -ForegroundColor White
Write-Host "3. Build your first dream entry screen" -ForegroundColor White
Write-Host "4. Set up local database for dream storage" -ForegroundColor White
Write-Host ""
Write-Host "✨ Ready to start building your Dream Journal app!" -ForegroundColor Magenta