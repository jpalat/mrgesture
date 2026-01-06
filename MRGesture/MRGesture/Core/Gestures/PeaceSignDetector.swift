import Foundation
import Vision
import CoreGraphics

/// Detects peace sign gesture (V-shape with index and middle fingers extended)
class PeaceSignDetector: GestureDetectorProtocol {
    var gestureType: GestureType { .peaceSign }
    var priority: Int { 10 }  // High priority (static gesture)

    // Configuration thresholds
    private let minFingerSpread: CGFloat = 15.0   // degrees
    private let maxFingerSpread: CGFloat = 50.0   // degrees
    private let fingerExtensionThreshold: CGFloat = 0.15  // Relative to hand size
    private let fingerCurlThreshold: CGFloat = 0.05       // Relative to hand size

    func detect(handPose: HandPose) -> Bool {
        // 1. Check index and middle fingers are extended
        guard handPose.isFingerExtended(.index, threshold: fingerExtensionThreshold),
              handPose.isFingerExtended(.middle, threshold: fingerExtensionThreshold) else {
            return false
        }

        // 2. Check ring and pinky fingers are curled
        guard handPose.isFingerCurled(.ring, threshold: fingerCurlThreshold),
              handPose.isFingerCurled(.pinky, threshold: fingerCurlThreshold) else {
            return false
        }

        // 3. Check thumb is neutral or curled (not extended)
        // Thumb can be in various positions for peace sign
        // We just make sure it's not prominently extended upward
        if let thumbTip = handPose.landmark(.thumbTip),
           let wrist = handPose.landmark(.wrist),
           let indexTip = handPose.landmark(.indexTip) {
            // Thumb should not be significantly higher than index finger
            let thumbExtension = wrist.y - thumbTip.y
            let indexExtension = wrist.y - indexTip.y

            // If thumb is extended more than index, this might be a different gesture
            if thumbExtension > indexExtension * 1.2 {
                return false
            }
        }

        // 4. Measure angle between index and middle fingers
        if let angle = handPose.angle(
            from: .indexTip,
            vertex: .indexMCP,  // Use MCP as vertex for finger spread
            to: .middleTip
        ) {
            // Angle should be within spread range
            if angle < minFingerSpread || angle > maxFingerSpread {
                return false
            }
        } else {
            // If we can't measure angle, be lenient
            // (fingers might be at extreme positions)
        }

        // 5. Verify hand is generally upright (optional but helps accuracy)
        // Wrist should be below (higher Y value) finger tips
        if let wrist = handPose.landmark(.wrist),
           let indexTip = handPose.landmark(.indexTip) {
            if wrist.y < indexTip.y {
                // Hand is upside down
                return false
            }
        }

        // All checks passed!
        return true
    }
}
