import Foundation
import Vision
import CoreGraphics
@testable import MRGesture

/// Provides mock HandPose objects with synthetic landmark data for testing
class MockHandPoseProvider {

    // MARK: - Peace Sign Poses

    /// Creates a valid peace sign pose (index and middle extended, ring and pinky curled)
    static func createPeaceSign() -> HandPose {
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        // Thumb group with wrist
        landmarks[.thumb] = [
            .wrist: CGPoint(x: 0.5, y: 0.8),
            .thumbCMC: CGPoint(x: 0.48, y: 0.75),
            .thumbMP: CGPoint(x: 0.46, y: 0.70),
            .thumbIP: CGPoint(x: 0.44, y: 0.65),
            .thumbTip: CGPoint(x: 0.42, y: 0.60)  // Thumb slightly curled
        ]

        // Index finger - EXTENDED
        landmarks[.indexFinger] = [
            .indexMCP: CGPoint(x: 0.52, y: 0.7),
            .indexPIP: CGPoint(x: 0.52, y: 0.55),
            .indexDIP: CGPoint(x: 0.52, y: 0.40),
            .indexTip: CGPoint(x: 0.52, y: 0.25)  // Extended upward
        ]

        // Middle finger - EXTENDED
        landmarks[.middleFinger] = [
            .middleMCP: CGPoint(x: 0.55, y: 0.7),
            .middlePIP: CGPoint(x: 0.56, y: 0.55),
            .middleDIP: CGPoint(x: 0.57, y: 0.40),
            .middleTip: CGPoint(x: 0.58, y: 0.25)  // Extended upward, spread from index
        ]

        // Ring finger - CURLED
        landmarks[.ringFinger] = [
            .ringMCP: CGPoint(x: 0.58, y: 0.7),
            .ringPIP: CGPoint(x: 0.58, y: 0.72),
            .ringDIP: CGPoint(x: 0.58, y: 0.74),
            .ringTip: CGPoint(x: 0.58, y: 0.76)  // Curled down
        ]

        // Pinky finger - CURLED
        landmarks[.littleFinger] = [
            .littleMCP: CGPoint(x: 0.60, y: 0.7),
            .littlePIP: CGPoint(x: 0.60, y: 0.72),
            .littleDIP: CGPoint(x: 0.60, y: 0.74),
            .littleTip: CGPoint(x: 0.60, y: 0.76)  // Curled down
        ]

        return HandPose(
            landmarks: landmarks,
            chirality: .right,
            confidence: 0.95,
            timestamp: Date()
        )
    }

    /// Creates an invalid peace sign (all fingers extended)
    static func createInvalidPeaceSign_AllExtended() -> HandPose {
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        landmarks[.thumb] = [
            .wrist: CGPoint(x: 0.5, y: 0.8),
            .thumbTip: CGPoint(x: 0.42, y: 0.60)
        ]

        // All fingers extended
        landmarks[.indexFinger] = [
            .indexMCP: CGPoint(x: 0.52, y: 0.7),
            .indexTip: CGPoint(x: 0.52, y: 0.25)
        ]

        landmarks[.middleFinger] = [
            .middleMCP: CGPoint(x: 0.55, y: 0.7),
            .middleTip: CGPoint(x: 0.55, y: 0.25)
        ]

        landmarks[.ringFinger] = [
            .ringMCP: CGPoint(x: 0.58, y: 0.7),
            .ringTip: CGPoint(x: 0.58, y: 0.25)  // Extended, not curled
        ]

        landmarks[.littleFinger] = [
            .littleMCP: CGPoint(x: 0.60, y: 0.7),
            .littleTip: CGPoint(x: 0.60, y: 0.25)  // Extended, not curled
        ]

        return HandPose(landmarks: landmarks, chirality: .right, confidence: 0.95, timestamp: Date())
    }

    // MARK: - Thumbs Up Poses

    /// Creates a valid thumbs up pose (thumb extended, all fingers curled)
    static func createThumbsUp() -> HandPose {
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        // Thumb - EXTENDED UPWARD
        landmarks[.thumb] = [
            .wrist: CGPoint(x: 0.5, y: 0.8),
            .thumbCMC: CGPoint(x: 0.50, y: 0.75),
            .thumbMP: CGPoint(x: 0.50, y: 0.65),
            .thumbIP: CGPoint(x: 0.50, y: 0.50),
            .thumbTip: CGPoint(x: 0.50, y: 0.30)  // Extended upward
        ]

        // Index finger - CURLED
        landmarks[.indexFinger] = [
            .indexMCP: CGPoint(x: 0.52, y: 0.7),
            .indexPIP: CGPoint(x: 0.53, y: 0.72),
            .indexDIP: CGPoint(x: 0.54, y: 0.74),
            .indexTip: CGPoint(x: 0.55, y: 0.76)  // Curled into fist
        ]

        // Middle finger - CURLED
        landmarks[.middleFinger] = [
            .middleMCP: CGPoint(x: 0.55, y: 0.7),
            .middlePIP: CGPoint(x: 0.56, y: 0.72),
            .middleDIP: CGPoint(x: 0.57, y: 0.74),
            .middleTip: CGPoint(x: 0.58, y: 0.76)
        ]

        // Ring finger - CURLED
        landmarks[.ringFinger] = [
            .ringMCP: CGPoint(x: 0.58, y: 0.7),
            .ringPIP: CGPoint(x: 0.59, y: 0.72),
            .ringDIP: CGPoint(x: 0.60, y: 0.74),
            .ringTip: CGPoint(x: 0.61, y: 0.76)
        ]

        // Pinky finger - CURLED
        landmarks[.littleFinger] = [
            .littleMCP: CGPoint(x: 0.60, y: 0.7),
            .littlePIP: CGPoint(x: 0.61, y: 0.72),
            .littleDIP: CGPoint(x: 0.62, y: 0.74),
            .littleTip: CGPoint(x: 0.63, y: 0.76)
        ]

        return HandPose(
            landmarks: landmarks,
            chirality: .right,
            confidence: 0.95,
            timestamp: Date()
        )
    }

    /// Creates an invalid thumbs up (thumb not extended enough)
    static func createInvalidThumbsUp_ThumbNotExtended() -> HandPose {
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        // Thumb - NOT EXTENDED ENOUGH
        landmarks[.thumb] = [
            .wrist: CGPoint(x: 0.5, y: 0.8),
            .thumbCMC: CGPoint(x: 0.50, y: 0.75),
            .thumbMP: CGPoint(x: 0.50, y: 0.72),
            .thumbIP: CGPoint(x: 0.50, y: 0.70),
            .thumbTip: CGPoint(x: 0.50, y: 0.68)  // Not extended enough
        ]

        // All fingers curled
        landmarks[.indexFinger] = [
            .indexMCP: CGPoint(x: 0.52, y: 0.7),
            .indexTip: CGPoint(x: 0.55, y: 0.76)
        ]

        landmarks[.middleFinger] = [
            .middleMCP: CGPoint(x: 0.55, y: 0.7),
            .middleTip: CGPoint(x: 0.58, y: 0.76)
        ]

        landmarks[.ringFinger] = [
            .ringMCP: CGPoint(x: 0.58, y: 0.7),
            .ringTip: CGPoint(x: 0.61, y: 0.76)
        ]

        landmarks[.littleFinger] = [
            .littleMCP: CGPoint(x: 0.60, y: 0.7),
            .littleTip: CGPoint(x: 0.63, y: 0.76)
        ]

        return HandPose(landmarks: landmarks, chirality: .right, confidence: 0.95, timestamp: Date())
    }

    /// Creates an invalid thumbs up (fingers not curled)
    static func createInvalidThumbsUp_FingersExtended() -> HandPose {
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        // Thumb extended
        landmarks[.thumb] = [
            .wrist: CGPoint(x: 0.5, y: 0.8),
            .thumbTip: CGPoint(x: 0.50, y: 0.30)
        ]

        // Fingers EXTENDED (not curled)
        landmarks[.indexFinger] = [
            .indexMCP: CGPoint(x: 0.52, y: 0.7),
            .indexTip: CGPoint(x: 0.52, y: 0.25)  // Extended
        ]

        landmarks[.middleFinger] = [
            .middleMCP: CGPoint(x: 0.55, y: 0.7),
            .middleTip: CGPoint(x: 0.55, y: 0.25)
        ]

        landmarks[.ringFinger] = [
            .ringMCP: CGPoint(x: 0.58, y: 0.7),
            .ringTip: CGPoint(x: 0.58, y: 0.25)
        ]

        landmarks[.littleFinger] = [
            .littleMCP: CGPoint(x: 0.60, y: 0.7),
            .littleTip: CGPoint(x: 0.60, y: 0.25)
        ]

        return HandPose(landmarks: landmarks, chirality: .right, confidence: 0.95, timestamp: Date())
    }

    // MARK: - Swipe Poses

    /// Creates a sequence of hand poses showing upward movement
    static func createSwipeUpSequence(frames: Int = 12) -> [HandPose] {
        var poses: [HandPose] = []
        let startY: CGFloat = 0.8
        let endY: CGFloat = 0.5  // Movement of 0.3 (30% screen height)

        for i in 0..<frames {
            let progress = CGFloat(i) / CGFloat(frames - 1)
            let currentY = startY - (startY - endY) * progress

            var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

            // Palm center moves upward
            landmarks[.thumb] = [
                .wrist: CGPoint(x: 0.5, y: currentY)
            ]

            landmarks[.indexFinger] = [
                .indexMCP: CGPoint(x: 0.52, y: currentY - 0.05)
            ]

            landmarks[.littleFinger] = [
                .littleMCP: CGPoint(x: 0.60, y: currentY - 0.05)
            ]

            poses.append(HandPose(
                landmarks: landmarks,
                chirality: .right,
                confidence: 0.95,
                timestamp: Date().addingTimeInterval(Double(i) * 0.033)  // 30 FPS
            ))
        }

        return poses
    }

    /// Creates a sequence of hand poses showing downward movement
    static func createSwipeDownSequence(frames: Int = 12) -> [HandPose] {
        var poses: [HandPose] = []
        let startY: CGFloat = 0.4
        let endY: CGFloat = 0.7  // Movement of 0.3 downward

        for i in 0..<frames {
            let progress = CGFloat(i) / CGFloat(frames - 1)
            let currentY = startY + (endY - startY) * progress

            var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

            landmarks[.thumb] = [
                .wrist: CGPoint(x: 0.5, y: currentY)
            ]

            landmarks[.indexFinger] = [
                .indexMCP: CGPoint(x: 0.52, y: currentY - 0.05)
            ]

            landmarks[.littleFinger] = [
                .littleMCP: CGPoint(x: 0.60, y: currentY - 0.05)
            ]

            poses.append(HandPose(
                landmarks: landmarks,
                chirality: .right,
                confidence: 0.95,
                timestamp: Date().addingTimeInterval(Double(i) * 0.033)
            ))
        }

        return poses
    }

    /// Creates a sequence with insufficient movement (should not trigger swipe)
    static func createInsufficientMovementSequence(frames: Int = 12) -> [HandPose] {
        var poses: [HandPose] = []
        let startY: CGFloat = 0.6
        let endY: CGFloat = 0.65  // Only 5% movement (below threshold)

        for i in 0..<frames {
            let progress = CGFloat(i) / CGFloat(frames - 1)
            let currentY = startY + (endY - startY) * progress

            var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

            landmarks[.thumb] = [
                .wrist: CGPoint(x: 0.5, y: currentY)
            ]

            landmarks[.indexFinger] = [
                .indexMCP: CGPoint(x: 0.52, y: currentY - 0.05)
            ]

            landmarks[.littleFinger] = [
                .littleMCP: CGPoint(x: 0.60, y: currentY - 0.05)
            ]

            poses.append(HandPose(
                landmarks: landmarks,
                chirality: .right,
                confidence: 0.95,
                timestamp: Date().addingTimeInterval(Double(i) * 0.033)
            ))
        }

        return poses
    }

    /// Creates a static hand pose (no movement)
    static func createStaticPose() -> HandPose {
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        landmarks[.thumb] = [
            .wrist: CGPoint(x: 0.5, y: 0.6)
        ]

        landmarks[.indexFinger] = [
            .indexMCP: CGPoint(x: 0.52, y: 0.55)
        ]

        landmarks[.littleFinger] = [
            .littleMCP: CGPoint(x: 0.60, y: 0.55)
        ]

        return HandPose(
            landmarks: landmarks,
            chirality: .right,
            confidence: 0.95,
            timestamp: Date()
        )
    }
}
