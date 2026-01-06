# MRGesture Icon Assets

This directory contains placeholder configurations for app icons and menu bar icons.

## Required Icons

### App Icon (AppIcon.appiconset)
The main application icon shown in Finder, Spotlight, etc.

**Sizes needed** (all PNG format):
- 16x16 @ 1x = 16x16px
- 16x16 @ 2x = 32x32px
- 32x32 @ 1x = 32x32px
- 32x32 @ 2x = 64x64px
- 128x128 @ 1x = 128x128px
- 128x128 @ 2x = 256x256px
- 256x256 @ 1x = 256x256px
- 256x256 @ 2x = 512x512px
- 512x512 @ 1x = 512x512px
- 512x512 @ 2x = 1024x1024px

**Design recommendations**:
- Use a hand gesture icon (open palm, peace sign, or thumbs up)
- Simple, recognizable design
- Works at small sizes (16x16)
- Consistent with macOS Big Sur icon style
- Consider rounded square with gradient background

### Menu Bar Icons (MenuBarIcon.imageset, MenuBarIconActive.imageset)
Small monochrome icons shown in the macOS menu bar.

**Sizes needed**:
- 16x16 @ 1x = 16x16px
- 16x16 @ 2x = 32x32px

**Design requirements**:
- **Monochrome** (black on transparent background)
- **Template mode**: System will automatically apply proper coloring
- **Simple design**: Must be readable at 16x16px
- **Inactive state**: Outline or lighter version
- **Active state**: Filled or bolder version

**Suggested designs**:
- Hand silhouette (open palm)
- Simple hand icon with fingers
- Gesture symbol (✋ or similar)

## Using SF Symbols (Recommended)

Instead of custom PNG files, you can use Apple's SF Symbols in code:

```swift
// In MenuBarController or AppDelegate
let inactiveIcon = NSImage(systemSymbolName: "hand.raised", accessibilityDescription: "MRGesture")
let activeIcon = NSImage(systemSymbolName: "hand.raised.fill", accessibilityDescription: "MRGesture Active")

inactiveIcon?.isTemplate = true
activeIcon?.isTemplate = true
```

**Advantages**:
- No custom images needed
- Automatically matches system appearance
- Perfect rendering at all sizes
- Supports dark mode automatically

**Available SF Symbols**:
- `hand.raised` - Open palm (outline)
- `hand.raised.fill` - Open palm (filled)
- `hand.point.up` - Pointing finger
- `hand.thumbsup` - Thumbs up
- `hand.wave` - Waving hand

## Creating Custom Icons

### Tools
- **Sketch** - Professional design tool
- **Figma** - Free, web-based design tool
- **Icon Slate** - macOS icon generator
- **SF Symbols App** - Browse and customize Apple icons

### Export Settings
- Format: PNG
- Color space: sRGB
- Alpha channel: Yes (transparency)
- Compression: None or lossless

### Online Resources
- [macOS Icon Gallery](https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/app-icon/)
- [SF Symbols Browser](https://developer.apple.com/sf-symbols/)
- [Free Icon Generators](https://www.appicon.co/)

## Placeholder Status

Currently, only JSON configurations are provided. Actual PNG files need to be added.

**To complete**:
1. Create app icon design (1024x1024 master)
2. Export all required sizes
3. Add PNG files to AppIcon.appiconset/
4. Create menu bar icon design (32x32 master)
5. Export 1x and 2x versions
6. Add PNG files to MenuBarIcon.imageset/ and MenuBarIconActive.imageset/

**OR**:

Use SF Symbols in code (no PNG files needed) - **Recommended for MVP**
