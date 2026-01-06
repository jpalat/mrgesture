import Foundation

// MARK: - Gesture Types

enum GestureType: Equatable {
    case peaceSign
    case thumbsUp
    case swipe(direction: SwipeDirection)

    var description: String {
        switch self {
        case .peaceSign:
            return "Peace Sign"
        case .thumbsUp:
            return "Thumbs Up"
        case .swipe(let direction):
            return "Swipe \(direction.rawValue)"
        }
    }
}

enum SwipeDirection: String, Equatable {
    case up = "Up"
    case down = "Down"
    case left = "Left"
    case right = "Right"
}

// MARK: - Gesture Detector Protocol

protocol GestureDetectorProtocol {
    /// The type of gesture this detector recognizes
    var gestureType: GestureType { get }

    /// Priority for detection (higher = checked first)
    var priority: Int { get }

    /// Detect gesture from hand pose
    /// Returns true if gesture is detected
    func detect(handPose: HandPose) -> Bool

    /// Reset any temporal state
    func reset()
}

// Default implementation for reset (optional for stateless detectors)
extension GestureDetectorProtocol {
    func reset() {
        // Default: no-op
    }
}
