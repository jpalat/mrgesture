# Xcode Project Setup Guide

This guide explains how to create the Xcode project and run MRGesture on your Mac.

## Prerequisites

- macOS 12.0 or later
- Xcode 14.0 or later
- Apple Developer account (for code signing)

## Step 1: Create Xcode Project

1. Open Xcode
2. Select **File → New → Project**
3. Choose **macOS → App** and click **Next**
4. Configure your project:
   - **Product Name**: MRGesture
   - **Team**: Select your Apple Developer team
   - **Organization Identifier**: com.yourname (or your preferred identifier)
   - **Bundle Identifier**: Will be auto-generated (e.g., com.yourname.MRGesture)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Use Core Data**: Unchecked
   - **Include Tests**: Checked (optional)
5. Click **Next** and choose the `mrgesture/MRGesture` directory
6. Click **Create**

## Step 2: Add Source Files to Project

The source files are already organized in the correct directory structure:

```
MRGesture/
├── App/
│   ├── MRGestureApp.swift
│   ├── AppDelegate.swift
│   └── Info.plist
├── Core/
│   ├── Vision/
│   │   ├── CameraManager.swift
│   │   ├── HandPoseDetector.swift
│   │   └── HandPoseModel.swift
│   ├── Gestures/
│   │   ├── GestureRecognizer.swift
│   │   ├── GestureType.swift
│   │   ├── PeaceSignDetector.swift
│   │   ├── ThumbsUpDetector.swift
│   │   └── SwipeDetector.swift
│   └── Actions/
│       ├── ActionDispatcher.swift
│       ├── ActionType.swift
│       ├── AlfredLauncher.swift
│       ├── AppSwitcher.swift
│       └── ScrollSimulator.swift
├── UI/
│   ├── MenuBar/
│   │   └── MenuBarController.swift
│   └── Settings/
│       ├── SettingsView.swift
│       └── PermissionsView.swift
├── Services/
│   ├── PermissionManager.swift
│   └── ConfigurationManager.swift
└── Resources/
    └── Assets.xcassets/
```

### Adding Files in Xcode:

1. **Delete** the default `ContentView.swift` file that Xcode created
2. In Xcode's Project Navigator, **right-click** on the `MRGesture` folder
3. Select **Add Files to "MRGesture"...**
4. Navigate to the `MRGesture/MRGesture` directory
5. Select all the folders (`App`, `Core`, `UI`, `Services`, `Resources`)
6. Make sure **"Create groups"** is selected (not "Create folder references")
7. Make sure **"MRGesture" target** is checked
8. Click **Add**

## Step 3: Configure Build Settings

### Info.plist Configuration

The `Info.plist` file is already configured with required keys. Verify it contains:

- `NSCameraUsageDescription` - Camera access explanation
- `LSUIElement` = `true` - Menu bar app (no dock icon)
- `LSMinimumSystemVersion` = `12.0` - Minimum macOS version

### Project Settings

1. Select the **MRGesture project** in Project Navigator
2. Select the **MRGesture target**
3. Go to **Signing & Capabilities** tab:
   - **Team**: Select your Apple Developer team
   - **Bundle Identifier**: Should match what you set earlier
   - **Signing Certificate**: Select "Development" or "Apple Development"

4. Go to **General** tab:
   - **Minimum Deployments**: macOS 12.0
   - **Deployment Target**: macOS 12.0

5. Go to **Build Settings** tab:
   - Search for **"App Sandbox"**
   - Set **Enable App Sandbox** to **NO** (required for CGEvent and Accessibility)
   - Search for **"Hardened Runtime"**
   - Under **Hardened Runtime**, enable:
     - **Disable Library Validation** (optional, for loading dynamic libraries)
     - **Allow Dyld Environment Variables** (optional, for debugging)

### Entitlements (Important!)

1. Select the **MRGesture target**
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **Hardened Runtime**
5. Under Hardened Runtime, enable:
   - **Camera** (for camera access)
   - **Accessibility** (for scrolling and keyboard events)

**Note**: For Accessibility to work, you may need to disable App Sandbox entirely.

## Step 4: Add Assets (Optional)

To add menu bar icons:

1. Open `Assets.xcassets` in Xcode
2. Right-click → **New Image Set**
3. Name it `MenuBarIcon`
4. Drag and drop icon images (16x16, 32x32 for @1x and @2x)

You can use SF Symbols instead:
- Active: `hand.raised.fill`
- Inactive: `hand.raised`

## Step 5: Build and Run

1. Select the **MRGesture** scheme and **My Mac** as the destination
2. Press **Cmd + B** to build
3. Fix any compilation errors (if any)
4. Press **Cmd + R** to run

### First Launch

On first launch, you'll be prompted to:

1. **Grant Camera Access** - Click "OK" to allow
2. **Grant Accessibility Access**:
   - A system prompt will appear
   - Click "Open System Preferences"
   - In **Privacy & Security → Accessibility**
   - Find **MRGesture** and check the box
   - You may need to restart the app

## Step 6: Test Gestures

1. Click the **hand icon** in the menu bar
2. Select **"Start Detection"**
3. Make gestures in front of your camera:
   - **Peace sign (✌️)** → Opens Alfred
   - **Thumbs up (👍)** → Switches to Ghostty
   - **Swipe up/down** → Scrolls page

Watch the Xcode console for debug output showing detected gestures.

## Troubleshooting

### Camera Not Working

- Check that Camera permission is granted in System Preferences → Privacy & Security → Camera
- Check the console for error messages
- Verify the camera is not being used by another app

### Gestures Not Detected

- Ensure adequate lighting
- Hold hand steady for 3-5 frames (temporal smoothing)
- Check console for "✋ Detected: [Gesture]" messages
- Try adjusting hand position and distance from camera

### Alfred/Ghostty Not Launching

- Verify Alfred/Ghostty is installed in `/Applications/`
- Check console for error messages
- For Alfred, it should fall back to Spotlight if not found

### Scrolling Not Working

- Check that Accessibility permission is granted
- Go to System Preferences → Privacy & Security → Accessibility
- Ensure MRGesture is in the list and checked
- Restart the app after granting permission

### Build Errors

**"Cannot find type 'HandPose' in scope"**:
- Ensure all files are added to the target
- Check that file membership includes MRGesture target

**"No such module 'Vision'"**:
- Set minimum deployment target to macOS 12.0
- Vision framework should be automatically linked

**Code signing errors**:
- Select a valid Development team in Signing & Capabilities
- Ensure you're signed in to Xcode with your Apple ID

## Performance Tuning

### Reduce CPU Usage

- Lower frame rate in settings (15 FPS instead of 30)
- Use `.medium` camera preset (already configured)
- Monitor CPU usage in Activity Monitor

### Improve Gesture Accuracy

- Ensure good lighting
- Position hand 1-2 feet from camera
- Make distinct, deliberate gestures
- Adjust thresholds in detector files if needed

## Distribution

### Code Signing for Distribution

1. In Xcode, select **Product → Archive**
2. Once archived, click **Distribute App**
3. Choose **Developer ID** for distribution outside the App Store
4. Follow the prompts to sign with your Developer ID certificate

### Notarization (Required for macOS 10.15+)

For distribution, you'll need to notarize the app:

```bash
xcrun notarytool submit MRGesture.app \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password" \
  --wait
```

## Development Tips

### Enable Debug Logging

All components print to console using `print()`. View output in Xcode's Console pane.

### Test Without Camera

Create mock `HandPose` objects in tests:

```swift
let mockPose = HandPose(landmarks: [...], chirality: .right, confidence: 0.9, timestamp: Date())
```

### Adjust Gesture Thresholds

Edit detector files to tune sensitivity:
- `PeaceSignDetector.swift` - Adjust `fingerExtensionThreshold`
- `ThumbsUpDetector.swift` - Adjust `thumbExtensionThreshold`
- `SwipeDetector.swift` - Adjust `minSwipeDistance`, `minVelocity`

## Next Steps

Once the MVP is working, consider:

1. Adding custom gesture builder UI
2. Implementing gesture history/debug view
3. Adding haptic feedback on gesture detection
4. Creating gesture combinations (chained gestures)
5. Adding Shortcuts.app integration

## Support

For issues or questions:
- Check console output for error messages
- Review gesture detection thresholds
- Ensure all permissions are granted
- Test camera feed separately

Happy gesture controlling! 🖐️
