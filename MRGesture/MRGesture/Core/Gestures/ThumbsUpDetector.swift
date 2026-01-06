import Foundation
import Vision
import CoreGraphics

/// Detects thumbs up gesture (thumb extended, all fingers curled)
class ThumbsUpDetector: GestureDetectorProtocol {
    var gestureType: GestureType { .thumbsUp }
    var priority: Int { 10 }  // High priority (static gesture)

    // Base configuration thresholds (at 1.0x sensitivity)
    private let baseThumbExtensionThreshold: CGFloat = 0.4   // Thumb should be this far from palm
    private let baseFingerCurlThreshold: CGFloat = 0.08      // Relative to hand size
    private let basePalmDistanceThreshold: CGFloat = 0.3     // Minimum thumb-to-palm distance
    private let minUpwardAngle: CGFloat = 60.0               // degrees from horizontal

    private let configurationManager: ConfigurationManager

    init(configurationManager: ConfigurationManager = ConfigurationManager()) {
        self.configurationManager = configurationManager
    }

    func detect(handPose: HandPose) -> Bool {
        // Get current sensitivity (higher = more lenient)
        let sensitivity = CGFloat(configurationManager.gestureSensitivity)

        // Adjust thresholds based on sensitivity
        // Higher sensitivity → lower thresholds → easier detection
        let thumbExtensionThreshold = baseThumbExtensionThreshold / sensitivity
        let fingerCurlThreshold = baseFingerCurlThreshold / sensitivity
        let palmDistanceThreshold = basePalmDistanceThreshold / sensitivity
        // 1. Check that thumb is extended
        guard let thumbTip = handPose.landmark(.thumbTip),
              let thumbIP = handPose.landmark(.thumbIP),
              let wrist = handPose.landmark(.wrist) else {
            return false
        }

        // Thumb should be far from wrist
        let thumbExtension = hypot(thumbTip.x - wrist.x, thumbTip.y - wrist.y)

        // Normalize by hand size
        guard let handSize = handPose.handSize() else {
            return false
        }

        let normalizedThumbExtension = thumbExtension / handSize
        if normalizedThumbExtension < thumbExtensionThreshold {
            return false
        }

        // 2. Check that all four fingers are curled
        let fingers: [Finger] = [.index, .middle, .ring, .pinky]
        for finger in fingers {
            if !handPose.isFingerCurled(finger, threshold: fingerCurlThreshold) {
                return false
            }
        }

        // 3. Verify thumb is pointing upward (or at least not downward)
        // Calculate thumb angle from horizontal
        let thumbVector = CGPoint(x: thumbTip.x - thumbIP.x, y: thumbTip.y - thumbIP.y)
        let angleFromHorizontal = abs(atan2(thumbVector.y, thumbVector.x) * 180.0 / .pi)

        // Thumb should be relatively vertical (angle close to 90 degrees)
        if angleFromHorizontal < minUpwardAngle {
            return false
        }

        // 4. Verify thumb is above the fist (Y coordinate check)
        // In Vision coordinates, smaller Y = higher on screen
        if let indexMCP = handPose.landmark(.indexMCP) {
            if thumbTip.y > indexMCP.y {
                // Thumb is below the fist, probably thumbs down or different gesture
                return false
            }
        }

        // 5. Additional check: thumb should be extended perpendicular to palm
        // Calculate distance from thumb tip to palm center
        if let palmCenter = handPose.palmCenter() {
            let thumbPalmDistance = hypot(thumbTip.x - palmCenter.x, thumbTip.y - palmCenter.y)
            let normalizedDistance = thumbPalmDistance / handSize

            // Thumb should be reasonably far from palm center
            if normalizedDistance < palmDistanceThreshold {
                return false
            }
        }

        // All checks passed!
        return true
    }
}
