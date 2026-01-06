import Foundation
import Cocoa

class ActionDispatcher {
    private let alfredLauncher = AlfredLauncher()
    private let appSwitcher = AppSwitcher()
    private let scrollSimulator = ScrollSimulator()

    // Track last action for debouncing
    private var lastActionTime: [String: Date] = [:]
    private let actionCooldown: TimeInterval = 0.5  // 500ms minimum between same action

    // MARK: - Dispatch

    func dispatch(gesture: GestureType) {
        let action = gesture.toAction()

        // Check cooldown (optional, gestures already have cooldown)
        let actionKey = action.description
        if let lastTime = lastActionTime[actionKey] {
            let timeSinceLastAction = Date().timeIntervalSince(lastTime)
            if timeSinceLastAction < actionCooldown {
                return  // Too soon, ignore
            }
        }

        // Execute action
        executeAction(action)

        // Update last action time
        lastActionTime[actionKey] = Date()

        print("🎯 Action executed: \(action.description)")
    }

    // MARK: - Action Execution

    private func executeAction(_ action: ActionType) {
        // Execute on main queue since we're interacting with UI/system
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            switch action {
            case .launchAlfred:
                self.alfredLauncher.launch()

            case .switchToGhostty:
                self.appSwitcher.switchToGhostty()

            case .scrollUp(let amount):
                self.scrollSimulator.scrollUp(amount: Int32(amount))

            case .scrollDown(let amount):
                self.scrollSimulator.scrollDown(amount: Int32(amount))

            case .scrollLeft(let amount):
                self.scrollSimulator.scrollLeft(amount: Int32(amount))

            case .scrollRight(let amount):
                self.scrollSimulator.scrollRight(amount: Int32(amount))
            }
        }
    }
}
