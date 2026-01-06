import Foundation
import Cocoa

class AlfredLauncher {

    // Try different Alfred app names (Alfred 5, Alfred 4, or just Alfred)
    private let alfredAppNames = ["Alfred", "Alfred 5", "Alfred 4"]

    func launch() {
        // Try launching via NSWorkspace
        for appName in alfredAppNames {
            if launchApp(named: appName) {
                print("✓ Launched \(appName)")
                return
            }
        }

        // Fallback: Try AppleScript
        if launchViaAppleScript() {
            print("✓ Launched Alfred via AppleScript")
            return
        }

        // If Alfred not found, fallback to Spotlight
        print("⚠️ Alfred not found, falling back to Spotlight")
        launchSpotlight()
    }

    // MARK: - Launch Methods

    private func launchApp(named appName: String) -> Bool {
        // Try to launch directly
        let success = NSWorkspace.shared.launchApplication(appName)

        if !success {
            // Try to find app in Applications folder
            let appPath = "/Applications/\(appName).app"
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

    private func launchViaAppleScript() -> Bool {
        let script = """
        tell application "Alfred 5"
            activate
        end tell
        """

        guard let appleScript = NSAppleScript(source: script) else {
            return false
        }

        var error: NSDictionary?
        appleScript.executeAndReturnError(&error)

        return error == nil
    }

    private func launchSpotlight() {
        // Activate Spotlight (Cmd+Space)
        let script = """
        tell application "System Events"
            keystroke space using {command down}
        end tell
        """

        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)

            if let error = error {
                print("⚠️ Failed to activate Spotlight: \(error)")
            }
        }
    }

    // MARK: - Check if Alfred is installed

    func isAlfredInstalled() -> Bool {
        for appName in alfredAppNames {
            if NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.runningwithcrayons.Alfred") != nil {
                return true
            }

            let appPath = "/Applications/\(appName).app"
            if FileManager.default.fileExists(atPath: appPath) {
                return true
            }
        }

        return false
    }
}
