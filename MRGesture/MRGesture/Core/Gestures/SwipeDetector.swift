import Foundation
import CoreGraphics

/// Detects swipe gestures based on palm movement over time
class SwipeDetector: GestureDetectorProtocol {
    var priority: Int { 5 }  // Lower priority than static gestures

    // Direction tracking (must be declared before gestureType)
    private var detectedDirection: SwipeDirection = .up

    // Dynamic gestureType based on detected direction
    var gestureType: GestureType {
        return .swipe(direction: detectedDirection)
    }

    // Base configuration thresholds (at 1.0x sensitivity)
    private let historyFrames = 15                        // Track last 15 frames
    private let baseMinSwipeDistance: CGFloat = 0.15      // 15% of screen (normalized coordinates)
    private let baseMinVelocity: CGFloat = 0.01           // Minimum velocity threshold
    private let swipeCooldown: TimeInterval = 0.5         // 500ms between swipes
    private let detectionSustainFrames = 3                // Keep returning true for temporal smoothing

    private let configurationManager: ConfigurationManager

    init(configurationManager: ConfigurationManager = ConfigurationManager()) {
        self.configurationManager = configurationManager
    }

    // State tracking
    private var palmPositionHistory: [(position: CGPoint, timestamp: Date)] = []
    private var lastSwipeTime: Date?
    private var framesRemainingToSustain = 0              // Frames left to keep returning true

    func detect(handPose: HandPose) -> Bool {
        // If we're sustaining a previous detection for temporal smoothing
        if framesRemainingToSustain > 0 {
            framesRemainingToSustain -= 1
            return true
        }

        // Get current sensitivity (higher = more lenient)
        let sensitivity = CGFloat(configurationManager.gestureSensitivity)

        // Adjust thresholds based on sensitivity
        // Higher sensitivity → lower thresholds → easier detection
        let minSwipeDistance = baseMinSwipeDistance / sensitivity
        let minVelocity = baseMinVelocity / sensitivity

        // Get current palm center
        guard let palmCenter = handPose.palmCenter() else {
            return false
        }

        // Add to history
        palmPositionHistory.append((position: palmCenter, timestamp: Date()))

        // Keep only recent history
        if palmPositionHistory.count > historyFrames {
            palmPositionHistory.removeFirst()
        }

        // Need enough history to detect a swipe
        guard palmPositionHistory.count >= 10 else {
            return false
        }

        // Check cooldown
        if let lastTime = lastSwipeTime {
            let timeSinceLastSwipe = Date().timeIntervalSince(lastTime)
            if timeSinceLastSwipe < swipeCooldown {
                return false
            }
        }

        // Calculate movement vector from start to end of history
        let start = palmPositionHistory.first!.position
        let end = palmPositionHistory.last!.position

        let deltaX = end.x - start.x
        let deltaY = end.y - start.y
        let distance = hypot(deltaX, deltaY)

        // Check if movement is significant
        if distance < minSwipeDistance {
            return false
        }

        // Calculate velocity (distance / time)
        let timeSpan = palmPositionHistory.last!.timestamp.timeIntervalSince(palmPositionHistory.first!.timestamp)
        guard timeSpan > 0 else { return false }

        let velocity = distance / CGFloat(timeSpan)
        if velocity < minVelocity {
            return false
        }

        // Determine swipe direction
        // Favor the dominant axis
        let absX = abs(deltaX)
        let absY = abs(deltaY)

        if absY > absX {
            // Vertical swipe
            if deltaY < 0 {
                // Moving up (remember Y increases downward)
                detectedDirection = .up
            } else {
                // Moving down
                detectedDirection = .down
            }
        } else {
            // Horizontal swipe
            if deltaX > 0 {
                // Moving right
                detectedDirection = .right
            } else {
                // Moving left
                detectedDirection = .left
            }
        }

        // Update last swipe time
        lastSwipeTime = Date()

        // Clear history to prepare for next swipe
        palmPositionHistory.removeAll()

        // Sustain detection for temporal smoothing (3 frames total including this one)
        framesRemainingToSustain = detectionSustainFrames - 1

        return true
    }

    func reset() {
        palmPositionHistory.removeAll()
        lastSwipeTime = nil
        detectedDirection = .up  // Reset to default
        framesRemainingToSustain = 0
    }
}
