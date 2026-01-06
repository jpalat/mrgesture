import Foundation

class ConfigurationManager {
    private let defaults = UserDefaults.standard

    // User Preference Keys
    private enum Keys {
        static let detectionEnabled = "detectionEnabled"
        static let frameRate = "frameRate"
        static let scrollAmount = "scrollAmount"
        static let gestureSensitivity = "gestureSensitivity"
    }

    // MARK: - Detection State

    var isDetectionEnabled: Bool {
        get { defaults.bool(forKey: Keys.detectionEnabled) }
        set { defaults.set(newValue, forKey: Keys.detectionEnabled) }
    }

    // MARK: - Performance Settings

    var frameRate: Int {
        get {
            let rate = defaults.integer(forKey: Keys.frameRate)
            return rate > 0 ? rate : 30  // Default 30 FPS
        }
        set {
            let clamped = min(max(newValue, 15), 30)  // Clamp 15-30 FPS
            defaults.set(clamped, forKey: Keys.frameRate)
        }
    }

    var scrollAmount: Int {
        get {
            let amount = defaults.integer(forKey: Keys.scrollAmount)
            return amount > 0 ? amount : 30  // Default 30 pixels
        }
        set {
            let clamped = min(max(newValue, 10), 100)  // Clamp 10-100 pixels
            defaults.set(clamped, forKey: Keys.scrollAmount)
        }
    }

    // MARK: - Gesture Settings

    var gestureSensitivity: Double {
        get {
            let sensitivity = defaults.double(forKey: Keys.gestureSensitivity)
            return sensitivity > 0 ? sensitivity : 1.0  // Default 1.0 (normal)
        }
        set {
            let clamped = min(max(newValue, 0.5), 2.0)  // Clamp 0.5-2.0
            defaults.set(clamped, forKey: Keys.gestureSensitivity)
        }
    }

    // MARK: - Reset to Defaults

    func resetToDefaults() {
        defaults.removeObject(forKey: Keys.detectionEnabled)
        defaults.removeObject(forKey: Keys.frameRate)
        defaults.removeObject(forKey: Keys.scrollAmount)
        defaults.removeObject(forKey: Keys.gestureSensitivity)
    }
}
