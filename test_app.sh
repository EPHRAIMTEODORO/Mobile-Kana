#!/bin/bash
# Mobile Kana Test Script

echo "🎌 Mobile Kana Test Helper"
echo "=========================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo "📥 Install from: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
flutter --version
echo ""

# Run flutter doctor
echo "🔍 Checking Flutter environment..."
flutter doctor
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get
echo ""

# List available devices
echo "📱 Available devices:"
flutter devices
echo ""

# Ask user which device to use
echo "🚀 Launch options:"
echo "1) Launch on first available device"
echo "2) Launch on Chrome (web)"
echo "3) Just list devices and exit"
read -p "Choose option (1-3): " choice

case $choice in
    1)
        echo "🚀 Launching app..."
        flutter run
        ;;
    2)
        echo "🌐 Launching in Chrome..."
        flutter run -d chrome
        ;;
    3)
        echo "👋 Exiting..."
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac
