# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**MRGesture** is a native macOS application for hands-free control using real-time gesture recognition. The app uses your Mac's webcam to detect hand gestures and translate them into system-wide actions (scrolling, volume control, app switching, etc.).

### Key Technologies
- **macOS native** - Swift/Objective-C app targeting Apple Silicon
- **Apple Vision framework** - Real-time hand tracking and gesture recognition
- **On-device processing** - Privacy-first, no data leaves the Mac
- **Menu bar app** - Runs in background with system tray integration

## Issue Tracking with Beads

This project uses **beads** (`bd`) for issue tracking. All issues are stored in `.beads/issues.jsonl` and versioned with git.

### Essential bd Commands

```bash
# Finding work
bd ready                           # Show issues ready to work (no blockers)
bd list --status=open              # All open issues
bd show <id>                       # View detailed issue info

# Creating and updating
bd create --title="..." --type=task|bug|feature --priority=2
bd update <id> --status=in_progress
bd close <id>                      # Mark complete
bd close <id1> <id2> ...           # Close multiple at once

# Dependencies
bd dep add <issue> <depends-on>    # Add dependency
bd blocked                         # Show blocked issues

# Syncing
bd sync --from-main                # Pull beads updates from main
bd sync --status                   # Check sync status
```

**Priority levels**: 0-4 or P0-P4 (0=critical, 2=medium, 4=backlog). NOT "high"/"medium"/"low".

### Session Completion Workflow

Before ending any work session, complete ALL these steps:

1. **Create beads issues** for any remaining work or follow-up tasks
2. **Run quality checks** if code changed (tests, linters, build)
3. **Update beads status** - Close completed work, update in-progress items
4. **Git workflow**:
   ```bash
   git status                  # Check what changed
   git add <files>             # Stage changes
   bd sync --from-main         # Pull beads updates
   git commit -m "..."         # Commit with descriptive message
   git pull --rebase           # Sync with remote
   git push                    # Push to remote (MANDATORY)
   git status                  # Verify "up to date with origin"
   ```

**CRITICAL**: Work is NOT complete until `git push` succeeds. Never leave work stranded locally.

## Development Workflow

### macOS Development Setup
- Xcode required for Swift/Objective-C development
- Target: macOS (Apple Silicon optimized)
- Frameworks: Vision (gesture recognition), AppKit (menu bar UI)

### Architecture Principles
- **Privacy-first**: All processing on-device, no network calls
- **Low-latency**: Optimized for real-time gesture response
- **System-wide**: Works across all applications
- **Customizable**: User-defined gesture-to-action mappings
- **Lightweight**: Minimal CPU/GPU overhead

### Project Structure

```
MRGesture/MRGesture/
├── App/
│   ├── MRGestureApp.swift        # @main entry point
│   ├── AppDelegate.swift         # Menu bar lifecycle, pipeline wiring
│   └── Info.plist                # Permissions, bundle config
├── Core/
│   ├── Vision/
│   │   ├── CameraManager.swift        # AVCaptureSession (30 FPS)
│   │   ├── HandPoseDetector.swift     # VNDetectHumanHandPoseRequest
│   │   └── HandPoseModel.swift        # HandPose data structure, helper methods
│   ├── Gestures/
│   │   ├── GestureRecognizer.swift    # Orchestrates detectors, temporal smoothing
│   │   ├── GestureType.swift          # Gesture and direction enums
│   │   ├── PeaceSignDetector.swift    # ✌️ detection logic
│   │   ├── ThumbsUpDetector.swift     # 👍 detection logic
│   │   └── SwipeDetector.swift        # 👆 swipe tracking
│   └── Actions/
│       ├── ActionDispatcher.swift     # Routes gestures → actions
│       ├── ActionType.swift           # Action enum
│       ├── AlfredLauncher.swift       # Launch Alfred/Spotlight
│       ├── AppSwitcher.swift          # Activate Ghostty
│       └── ScrollSimulator.swift      # CGEvent scrolling
├── UI/
│   ├── MenuBar/
│   │   └── MenuBarController.swift    # (Integrated in AppDelegate)
│   └── Settings/
│       ├── SettingsView.swift         # SwiftUI settings window
│       └── PermissionsView.swift      # Permission status UI
└── Services/
    ├── PermissionManager.swift        # Camera + Accessibility checks
    └── ConfigurationManager.swift     # UserDefaults persistence
```

## Build and Run

### Setup
1. See [XCODE_SETUP.md](XCODE_SETUP.md) for detailed Xcode project creation
2. Add all source files to target
3. Configure code signing
4. Grant Camera and Accessibility permissions

### Development Commands
- **Build**: Cmd+B in Xcode
- **Run**: Cmd+R in Xcode
- **Test**: Cmd+U (when tests added)
- **Profile**: Cmd+I (Instruments)

## Key Implementation Details

### Gesture Detection Pipeline
```
CameraManager (AVCaptureSession)
    ↓ CVPixelBuffer (30 FPS)
HandPoseDetector (Vision framework)
    ↓ HandPose (21 landmarks)
GestureRecognizer (coordinates detectors)
    ↓ GestureType
ActionDispatcher (routes to actions)
    ↓ System actions (Alfred, Ghostty, Scroll)
```

### Gesture Algorithms

**Peace Sign** (`PeaceSignDetector.swift:14-72`):
- Index & middle fingers extended (tip > MCP by >15%)
- Ring & pinky curled (tip < MCP)
- Finger spread angle 15-45 degrees
- Temporal smoothing: 3 consecutive frames

**Thumbs Up** (`ThumbsUpDetector.swift:14-87`):
- Thumb extended far from palm (>40% hand size)
- All 4 fingers curled
- Thumb pointing upward (>60° from horizontal)
- Thumb above fist

**Swipes** (`SwipeDetector.swift:14-92`):
- Track palm center over 15 frames
- Detect movement >15% screen distance
- Calculate velocity threshold
- 500ms cooldown between swipes

### System Integration

**Alfred Launch** (`AlfredLauncher.swift`):
- NSWorkspace.launchApplication("Alfred")
- Fallback to AppleScript
- Final fallback to Spotlight

**Ghostty Switch** (`AppSwitcher.swift`):
- Find running app via NSRunningApplication
- Activate with `.activateIgnoringOtherApps`
- Launch if not running

**Scrolling** (`ScrollSimulator.swift`):
- CGEvent with scrollWheelEvent2Source
- Requires Accessibility permission (AXIsProcessTrusted)
- 30 pixel default scroll amount

## Performance Characteristics

- **Frame Rate**: 30 FPS (configurable 15-30)
- **Gesture Latency**: <100ms (camera → action)
- **CPU Usage**: <5% idle, <15% active
- **Temporal Smoothing**: 3-5 consecutive frames required
- **Cooldown**: 1 second for static gestures, 500ms for swipes

## Testing

### Manual Testing
1. Build and run in Xcode
2. Grant permissions
3. Click menu bar → "Start Detection"
4. Make gestures:
   - Peace sign → Alfred opens
   - Thumbs up → Ghostty activates
   - Swipe → Page scrolls

### Troubleshooting
- Check console for "✋ Detected" and "🎯 Action executed" logs
- Verify permissions in System Preferences
- Ensure good lighting and hand position (1-2 feet from camera)
- Check detector thresholds if accuracy is low

## Adding New Gestures

1. Create new detector file in `Core/Gestures/`
2. Conform to `GestureDetectorProtocol`
3. Implement `detect(handPose:)` logic using `HandPose` helper methods
4. Add to `GestureRecognizer.registerDetectors()`
5. Add action mapping in `ActionType.swift`

Example:
```swift
class NewGestureDetector: GestureDetectorProtocol {
    var gestureType: GestureType { .newGesture }
    var priority: Int { 10 }

    func detect(handPose: HandPose) -> Bool {
        // Use handPose.isFingerExtended(), .angle(), etc.
        return /* detection logic */
    }
}
```
