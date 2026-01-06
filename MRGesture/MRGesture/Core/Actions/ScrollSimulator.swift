import Foundation
import CoreGraphics
import ApplicationServices

class ScrollSimulator {

    private let defaultScrollAmount: Int32 = 30  // pixels

    // MARK: - Scroll Methods

    func scrollUp(amount: Int32 = 30) {
        simulateScroll(deltaY: amount)  // Positive = scroll up
    }

    func scrollDown(amount: Int32 = 30) {
        simulateScroll(deltaY: -amount)  // Negative = scroll down
    }

    func scrollLeft(amount: Int32 = 30) {
        simulateScroll(deltaX: -amount)  // Negative = scroll left
    }

    func scrollRight(amount: Int32 = 30) {
        simulateScroll(deltaX: amount)  // Positive = scroll right
    }

    // MARK: - Core Scroll Simulation

    private func simulateScroll(deltaX: Int32 = 0, deltaY: Int32 = 0) {
        // Check if we have Accessibility permission
        guard AXIsProcessTrusted() else {
            print("⚠️ Accessibility permission required for scrolling")
            return
        }

        // Create scroll event
        guard let scrollEvent = CGEvent(
            scrollWheelEvent2Source: nil,
            units: .pixel,
            wheelCount: 2,
            wheel1: deltaY,  // Vertical scroll
            wheel2: deltaX,  // Horizontal scroll
            wheel3: 0
        ) else {
            print("❌ Failed to create scroll event")
            return
        }

        // Post the event
        scrollEvent.post(tap: .cghidEventTap)
    }

    // MARK: - Smooth Scrolling (Optional Enhancement)

    /// Simulate smooth scrolling by posting multiple smaller scroll events
    func smoothScroll(deltaX: Int32 = 0, deltaY: Int32 = 0, steps: Int = 5) {
        let stepX = deltaX / Int32(steps)
        let stepY = deltaY / Int32(steps)

        for _ in 0..<steps {
            simulateScroll(deltaX: stepX, deltaY: stepY)
            usleep(10000)  // 10ms delay between steps
        }
    }

    // MARK: - Permission Check

    func checkAccessibilityPermission() -> Bool {
        return AXIsProcessTrusted()
    }

    func requestAccessibilityPermission() {
        // Note: This will only show a prompt if the app hasn't been added yet
        // The user still needs to manually enable in System Preferences
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            print("ℹ️ Please enable Accessibility access in System Preferences")
        }
    }
}
