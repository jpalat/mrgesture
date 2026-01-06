# MRGesture

**Hands-free control for your Mac using real-time gesture recognition.**

MRGesture is a native macOS menu bar application that transforms your webcam into a powerful input device. Control your Mac with intuitive hand gestures — launch apps, scroll through documents, and switch between applications, all without touching your keyboard or mouse.

---

## Features

- **Real-time gesture recognition** — Low-latency hand tracking powered by Apple's Vision framework
- **System-wide automation** — Control any application with gesture-to-action mappings
- **Privacy-first design** — All processing happens on-device; no data leaves your Mac
- **Lightweight and efficient** — Optimized for Apple Silicon with minimal CPU/GPU overhead (<15% CPU)
- **Menu bar integration** — Runs quietly in your menu bar with quick-access controls

## Current Gestures (MVP)

| Gesture | Action | Description |
|---------|--------|-------------|
| ✌️ Peace Sign | Launch Alfred | Opens Alfred app launcher (or Spotlight if not installed) |
| 👍 Thumbs Up | Switch to Ghostty | Brings Ghostty terminal to foreground |
| 👆 Swipe Up | Scroll Up | Scrolls the active window upward |
| 👇 Swipe Down | Scroll Down | Scrolls the active window downward |

---

## Requirements

- macOS 12.0 or later
- Xcode 14.0 or later (for building)
- Camera permission (for hand gesture detection)
- Accessibility permission (for scrolling functionality)
- Webcam (built-in or external)

---

## Quick Start

### 1. Build the Project

See [XCODE_SETUP.md](XCODE_SETUP.md) for detailed instructions on creating and configuring the Xcode project.

**Quick steps:**
1. Open Xcode and create a new macOS App project
2. Add all source files from `MRGesture/MRGesture/` to the project
3. Configure code signing with your Apple Developer account
4. Build and run (Cmd+R)

### 2. Grant Permissions

On first launch:
- **Camera Access**: Allow when prompted
- **Accessibility Access**:
  - Go to System Preferences → Privacy & Security → Accessibility
  - Add MRGesture and enable it
  - Restart the app

### 3. Start Detecting Gestures

1. Click the hand icon in your menu bar
2. Select "Start Detection"
3. Make gestures in front of your camera
4. Watch the magic happen!

---

## Architecture

MRGesture uses a clean pipeline architecture:

```
Camera Feed (30 FPS)
    ↓
Vision Framework (Hand Pose Detection)
    ↓
Gesture Recognition (Peace Sign, Thumbs Up, Swipes)
    ↓
Action Dispatch (Alfred, Ghostty, Scrolling)
```

### Key Components

- **CameraManager**: AVFoundation capture session management
- **HandPoseDetector**: Vision framework integration for 21-point hand tracking
- **GestureRecognizer**: Orchestrates gesture detectors with temporal smoothing
- **ActionDispatcher**: Routes gestures to system actions
- **Individual Detectors**: PeaceSignDetector, ThumbsUpDetector, SwipeDetector

See [CLAUDE.md](CLAUDE.md) for development guidance.

---

## Development

### Project Structure

```
MRGesture/
├── App/                    # App entry point and lifecycle
├── Core/
│   ├── Vision/            # Camera and hand pose detection
│   ├── Gestures/          # Gesture recognition logic
│   └── Actions/           # System automation (launch apps, scroll)
├── UI/
│   ├── MenuBar/           # Menu bar integration
│   └── Settings/          # Settings window (SwiftUI)
└── Services/              # Permission and configuration management
```

### Building from Source

```bash
# Clone the repository
git clone <your-repo-url>
cd mrgesture

# Open in Xcode
open MRGesture/MRGesture.xcodeproj

# Or follow XCODE_SETUP.md to create the project
```

### Testing

- Unit tests for gesture detection with mock hand poses
- Manual integration testing for end-to-end gestures
- Performance profiling with Xcode Instruments

---

## Troubleshooting

### Camera not working
- Check camera permission in System Preferences → Privacy & Security → Camera
- Ensure no other app is using the camera
- Check console for error messages

### Gestures not detected
- Ensure good lighting
- Hold hand steady for 3-5 frames
- Position hand 1-2 feet from camera
- Check console for "✋ Detected" messages

### Scrolling not working
- Grant Accessibility permission in System Preferences
- Restart app after granting permission
- Check console for permission warnings

### Alfred/Ghostty not launching
- Verify apps are installed in `/Applications/`
- For Alfred: will fall back to Spotlight
- For Ghostty: notification shown if not found

---

## Roadmap

Future enhancements:
- [ ] Custom gesture builder UI
- [ ] More gestures (pinch, rotation, two-hand)
- [ ] Configurable action mappings
- [ ] Gesture combos (chained gestures)
- [ ] macOS Shortcuts integration
- [ ] Haptic feedback on detection
- [ ] Performance dashboard

---

## Contributing

This project uses **beads** for issue tracking. To contribute:

```bash
# Install beads
curl -sSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# Find available work
bd ready

# Create an issue
bd create --title="Add new gesture" --type=feature

# See AGENTS.md for workflow details
```

---

## License

MIT License - See LICENSE file for details

---

## Acknowledgments

- Apple Vision framework for hand pose detection
- macOS Accessibility APIs for system control
- The gesture recognition community for inspiration

