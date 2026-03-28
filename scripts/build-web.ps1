# Build Flutter Web with Favicon Fix
Write-Host "🚀 Building Flutter Web with Favicon Fix..."

# Build Flutter web
flutter build web --base-href "https://portfolio-8ed95.web.app/"

# Copy favicon to build directory
Write-Host "📋 Copying favicon.svg to build/web..."
Copy-Item "web/favicon.svg" "build/web/favicon.svg" -Force

Write-Host "✅ Build complete with favicon!"
Write-Host "🌐 Ready for deployment"
