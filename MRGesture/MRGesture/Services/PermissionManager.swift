import Foundation
import AVFoundation
import ApplicationServices

struct PermissionStatus {
    let cameraGranted: Bool
    let accessibilityGranted: Bool

    var allGranted: Bool {
        cameraGranted && accessibilityGranted
    }
}

class PermissionManager {

    // MARK: - Permission Checking

    func checkPermissions() -> PermissionStatus {
        let cameraStatus = checkCameraPermission()
        let accessibilityStatus = checkAccessibilityPermission()

        return PermissionStatus(
            cameraGranted: cameraStatus,
            accessibilityGranted: accessibilityStatus
        )
    }

    // MARK: - Camera Permission

    func checkCameraPermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .authorized
    }

    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // MARK: - Accessibility Permission

    func checkAccessibilityPermission() -> Bool {
        return AXIsProcessTrusted()
    }

    func showAccessibilityInstructions() -> String {
        return """
        MRGesture needs Accessibility access to simulate scrolling and keyboard events.

        To enable:
        1. Open System Preferences (System Settings on macOS 13+)
        2. Go to Privacy & Security → Accessibility
        3. Add MRGesture to the list and enable it

        You may need to restart MRGesture after granting permission.
        """
    }

    // MARK: - System Preferences

    func openSystemPreferences() {
        // Open Privacy & Security preferences
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    func openCameraPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera") {
            NSWorkspace.shared.open(url)
        }
    }
}
