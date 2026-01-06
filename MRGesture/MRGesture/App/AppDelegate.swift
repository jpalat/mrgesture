import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var cameraManager: CameraManager?
    private var handPoseDetector: HandPoseDetector?
    private var gestureRecognizer: GestureRecognizer?
    private var actionDispatcher: ActionDispatcher?
    private var permissionManager: PermissionManager?
    private var isDetectionActive = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize services
        permissionManager = PermissionManager()
        cameraManager = CameraManager()
        handPoseDetector = HandPoseDetector()
        gestureRecognizer = GestureRecognizer()
        actionDispatcher = ActionDispatcher()

        // Setup menu bar
        setupMenuBar()

        // Wire up the pipeline
        setupPipeline()

        // Check permissions on launch
        checkPermissions()
    }

    func applicationWillTerminate(_ notification: Notification) {
        stopDetection()
    }

    // MARK: - Menu Bar Setup

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "hand.raised", accessibilityDescription: "MRGesture")
            button.image?.isTemplate = true
        }

        updateMenu()
    }

    private func updateMenu() {
        let menu = NSMenu()

        // Start/Stop toggle
        let toggleTitle = isDetectionActive ? "Stop Detection" : "Start Detection"
        let toggleItem = NSMenuItem(title: toggleTitle, action: #selector(toggleDetection), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(NSMenuItem.separator())

        // Settings
        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        // About
        let aboutItem = NSMenuItem(title: "About MRGesture", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(title: "Quit MRGesture", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    // MARK: - Pipeline Setup

    private func setupPipeline() {
        guard let handPoseDetector = handPoseDetector,
              let gestureRecognizer = gestureRecognizer,
              let actionDispatcher = actionDispatcher else {
            return
        }

        // Camera -> HandPose detection
        cameraManager?.onFrameProcessed = { [weak self] handPose in
            guard let self = self else { return }

            // Gesture recognition
            if let gesture = gestureRecognizer.recognize(handPose: handPose) {
                // Dispatch action
                actionDispatcher.dispatch(gesture: gesture)
            }
        }
    }

    // MARK: - Permission Checking

    private func checkPermissions() {
        guard let permissionManager = permissionManager else { return }

        let status = permissionManager.checkPermissions()

        if !status.cameraGranted {
            permissionManager.requestCameraAccess { granted in
                if !granted {
                    self.showPermissionAlert(for: "Camera")
                }
            }
        }

        if !status.accessibilityGranted {
            // Will show in settings UI
            print("⚠️ Accessibility permission not granted. Scrolling will not work.")
        }
    }

    private func showPermissionAlert(for permission: String) {
        let alert = NSAlert()
        alert.messageText = "\(permission) Access Required"
        alert.informativeText = "MRGesture needs \(permission) access to function properly. Please grant access in System Preferences."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Cancel")

        if alert.runModal() == .alertFirstButtonReturn {
            permissionManager?.openSystemPreferences()
        }
    }

    // MARK: - Detection Control

    @objc private func toggleDetection() {
        if isDetectionActive {
            stopDetection()
        } else {
            startDetection()
        }
    }

    private func startDetection() {
        guard let status = permissionManager?.checkPermissions(), status.cameraGranted else {
            showPermissionAlert(for: "Camera")
            return
        }

        cameraManager?.startSession()
        isDetectionActive = true
        updateMenu()
        updateStatusIcon(active: true)
        print("✓ Gesture detection started")
    }

    private func stopDetection() {
        cameraManager?.stopSession()
        isDetectionActive = false
        updateMenu()
        updateStatusIcon(active: false)
        print("✓ Gesture detection stopped")
    }

    private func updateStatusIcon(active: Bool) {
        if let button = statusItem?.button {
            let symbolName = active ? "hand.raised.fill" : "hand.raised"
            button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "MRGesture")
            button.image?.isTemplate = true
        }
    }

    // MARK: - Menu Actions

    @objc private func openSettings() {
        let settingsView = SettingsView(permissionManager: permissionManager ?? PermissionManager())
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = "MRGesture Settings"
        window.styleMask = [.titled, .closable]
        window.setContentSize(NSSize(width: 500, height: 400))
        window.center()
        window.makeKeyAndOrderFront(nil)

        // Keep window alive
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "MRGesture"
        alert.informativeText = "Version 1.0.0\n\nHands-free control for your Mac using real-time gesture recognition.\n\nAll processing happens on-device."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @objc private func quit() {
        stopDetection()
        NSApplication.shared.terminate(nil)
    }
}
