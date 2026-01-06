import Foundation
import Cocoa

class AppSwitcher {

    private let ghosttyBundleIdentifiers = [
        "com.mitchellh.ghostty",
        "com.ghostty.Ghostty",
        "ghostty"
    ]

    func switchToGhostty() {
        // Try to find Ghostty in running applications
        let runningApps = NSWorkspace.shared.runningApplications

        // First, try to find by bundle identifier
        for bundleId in ghosttyBundleIdentifiers {
            if let ghostty = runningApps.first(where: { $0.bundleIdentifier == bundleId }) {
                activateApp(ghostty)
                return
            }
        }

        // Try to find by app name
        if let ghostty = runningApps.first(where: { $0.localizedName?.lowercased() == "ghostty" }) {
            activateApp(ghostty)
            return
        }

        // Ghostty is not running, try to launch it
        print("ℹ️ Ghostty not running, attempting to launch...")
        if launchGhostty() {
            print("✓ Launched Ghostty")
        } else {
            print("❌ Failed to launch Ghostty - is it installed?")
            showGhosttyNotFoundNotification()
        }
    }

    // MARK: - Helper Methods

    private func activateApp(_ app: NSRunningApplication) {
        app.activate(options: .activateIgnoringOtherApps)
        print("✓ Switched to \(app.localizedName ?? "Ghostty")")
    }

    private func launchGhostty() -> Bool {
        // Try to launch Ghostty
        let success = NSWorkspace.shared.launchApplication("Ghostty")

        if !success {
            // Try alternate app path
            let appPath = "/Applications/Ghostty.app"
            if FileManager.default.fileExists(atPath: appPath) {
                let url = URL(fileURLWithPath: appPath)
                do {
                    try NSWorkspace.shared.launchApplication(at: url, options: [], configuration: [:])
                    return true
                } catch {
                    return false
                }
            }
        }

        return success
    }

    private func showGhosttyNotFoundNotification() {
        DispatchQueue.main.async {
            let notification = NSUserNotification()
            notification.title = "Ghostty Not Found"
            notification.informativeText = "Please install Ghostty to use this gesture."
            notification.soundName = NSUserNotificationDefaultSoundName

            NSUserNotificationCenter.default.deliver(notification)
        }
    }

    // MARK: - Check if Ghostty is installed

    func isGhosttyInstalled() -> Bool {
        // Check by bundle identifier
        for bundleId in ghosttyBundleIdentifiers {
            if NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) != nil {
                return true
            }
        }

        // Check in Applications folder
        let appPath = "/Applications/Ghostty.app"
        return FileManager.default.fileExists(atPath: appPath)
    }
}
