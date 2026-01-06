import Foundation

// MARK: - Action Types

enum ActionType {
    case launchAlfred
    case switchToGhostty
    case scrollUp(amount: Int)
    case scrollDown(amount: Int)
    case scrollLeft(amount: Int)
    case scrollRight(amount: Int)

    var description: String {
        switch self {
        case .launchAlfred:
            return "Launch Alfred"
        case .switchToGhostty:
            return "Switch to Ghostty"
        case .scrollUp(let amount):
            return "Scroll Up (\(amount)px)"
        case .scrollDown(let amount):
            return "Scroll Down (\(amount)px)"
        case .scrollLeft(let amount):
            return "Scroll Left (\(amount)px)"
        case .scrollRight(let amount):
            return "Scroll Right (\(amount)px)"
        }
    }
}

// MARK: - Gesture to Action Mapping

extension GestureType {
    /// Get the action associated with this gesture
    func toAction() -> ActionType {
        switch self {
        case .peaceSign:
            return .launchAlfred

        case .thumbsUp:
            return .switchToGhostty

        case .swipe(let direction):
            let scrollAmount = 30  // pixels
            switch direction {
            case .up:
                return .scrollUp(amount: scrollAmount)
            case .down:
                return .scrollDown(amount: scrollAmount)
            case .left:
                return .scrollLeft(amount: scrollAmount)
            case .right:
                return .scrollRight(amount: scrollAmount)
            }
        }
    }
}
