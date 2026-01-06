import Foundation

class GestureRecognizer {
    private var detectors: [GestureDetectorProtocol] = []
    private let configurationManager: ConfigurationManager

    // Temporal smoothing: require N consecutive detections
    private let requiredConsecutiveFrames = 3
    private var detectionHistory: [(gesture: GestureType, timestamp: Date)] = []

    // Debouncing: cooldown per gesture type
    private var lastGestureTime: [GestureType: Date] = [:]
    private let gestureCooldown: TimeInterval = 1.0  // 1 second between same gesture

    init(configurationManager: ConfigurationManager = ConfigurationManager()) {
        self.configurationManager = configurationManager
        registerDetectors()
    }

    // MARK: - Detector Registration

    private func registerDetectors() {
        // Register all gesture detectors
        // Higher priority detectors are checked first
        detectors = [
            PeaceSignDetector(configurationManager: configurationManager),     // Priority 10
            ThumbsUpDetector(configurationManager: configurationManager),      // Priority 10
            SwipeDetector(configurationManager: configurationManager)          // Priority 5
        ]

        // Sort by priority (descending)
        detectors.sort { $0.priority > $1.priority }
    }

    // MARK: - Recognition

    func recognize(handPose: HandPose) -> GestureType? {
        // Try each detector in priority order
        for detector in detectors {
            if detector.detect(handPose: handPose) {
                let gesture = detector.gestureType

                // Add to history
                detectionHistory.append((gesture: gesture, timestamp: Date()))

                // Keep only recent history
                let cutoffTime = Date().addingTimeInterval(-1.0)
                detectionHistory = detectionHistory.filter { $0.timestamp > cutoffTime }

                // Check if we have enough consecutive detections
                let recentDetections = detectionHistory.suffix(requiredConsecutiveFrames)
                if recentDetections.count >= requiredConsecutiveFrames &&
                   recentDetections.allSatisfy({ $0.gesture == gesture }) {

                    // Check cooldown
                    if shouldTriggerGesture(gesture) {
                        // Update last trigger time
                        lastGestureTime[gesture] = Date()

                        print("✋ Detected: \(gesture.description)")
                        return gesture
                    }
                }

                // Gesture detected but not triggered yet
                return nil
            }
        }

        // No gesture detected - clear history
        detectionHistory.removeAll()
        return nil
    }

    // MARK: - Cooldown Management

    private func shouldTriggerGesture(_ gesture: GestureType) -> Bool {
        // For swipe gestures, cooldown is handled in SwipeDetector itself
        if case .swipe = gesture {
            return true
        }

        // For static gestures (peace, thumbs up), apply cooldown here
        guard let lastTime = lastGestureTime[gesture] else {
            return true  // Never triggered before
        }

        let timeSinceLastTrigger = Date().timeIntervalSince(lastTime)
        return timeSinceLastTrigger >= gestureCooldown
    }

    // MARK: - Reset

    func reset() {
        detectionHistory.removeAll()
        lastGestureTime.removeAll()

        // Reset all detector states
        for detector in detectors {
            detector.reset()
        }
    }
}
