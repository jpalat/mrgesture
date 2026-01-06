import Foundation
import Vision
import CoreGraphics

// MARK: - Hand Pose Data Model

struct HandPose {
    let landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]]
    let chirality: VNChirality
    let confidence: Float
    let timestamp: Date

    /// Get a specific landmark point
    func landmark(_ joint: VNHumanHandPoseObservation.JointName) -> CGPoint? {
        for (_, joints) in landmarks {
            if let point = joints[joint] {
                return point
            }
        }
        return nil
    }

    /// Get all landmarks as a flat dictionary
    func allLandmarks() -> [VNHumanHandPoseObservation.JointName: CGPoint] {
        var all: [VNHumanHandPoseObservation.JointName: CGPoint] = [:]
        for (_, joints) in landmarks {
            for (joint, point) in joints {
                all[joint] = point
            }
        }
        return all
    }

    /// Calculate distance between two landmarks
    func distance(from: VNHumanHandPoseObservation.JointName, to: VNHumanHandPoseObservation.JointName) -> CGFloat? {
        guard let p1 = landmark(from), let p2 = landmark(to) else {
            return nil
        }
        return hypot(p2.x - p1.x, p2.y - p1.y)
    }

    /// Calculate hand size (wrist to middle finger tip distance)
    /// Used for normalizing distances
    func handSize() -> CGFloat? {
        return distance(from: .wrist, to: .middleTip)
    }

    /// Check if a finger is extended (tip above MCP joint)
    func isFingerExtended(_ finger: Finger, threshold: CGFloat = 0.15) -> Bool {
        guard let tipY = landmark(finger.tip)?.y,
              let mcpY = landmark(finger.mcp)?.y else {
            return false
        }

        // In Vision framework, Y increases downward, so tip should be BELOW (smaller Y) than MCP when extended
        let extension = mcpY - tipY

        // Normalize by hand size
        if let size = handSize() {
            return (extension / size) > threshold
        }

        return extension > threshold
    }

    /// Check if a finger is curled (tip below MCP joint)
    func isFingerCurled(_ finger: Finger, threshold: CGFloat = 0.1) -> Bool {
        guard let tipY = landmark(finger.tip)?.y,
              let mcpY = landmark(finger.mcp)?.y else {
            return false
        }

        // Tip should be ABOVE (larger Y) than MCP when curled
        let curl = tipY - mcpY

        // Normalize by hand size
        if let size = handSize() {
            return (curl / size) > threshold
        }

        return curl > threshold
    }

    /// Calculate angle between three points in degrees
    func angle(from p1Joint: VNHumanHandPoseObservation.JointName,
               vertex p2Joint: VNHumanHandPoseObservation.JointName,
               to p3Joint: VNHumanHandPoseObservation.JointName) -> CGFloat? {
        guard let p1 = landmark(p1Joint),
              let p2 = landmark(p2Joint),
              let p3 = landmark(p3Joint) else {
            return nil
        }

        let v1 = CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
        let v2 = CGPoint(x: p3.x - p2.x, y: p3.y - p2.y)

        let dot = v1.x * v2.x + v1.y * v2.y
        let mag1 = sqrt(v1.x * v1.x + v1.y * v1.y)
        let mag2 = sqrt(v2.x * v2.x + v2.y * v2.y)

        guard mag1 > 0, mag2 > 0 else { return nil }

        let cosAngle = dot / (mag1 * mag2)
        let angleRad = acos(max(-1, min(1, cosAngle)))

        return angleRad * 180.0 / .pi
    }

    /// Get palm center (average of wrist, index MCP, and pinky MCP)
    func palmCenter() -> CGPoint? {
        guard let wrist = landmark(.wrist),
              let indexMCP = landmark(.indexMCP),
              let pinkyMCP = landmark(.littleMCP) else {
            return nil
        }

        return CGPoint(
            x: (wrist.x + indexMCP.x + pinkyMCP.x) / 3.0,
            y: (wrist.y + indexMCP.y + pinkyMCP.y) / 3.0
        )
    }
}

// MARK: - Finger Helper Enum

enum Finger {
    case thumb
    case index
    case middle
    case ring
    case pinky

    var tip: VNHumanHandPoseObservation.JointName {
        switch self {
        case .thumb: return .thumbTip
        case .index: return .indexTip
        case .middle: return .middleTip
        case .ring: return .ringTip
        case .pinky: return .littleTip
        }
    }

    var mcp: VNHumanHandPoseObservation.JointName {
        switch self {
        case .thumb: return .thumbCMC  // Thumb uses CMC instead of MCP
        case .index: return .indexMCP
        case .middle: return .middleMCP
        case .ring: return .ringMCP
        case .pinky: return .littleMCP
        }
    }

    var dip: VNHumanHandPoseObservation.JointName {
        switch self {
        case .thumb: return .thumbIP
        case .index: return .indexDIP
        case .middle: return .middleDIP
        case .ring: return .ringDIP
        case .pinky: return .littleDIP
        }
    }

    var pip: VNHumanHandPoseObservation.JointName {
        switch self {
        case .thumb: return .thumbMP
        case .index: return .indexPIP
        case .middle: return .middlePIP
        case .ring: return .ringPIP
        case .pinky: return .littlePIP
        }
    }
}
