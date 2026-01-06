# MRGesture - Complete File Manifest

This document lists all files that need to be added to the Xcode project.

## Source Files (19 Swift files)

### App Group (3 files)
- `MRGesture/App/MRGestureApp.swift` - @main entry point
- `MRGesture/App/AppDelegate.swift` - App lifecycle, menu bar, pipeline
- `MRGesture/App/Info.plist` - Bundle configuration, permissions

### Core/Vision Group (3 files)
- `MRGesture/Core/Vision/CameraManager.swift` - AVCaptureSession management
- `MRGesture/Core/Vision/HandPoseDetector.swift` - Vision framework integration
- `MRGesture/Core/Vision/HandPoseModel.swift` - HandPose data model

### Core/Gestures Group (5 files)
- `MRGesture/Core/Gestures/GestureRecognizer.swift` - Orchestration
- `MRGesture/Core/Gestures/GestureType.swift` - Enums and protocols
- `MRGesture/Core/Gestures/PeaceSignDetector.swift` - ✌️ detection
- `MRGesture/Core/Gestures/ThumbsUpDetector.swift` - 👍 detection
- `MRGesture/Core/Gestures/SwipeDetector.swift` - 👆 swipe detection

### Core/Actions Group (5 files)
- `MRGesture/Core/Actions/ActionDispatcher.swift` - Gesture routing
- `MRGesture/Core/Actions/ActionType.swift` - Action enums
- `MRGesture/Core/Actions/AlfredLauncher.swift` - Launch Alfred
- `MRGesture/Core/Actions/AppSwitcher.swift` - Activate Ghostty
- `MRGesture/Core/Actions/ScrollSimulator.swift` - CGEvent scrolling

### UI/Settings Group (2 files)
- `MRGesture/UI/Settings/SettingsView.swift` - SwiftUI settings window
- `MRGesture/UI/Settings/PermissionsView.swift` - Permission status UI

### Services Group (2 files)
- `MRGesture/Services/PermissionManager.swift` - Permission handling
- `MRGesture/Services/ConfigurationManager.swift` - UserDefaults

### Resources Group (1 item)
- `MRGesture/Resources/Assets.xcassets/` - App icons (to be created)

## Test Files (3 files)

### MRGestureTests Target (3 files)
- `MRGestureTests/GestureDetectionTests.swift` - 26 unit tests
- `MRGestureTests/MockHandPoseProvider.swift` - Test data provider
- `MRGestureTests/Info.plist` - Test bundle config

## Project Configuration

### Bundle Identifier
Recommend: `com.yourname.MRGesture` (replace 'yourname' with your developer name)

### Minimum Deployment
- macOS 12.0 or later

### Required Frameworks (Auto-linked)
- Foundation
- AppKit
- SwiftUI
- AVFoundation
- Vision
- CoreGraphics
- ApplicationServices (for Accessibility APIs)

### Required Capabilities
- Camera
- Accessibility (for Hardened Runtime)

### Build Settings
- App Sandbox: **Disabled** (required for CGEvent and Accessibility)
- Hardened Runtime: **Enabled** with Camera entitlement

## File Organization in Xcode

```
MRGesture (Project)
├── MRGesture (Target)
│   ├── App
│   │   ├── MRGestureApp.swift
│   │   ├── AppDelegate.swift
│   │   └── Info.plist
│   ├── Core
│   │   ├── Vision
│   │   │   ├── CameraManager.swift
│   │   │   ├── HandPoseDetector.swift
│   │   │   └── HandPoseModel.swift
│   │   ├── Gestures
│   │   │   ├── GestureRecognizer.swift
│   │   │   ├── GestureType.swift
│   │   │   ├── PeaceSignDetector.swift
│   │   │   ├── ThumbsUpDetector.swift
│   │   │   └── SwipeDetector.swift
│   │   └── Actions
│   │       ├── ActionDispatcher.swift
│   │       ├── ActionType.swift
│   │       ├── AlfredLauncher.swift
│   │       ├── AppSwitcher.swift
│   │       └── ScrollSimulator.swift
│   ├── UI
│   │   └── Settings
│   │       ├── SettingsView.swift
│   │       └── PermissionsView.swift
│   ├── Services
│   │   ├── PermissionManager.swift
│   │   └── ConfigurationManager.swift
│   └── Resources
│       └── Assets.xcassets
└── MRGestureTests (Target)
    ├── GestureDetectionTests.swift
    ├── MockHandPoseProvider.swift
    └── Info.plist
```

## Quick Checklist

When adding files to Xcode:
- [ ] All 19 Swift source files added to MRGesture target
- [ ] Info.plist set as main app Info.plist
- [ ] All 3 test files added to MRGestureTests target
- [ ] Test Info.plist set as test bundle Info.plist
- [ ] Assets.xcassets added (create if doesn't exist)
- [ ] All files show target membership checkbox checked
- [ ] Groups (folders) match directory structure
- [ ] No red (missing) files in Xcode navigator

## Line Count Summary

- **Source Code**: 19 Swift files, ~2,000 lines
- **Tests**: 3 files, ~840 lines
- **Total**: 22 Swift files, ~2,840 lines of code
