#!/bin/bash

echo "🚀 Building Flutter Web with Favicon Fix..."

# Build Flutter web
flutter build web --base-href "https://portfolio-8ed95.web.app/"

# Copy favicon to build directory
echo "📋 Copying favicon.svg to build/web..."
cp web/favicon.svg build/web/favicon.svg

echo "✅ Build complete with favicon!"
echo "🌐 Ready for deployment"
