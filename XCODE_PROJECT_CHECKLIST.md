# Xcode Project Creation Checklist

Complete this checklist to create the MRGesture Xcode project. Estimated time: 15-20 minutes.

## Prerequisites

- [ ] macOS 12.0 or later
- [ ] Xcode 14.0 or later installed
- [ ] Apple Developer account (free or paid)
- [ ] Cloned this repository to your Mac

---

## Step 1: Verify Files (2 minutes)

```bash
cd /path/to/mrgesture
./QUICK_START.sh
```

- [ ] Script shows "✅ All files present!"
- [ ] No missing files reported

**If files are missing**: Check git status and ensure all files are committed.

---

## Step 2: Create Xcode Project (5 minutes)

### 2.1 Create New Project

- [ ] Open Xcode
- [ ] Select **File → New → Project**
- [ ] Choose **macOS** tab
- [ ] Select **App** template
- [ ] Click **Next**

### 2.2 Configure Project

Fill in the following fields:

- [ ] **Product Name**: `MRGesture`
- [ ] **Team**: Select your Apple Developer team
- [ ] **Organization Identifier**: `com.yourname` (or your preferred identifier)
- [ ] **Bundle Identifier**: Will auto-generate (e.g., `com.yourname.MRGesture`)
- [ ] **Interface**: **SwiftUI**
- [ ] **Language**: **Swift**
- [ ] **Use Core Data**: ❌ Unchecked
- [ ] **Include Tests**: ✅ Checked
- [ ] Click **Next**

### 2.3 Choose Location

- [ ] Navigate to `/path/to/mrgesture/MRGesture` directory
- [ ] ⚠️ **Important**: Save INSIDE the `MRGesture/` folder (not the root)
- [ ] Click **Create**

### 2.4 Clean Up Default Files

Xcode creates some default files we don't need:

- [ ] Delete `ContentView.swift` (right-click → Delete → Move to Trash)
- [ ] Delete `MRGestureApp.swift` (we have our own version)
- [ ] Keep `Assets.xcassets` (we'll use this)

---

## Step 3: Add Source Files (5 minutes)

### 3.1 Add Main App Files

- [ ] In Xcode Project Navigator, right-click **MRGesture** folder
- [ ] Select **Add Files to "MRGesture"...**
- [ ] Navigate to `MRGesture/MRGesture/` directory
- [ ] Select **App** folder
- [ ] ✅ Ensure "Create groups" is selected (NOT "Create folder references")
- [ ] ✅ Ensure **MRGesture** target is checked
- [ ] Click **Add**

Verify:
- [ ] `App/MRGestureApp.swift` appears in project
- [ ] `App/AppDelegate.swift` appears in project
- [ ] `App/Info.plist` appears in project

### 3.2 Add Core Files

Repeat for each folder:

- [ ] Add **Core/Vision** folder (3 files)
- [ ] Add **Core/Gestures** folder (5 files)
- [ ] Add **Core/Actions** folder (5 files)

**Total Core files**: 13 Swift files

### 3.3 Add UI Files

- [ ] Add **UI/Settings** folder (2 files)

### 3.4 Add Services Files

- [ ] Add **Services** folder (2 files)

### 3.5 Verify All Source Files Added

In Xcode Project Navigator, you should see:

```
MRGesture
├── App (3 files)
├── Core
│   ├── Vision (3 files)
│   ├── Gestures (5 files)
│   └── Actions (5 files)
├── UI
│   └── Settings (2 files)
├── Services (2 files)
└── Assets.xcassets
```

**Total**: 19 Swift files + 1 plist + Assets

- [ ] All files visible in Project Navigator
- [ ] No red (missing) files
- [ ] All files show MRGesture target membership

---

## Step 4: Configure Info.plist (2 minutes)

### 4.1 Set Custom Info.plist

- [ ] Select **MRGesture** project in navigator
- [ ] Select **MRGesture** target
- [ ] Go to **Build Settings** tab
- [ ] Search for "Info.plist"
- [ ] Set **Info.plist File** to: `MRGesture/App/Info.plist`

### 4.2 Verify Info.plist Contents

- [ ] Open `App/Info.plist` in Xcode
- [ ] Verify `NSCameraUsageDescription` exists
- [ ] Verify `LSUIElement` = YES
- [ ] Verify `LSMinimumSystemVersion` = 12.0

---

## Step 5: Configure Build Settings (3 minutes)

### 5.1 General Settings

- [ ] Select **MRGesture** target
- [ ] Go to **General** tab
- [ ] Set **Minimum Deployments** to **macOS 12.0**

### 5.2 Signing & Capabilities

- [ ] Go to **Signing & Capabilities** tab
- [ ] Select your **Team**
- [ ] Verify **Bundle Identifier** is correct
- [ ] **Signing Certificate**: Automatic (or select your certificate)

### 5.3 Add Hardened Runtime

- [ ] Click **+ Capability**
- [ ] Add **Hardened Runtime**
- [ ] Under **Resource Access**, enable:
  - [ ] ✅ **Camera**
- [ ] Under **Runtime Exceptions** (if needed for debugging):
  - [ ] ❌ Leave most unchecked

### 5.4 Disable App Sandbox

⚠️ **Critical for Accessibility APIs**:

- [ ] Go to **Build Settings** tab
- [ ] Search for "App Sandbox"
- [ ] Set **Enable App Sandbox** to **NO**

---

## Step 6: Add Test Files (2 minutes)

### 6.1 Add Test Target Files

- [ ] In Project Navigator, find **MRGestureTests** folder
- [ ] Delete default `MRGestureTests.swift` file
- [ ] Right-click **MRGestureTests** folder
- [ ] Select **Add Files to "MRGesture"...**
- [ ] Navigate to `MRGesture/MRGestureTests/` directory
- [ ] Select all 3 files:
  - `GestureDetectionTests.swift`
  - `MockHandPoseProvider.swift`
  - `Info.plist`
- [ ] ✅ Ensure **MRGestureTests** target is checked (NOT MRGesture)
- [ ] Click **Add**

### 6.2 Verify Test Configuration

- [ ] Open `MRGestureTests/Info.plist` in Xcode
- [ ] Select **MRGestureTests** target
- [ ] Go to **Build Settings**
- [ ] Search for "Info.plist"
- [ ] Set **Info.plist File** to: `MRGestureTests/Info.plist`

---

## Step 7: Build and Test (2 minutes)

### 7.1 First Build

- [ ] Select scheme: **MRGesture > My Mac**
- [ ] Press **Cmd+B** to build
- [ ] ✅ Build succeeds with 0 errors

**If build fails**:
- Check that all files are added to correct targets
- Verify Info.plist paths are correct
- Check that no red files exist

### 7.2 Run Tests

- [ ] Press **Cmd+U** to run tests
- [ ] ✅ All 26 tests pass

**Expected output**:
```
Test Suite 'All tests' passed
    Executed 26 tests, with 0 failures
```

### 7.3 Run Application

- [ ] Press **Cmd+R** to run
- [ ] ✅ App launches (menu bar icon appears)
- [ ] Camera permission prompt appears
- [ ] Click menu bar icon → menu appears

---

## Step 8: Final Verification (1 minute)

- [ ] No compiler warnings
- [ ] No runtime errors in console
- [ ] Menu bar icon visible
- [ ] Settings window opens from menu
- [ ] App quits cleanly from menu

---

## Troubleshooting

### "Cannot find type 'HandPose' in scope"
- **Fix**: Ensure all Core/Vision files are added to MRGesture target
- Check target membership in File Inspector (right sidebar)

### "Missing Info.plist"
- **Fix**: Set Info.plist path in Build Settings → Info.plist File

### "Code signing failed"
- **Fix**: Select a valid Team in Signing & Capabilities
- Ensure you're signed in to Xcode with Apple ID

### Tests don't appear
- **Fix**: Ensure test files are added to MRGestureTests target (not MRGesture)
- Product → Scheme → Manage Schemes → Ensure MRGestureTests is checked

### Build succeeds but app doesn't launch
- **Fix**: Check Console for runtime errors
- Verify LSUIElement = YES in Info.plist (app runs in menu bar, not dock)

---

## Success Criteria

✅ **Project Created Successfully When**:

- [ ] Build completes with 0 errors
- [ ] All 26 unit tests pass
- [ ] App launches and shows menu bar icon
- [ ] No red files in Project Navigator
- [ ] Code signing configured
- [ ] Camera permission prompt appears on first run

---

## Next Steps

Once Xcode project is created and building:

1. **Grant Permissions** (follow prompts)
   - Camera access
   - Accessibility access (System Preferences)

2. **Test Gestures**
   - Click menu bar → "Start Detection"
   - Make peace sign → Alfred should launch
   - Make thumbs up → Ghostty should activate
   - Swipe hand → Page should scroll

3. **Report Issues**
   - Use beads: `bd create --title="..." --type=bug`
   - See AGENTS.md for workflow

4. **Continue Development**
   - See `bd ready` for available tasks
   - P2 tasks: App icons, performance tuning, accuracy fixes

---

## Estimated Timeline

- ✅ **Step 1**: 2 minutes
- ✅ **Step 2**: 5 minutes
- ✅ **Step 3**: 5 minutes
- ✅ **Step 4**: 2 minutes
- ✅ **Step 5**: 3 minutes
- ✅ **Step 6**: 2 minutes
- ✅ **Step 7**: 2 minutes
- ✅ **Step 8**: 1 minute

**Total**: 20-25 minutes for complete setup

---

🎉 **Congratulations!** You now have a fully configured MRGesture Xcode project ready for development and testing!
