#!/bin/bash
# MRGesture - Quick Setup Verification Script
# Run this on macOS to verify all files are present before creating Xcode project

set -e

echo "🚀 MRGesture Setup Verification"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to script directory
cd "$(dirname "$0")"

# Counters
TOTAL=0
FOUND=0
MISSING=0

check_file() {
    local file=$1
    TOTAL=$((TOTAL + 1))
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
        FOUND=$((FOUND + 1))
    else
        echo -e "${RED}✗${NC} $file (MISSING)"
        MISSING=$((MISSING + 1))
    fi
}

echo "📁 Checking Source Files..."
echo ""

echo "App Group:"
check_file "MRGesture/MRGesture/App/MRGestureApp.swift"
check_file "MRGesture/MRGesture/App/AppDelegate.swift"
check_file "MRGesture/MRGesture/App/Info.plist"
echo ""

echo "Core/Vision Group:"
check_file "MRGesture/MRGesture/Core/Vision/CameraManager.swift"
check_file "MRGesture/MRGesture/Core/Vision/HandPoseDetector.swift"
check_file "MRGesture/MRGesture/Core/Vision/HandPoseModel.swift"
echo ""

echo "Core/Gestures Group:"
check_file "MRGesture/MRGesture/Core/Gestures/GestureRecognizer.swift"
check_file "MRGesture/MRGesture/Core/Gestures/GestureType.swift"
check_file "MRGesture/MRGesture/Core/Gestures/PeaceSignDetector.swift"
check_file "MRGesture/MRGesture/Core/Gestures/ThumbsUpDetector.swift"
check_file "MRGesture/MRGesture/Core/Gestures/SwipeDetector.swift"
echo ""

echo "Core/Actions Group:"
check_file "MRGesture/MRGesture/Core/Actions/ActionDispatcher.swift"
check_file "MRGesture/MRGesture/Core/Actions/ActionType.swift"
check_file "MRGesture/MRGesture/Core/Actions/AlfredLauncher.swift"
check_file "MRGesture/MRGesture/Core/Actions/AppSwitcher.swift"
check_file "MRGesture/MRGesture/Core/Actions/ScrollSimulator.swift"
echo ""

echo "UI/Settings Group:"
check_file "MRGesture/MRGesture/UI/Settings/SettingsView.swift"
check_file "MRGesture/MRGesture/UI/Settings/PermissionsView.swift"
echo ""

echo "Services Group:"
check_file "MRGesture/MRGesture/Services/PermissionManager.swift"
check_file "MRGesture/MRGesture/Services/ConfigurationManager.swift"
echo ""

echo "🧪 Checking Test Files..."
echo ""
check_file "MRGesture/MRGestureTests/GestureDetectionTests.swift"
check_file "MRGesture/MRGestureTests/MockHandPoseProvider.swift"
check_file "MRGesture/MRGestureTests/Info.plist"
echo ""

echo "📄 Checking Documentation..."
echo ""
check_file "README.md"
check_file "CLAUDE.md"
check_file "XCODE_SETUP.md"
check_file "PROJECT_FILES.md"
echo ""

echo "================================"
echo -e "📊 Summary: ${GREEN}$FOUND found${NC}, ${RED}$MISSING missing${NC} (out of $TOTAL files)"
echo ""

if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✅ All files present! Ready to create Xcode project.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open Xcode"
    echo "2. Create new macOS App project"
    echo "3. Follow XCODE_SETUP.md for detailed instructions"
    echo "4. Add all files from MRGesture/MRGesture/ to the target"
    echo "5. Add test files from MRGesture/MRGestureTests/ to test target"
    echo ""
    exit 0
else
    echo -e "${RED}⚠️  Some files are missing. Please check the errors above.${NC}"
    echo ""
    exit 1
fi
