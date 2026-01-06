import Foundation
import Vision
import CoreVideo
import CoreGraphics

class HandPoseDetector {
    private let visionQueue = DispatchQueue(label: "com.mrgesture.vision")
    private var handPoseRequest: VNDetectHumanHandPoseRequest?

    // Callback for detected hand poses
    var onHandPoseDetected: ((HandPose) -> Void)?

    // Performance tracking
    private var lastProcessTime: Date?

    init() {
        setupVisionRequest()
    }

    // MARK: - Setup

    private func setupVisionRequest() {
        handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest?.maximumHandCount = 1  // Only detect one hand for performance
    }

    // MARK: - Frame Processing

    func processFrame(_ pixelBuffer: CVPixelBuffer, completion: ((HandPose?) -> Void)? = nil) {
        guard let request = handPoseRequest else {
            completion?(nil)
            return
        }

        visionQueue.async { [weak self] in
            guard let self = self else {
                completion?(nil)
                return
            }

            let handler = VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: .up,
                options: [:]
            )

            do {
                // Perform hand pose detection
                try handler.perform([request])

                // Extract results
                if let observations = request.results as? [VNHumanHandPoseObservation],
                   let observation = observations.first {

                    // Only process if confidence is high enough
                    if observation.confidence > 0.7 {
                        let handPose = self.extractHandPose(from: observation)

                        // Callback on main queue
                        DispatchQueue.main.async {
                            self.onHandPoseDetected?(handPose)
                            completion?(handPose)
                        }

                        return
                    }
                }

                // No hand detected or low confidence
                DispatchQueue.main.async {
                    completion?(nil)
                }

            } catch {
                print("⚠️ Hand pose detection error: \(error)")
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
    }

    // MARK: - Hand Pose Extraction

    private func extractHandPose(from observation: VNHumanHandPoseObservation) -> HandPose {
        var landmarksDict: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]

        // Extract all joint groups
        let jointGroups: [VNHumanHandPoseObservation.JointsGroupName] = [
            .thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger
        ]

        for group in jointGroups {
            do {
                let groupPoints = try observation.recognizedPoints(group)
                var joints: [VNHumanHandPoseObservation.JointName: CGPoint] = [:]

                for (jointName, point) in groupPoints {
                    // Only include points with sufficient confidence
                    if point.confidence > 0.5 {
                        joints[jointName] = CGPoint(x: point.location.x, y: point.location.y)
                    }
                }

                if !joints.isEmpty {
                    landmarksDict[group] = joints
                }
            } catch {
                // Skip this group if recognition fails
                continue
            }
        }

        // Also get wrist point separately
        do {
            if let wristPoint = try observation.recognizedPoint(.wrist), wristPoint.confidence > 0.5 {
                // Add wrist to thumb group for convenience
                if landmarksDict[.thumb] != nil {
                    landmarksDict[.thumb]?[.wrist] = CGPoint(x: wristPoint.location.x, y: wristPoint.location.y)
                } else {
                    landmarksDict[.thumb] = [.wrist: CGPoint(x: wristPoint.location.x, y: wristPoint.location.y)]
                }
            }
        } catch {
            // Wrist not detected
        }

        return HandPose(
            landmarks: landmarksDict,
            chirality: observation.chirality,
            confidence: observation.confidence,
            timestamp: Date()
        )
    }

    // MARK: - Performance

    func getProcessingTimeMs() -> Double? {
        guard let lastTime = lastProcessTime else { return nil }
        return -lastTime.timeIntervalSinceNow * 1000.0
    }
}

// MARK: - CameraManager Integration

extension CameraManager {
    /// Updated processFrame to integrate with HandPoseDetector
    func integrateHandPoseDetector(_ detector: HandPoseDetector) {
        // This method shows how to wire up CameraManager with HandPoseDetector
        // In practice, we'll do this in AppDelegate

        detector.onHandPoseDetected = { [weak self] handPose in
            self?.onFrameProcessed?(handPose)
        }
    }
}
