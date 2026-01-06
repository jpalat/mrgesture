import XCTest
@testable import MRGesture

/// Unit tests for gesture detection logic
class GestureDetectionTests: XCTestCase {

    // MARK: - PeaceSignDetector Tests

    func testPeaceSignDetector_ValidPeaceSign_ReturnsTrue() {
        // Arrange
        let detector = PeaceSignDetector()
        let handPose = MockHandPoseProvider.createPeaceSign()

        // Act
        let result = detector.detect(handPose: handPose)

        // Assert
        XCTAssertTrue(result, "Valid peace sign should be detected")
        XCTAssertEqual(detector.gestureType, .peaceSign, "Gesture type should be peaceSign")
    }

    func testPeaceSignDetector_AllFingersExtended_ReturnsFalse() {
        // Arrange
        let detector = PeaceSignDetector()
        let handPose = MockHandPoseProvider.createInvalidPeaceSign_AllExtended()

        // Act
        let result = detector.detect(handPose: handPose)

        // Assert
        XCTAssertFalse(result, "Peace sign with all fingers extended should not be detected")
    }

    func testPeaceSignDetector_Priority_IsHigh() {
        // Arrange
        let detector = PeaceSignDetector()

        // Assert
        XCTAssertEqual(detector.priority, 10, "PeaceSignDetector should have high priority (10)")
    }

    // MARK: - ThumbsUpDetector Tests

    func testThumbsUpDetector_ValidThumbsUp_ReturnsTrue() {
        // Arrange
        let detector = ThumbsUpDetector()
        let handPose = MockHandPoseProvider.createThumbsUp()

        // Act
        let result = detector.detect(handPose: handPose)

        // Assert
        XCTAssertTrue(result, "Valid thumbs up should be detected")
        XCTAssertEqual(detector.gestureType, .thumbsUp, "Gesture type should be thumbsUp")
    }

    func testThumbsUpDetector_ThumbNotExtended_ReturnsFalse() {
        // Arrange
        let detector = ThumbsUpDetector()
        let handPose = MockHandPoseProvider.createInvalidThumbsUp_ThumbNotExtended()

        // Act
        let result = detector.detect(handPose: handPose)

        // Assert
        XCTAssertFalse(result, "Thumbs up with thumb not extended should not be detected")
    }

    func testThumbsUpDetector_FingersNotCurled_ReturnsFalse() {
        // Arrange
        let detector = ThumbsUpDetector()
        let handPose = MockHandPoseProvider.createInvalidThumbsUp_FingersExtended()

        // Act
        let result = detector.detect(handPose: handPose)

        // Assert
        XCTAssertFalse(result, "Thumbs up with fingers extended should not be detected")
    }

    func testThumbsUpDetector_Priority_IsHigh() {
        // Arrange
        let detector = ThumbsUpDetector()

        // Assert
        XCTAssertEqual(detector.priority, 10, "ThumbsUpDetector should have high priority (10)")
    }

    // MARK: - SwipeDetector Tests

    func testSwipeDetector_UpwardMovement_ReturnsTrue() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeUpSequence(frames: 12)

        // Act
        var detected = false
        for pose in poses {
            if detector.detect(handPose: pose) {
                detected = true
                break
            }
        }

        // Assert
        XCTAssertTrue(detected, "Upward swipe should be detected")
        if case .swipe(let direction) = detector.gestureType {
            XCTAssertEqual(direction, .up, "Swipe direction should be up")
        } else {
            XCTFail("Gesture type should be swipe")
        }
    }

    func testSwipeDetector_DownwardMovement_ReturnsTrue() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeDownSequence(frames: 12)

        // Act
        var detected = false
        for pose in poses {
            if detector.detect(handPose: pose) {
                detected = true
                break
            }
        }

        // Assert
        XCTAssertTrue(detected, "Downward swipe should be detected")
        if case .swipe(let direction) = detector.gestureType {
            XCTAssertEqual(direction, .down, "Swipe direction should be down")
        } else {
            XCTFail("Gesture type should be swipe")
        }
    }

    func testSwipeDetector_LeftwardMovement_ReturnsTrue() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeLeftSequence(frames: 12)

        // Act
        var detected = false
        for pose in poses {
            if detector.detect(handPose: pose) {
                detected = true
                break
            }
        }

        // Assert
        XCTAssertTrue(detected, "Leftward swipe should be detected")
        if case .swipe(let direction) = detector.gestureType {
            XCTAssertEqual(direction, .left, "Swipe direction should be left")
        } else {
            XCTFail("Gesture type should be swipe")
        }
    }

    func testSwipeDetector_RightwardMovement_ReturnsTrue() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeRightSequence(frames: 12)

        // Act
        var detected = false
        for pose in poses {
            if detector.detect(handPose: pose) {
                detected = true
                break
            }
        }

        // Assert
        XCTAssertTrue(detected, "Rightward swipe should be detected")
        if case .swipe(let direction) = detector.gestureType {
            XCTAssertEqual(direction, .right, "Swipe direction should be right")
        } else {
            XCTFail("Gesture type should be swipe")
        }
    }

    func testSwipeDetector_InsufficientMovement_ReturnsFalse() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createInsufficientMovementSequence(frames: 12)

        // Act
        var detected = false
        for pose in poses {
            if detector.detect(handPose: pose) {
                detected = true
                break
            }
        }

        // Assert
        XCTAssertFalse(detected, "Insufficient movement should not trigger swipe detection")
    }

    func testSwipeDetector_InsufficientHistory_ReturnsFalse() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeUpSequence(frames: 5)  // Only 5 frames

        // Act
        var detected = false
        for pose in poses {
            if detector.detect(handPose: pose) {
                detected = true
                break
            }
        }

        // Assert
        XCTAssertFalse(detected, "Swipe with insufficient history should not be detected")
    }

    func testSwipeDetector_Cooldown_PreventsDuplicateDetection() {
        // Arrange
        let detector = SwipeDetector()
        let firstSwipe = MockHandPoseProvider.createSwipeUpSequence(frames: 12)
        let secondSwipe = MockHandPoseProvider.createSwipeUpSequence(frames: 12)

        // Act - First swipe
        var firstDetected = false
        for pose in firstSwipe {
            if detector.detect(handPose: pose) {
                firstDetected = true
                break
            }
        }

        // Act - Second swipe immediately after (should be blocked by cooldown)
        var secondDetected = false
        for pose in secondSwipe {
            if detector.detect(handPose: pose) {
                secondDetected = true
                break
            }
        }

        // Assert
        XCTAssertTrue(firstDetected, "First swipe should be detected")
        XCTAssertFalse(secondDetected, "Second swipe should be blocked by cooldown")
    }

    func testSwipeDetector_TemporalSmoothing_SustainsDetection() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeUpSequence(frames: 12)

        // Act - Process all frames
        var detectionCount = 0
        for pose in poses {
            if detector.detect(handPose: pose) {
                detectionCount += 1
            }
        }

        // Assert - Should return true for 3 consecutive frames (temporal smoothing)
        XCTAssertEqual(detectionCount, 3, "SwipeDetector should sustain detection for 3 frames")
    }

    func testSwipeDetector_Reset_ClearsState() {
        // Arrange
        let detector = SwipeDetector()
        let poses = MockHandPoseProvider.createSwipeUpSequence(frames: 6)

        // Act - Partially process, then reset
        for pose in poses.prefix(5) {
            _ = detector.detect(handPose: pose)
        }
        detector.reset()

        // Process one more frame after reset
        let result = detector.detect(handPose: poses.last!)

        // Assert
        XCTAssertFalse(result, "Detection should return false after reset (insufficient history)")
    }

    func testSwipeDetector_Priority_IsLower() {
        // Arrange
        let detector = SwipeDetector()

        // Assert
        XCTAssertEqual(detector.priority, 5, "SwipeDetector should have lower priority (5) than static gestures")
    }

    // MARK: - GestureRecognizer Tests

    func testGestureRecognizer_RegistersAllDetectors() {
        // Arrange & Act
        let recognizer = GestureRecognizer()

        // Assert
        // We can't directly access detectors (private), but we can test behavior
        // If all detectors are registered, recognition should work
        let peacePose = MockHandPoseProvider.createPeaceSign()
        let result = recognizer.recognize(handPose: peacePose)

        // After 3 consecutive detections, it should trigger (temporal smoothing)
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: peacePose)
        let finalResult = recognizer.recognize(handPose: peacePose)

        XCTAssertNotNil(finalResult, "GestureRecognizer should detect gestures after temporal smoothing")
    }

    func testGestureRecognizer_TemporalSmoothing_RequiresConsecutiveFrames() {
        // Arrange
        let recognizer = GestureRecognizer()
        let peacePose = MockHandPoseProvider.createPeaceSign()
        let staticPose = MockHandPoseProvider.createStaticPose()

        // Act - Alternate between peace sign and static pose
        let result1 = recognizer.recognize(handPose: peacePose)
        let result2 = recognizer.recognize(handPose: staticPose)  // Breaks consecutive chain
        let result3 = recognizer.recognize(handPose: peacePose)

        // Assert
        XCTAssertNil(result1, "First detection should not trigger (needs 3 consecutive)")
        XCTAssertNil(result2, "Static pose should not trigger")
        XCTAssertNil(result3, "Peace sign should not trigger (consecutive chain broken)")
    }

    func testGestureRecognizer_TemporalSmoothing_Triggers() {
        // Arrange
        let recognizer = GestureRecognizer()
        let peacePose = MockHandPoseProvider.createPeaceSign()

        // Act - 3 consecutive detections
        let result1 = recognizer.recognize(handPose: peacePose)
        let result2 = recognizer.recognize(handPose: peacePose)
        let result3 = recognizer.recognize(handPose: peacePose)

        // Assert
        XCTAssertNil(result1, "First detection should not trigger")
        XCTAssertNil(result2, "Second detection should not trigger")
        XCTAssertEqual(result3, .peaceSign, "Third consecutive detection should trigger peace sign")
    }

    func testGestureRecognizer_Cooldown_PreventsRapidRetrigger() {
        // Arrange
        let recognizer = GestureRecognizer()
        let peacePose = MockHandPoseProvider.createPeaceSign()

        // Act - Trigger gesture once
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: peacePose)
        let firstTrigger = recognizer.recognize(handPose: peacePose)

        // Try to trigger again immediately
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: peacePose)
        let secondTrigger = recognizer.recognize(handPose: peacePose)

        // Assert
        XCTAssertEqual(firstTrigger, .peaceSign, "First trigger should succeed")
        XCTAssertNil(secondTrigger, "Second trigger should be blocked by cooldown")
    }

    func testGestureRecognizer_PriorityOrder_StaticBeforeSwipe() {
        // Arrange
        let recognizer = GestureRecognizer()

        // Create a pose that could match multiple gestures
        // In practice, peace sign has higher priority than swipes
        let peacePose = MockHandPoseProvider.createPeaceSign()

        // Act - Detect 3 times for temporal smoothing
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: peacePose)
        let result = recognizer.recognize(handPose: peacePose)

        // Assert
        XCTAssertEqual(result, .peaceSign, "Static gesture should be detected with higher priority")
    }

    func testGestureRecognizer_Reset_ClearsHistory() {
        // Arrange
        let recognizer = GestureRecognizer()
        let peacePose = MockHandPoseProvider.createPeaceSign()

        // Act - Partially build up history, then reset
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: peacePose)
        recognizer.reset()

        // Try to trigger after reset (should need 3 more frames)
        let result = recognizer.recognize(handPose: peacePose)

        // Assert
        XCTAssertNil(result, "Recognition should not trigger after reset (history cleared)")
    }

    func testGestureRecognizer_SwipeCooldownHandledByDetector() {
        // Arrange
        let recognizer = GestureRecognizer()
        let swipePoses = MockHandPoseProvider.createSwipeUpSequence(frames: 12)

        // Act - Process swipe sequence
        var detectedGesture: GestureType?
        for pose in swipePoses {
            if let gesture = recognizer.recognize(handPose: pose) {
                detectedGesture = gesture
                break
            }
        }

        // Assert
        XCTAssertNotNil(detectedGesture, "Swipe should be detected")
        if case .swipe(let direction) = detectedGesture {
            XCTAssertEqual(direction, .up, "Swipe direction should be up")
        } else {
            XCTFail("Detected gesture should be a swipe")
        }
    }

    // MARK: - Integration Tests

    func testIntegration_PeaceSignThenThumbsUp() {
        // Arrange
        let recognizer = GestureRecognizer()
        let peacePose = MockHandPoseProvider.createPeaceSign()
        let thumbsPose = MockHandPoseProvider.createThumbsUp()

        // Act - Detect peace sign
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: peacePose)
        let peaceResult = recognizer.recognize(handPose: peacePose)

        // Wait for cooldown, then detect thumbs up
        recognizer.reset()  // Simulate waiting for cooldown
        _ = recognizer.recognize(handPose: thumbsPose)
        _ = recognizer.recognize(handPose: thumbsPose)
        let thumbsResult = recognizer.recognize(handPose: thumbsPose)

        // Assert
        XCTAssertEqual(peaceResult, .peaceSign, "Peace sign should be detected first")
        XCTAssertEqual(thumbsResult, .thumbsUp, "Thumbs up should be detected after reset")
    }

    func testIntegration_SwipeSequenceWithTemporalSmoothing() {
        // Arrange
        let recognizer = GestureRecognizer()
        let swipePoses = MockHandPoseProvider.createSwipeUpSequence(frames: 15)

        // Act - Process entire swipe sequence
        var results: [GestureType?] = []
        for pose in swipePoses {
            results.append(recognizer.recognize(handPose: pose))
        }

        // Assert - Should detect swipe after enough frames
        let detectedGestures = results.compactMap { $0 }
        XCTAssertFalse(detectedGestures.isEmpty, "Swipe should be detected in the sequence")

        // Check that detected gesture is a swipe up
        if let firstDetection = detectedGestures.first,
           case .swipe(let direction) = firstDetection {
            XCTAssertEqual(direction, .up, "Detected swipe should be upward")
        } else {
            XCTFail("Should detect an upward swipe")
        }
    }

    func testIntegration_HorizontalSwipeSequence() {
        // Arrange
        let recognizer = GestureRecognizer()
        let leftSwipePoses = MockHandPoseProvider.createSwipeLeftSequence(frames: 15)
        let rightSwipePoses = MockHandPoseProvider.createSwipeRightSequence(frames: 15)

        // Act - Process left swipe sequence
        var leftResults: [GestureType?] = []
        for pose in leftSwipePoses {
            leftResults.append(recognizer.recognize(handPose: pose))
        }

        // Reset and process right swipe
        recognizer.reset()
        var rightResults: [GestureType?] = []
        for pose in rightSwipePoses {
            rightResults.append(recognizer.recognize(handPose: pose))
        }

        // Assert - Left swipe
        let leftDetected = leftResults.compactMap { $0 }
        XCTAssertFalse(leftDetected.isEmpty, "Left swipe should be detected")
        if let firstLeft = leftDetected.first,
           case .swipe(let direction) = firstLeft {
            XCTAssertEqual(direction, .left, "Detected swipe should be leftward")
        } else {
            XCTFail("Should detect a leftward swipe")
        }

        // Assert - Right swipe
        let rightDetected = rightResults.compactMap { $0 }
        XCTAssertFalse(rightDetected.isEmpty, "Right swipe should be detected")
        if let firstRight = rightDetected.first,
           case .swipe(let direction) = firstRight {
            XCTAssertEqual(direction, .right, "Detected swipe should be rightward")
        } else {
            XCTFail("Should detect a rightward swipe")
        }
    }

    // MARK: - Edge Cases

    func testEdgeCase_NoHandDetected_ReturnsNil() {
        // Arrange
        let recognizer = GestureRecognizer()
        // Create empty pose with minimal landmarks
        var landmarks: [VNHumanHandPoseObservation.JointsGroupName: [VNHumanHandPoseObservation.JointName: CGPoint]] = [:]
        landmarks[.thumb] = [:] // Empty landmarks

        let emptyPose = HandPose(
            landmarks: landmarks,
            chirality: .right,
            confidence: 0.3,  // Low confidence
            timestamp: Date()
        )

        // Act
        let result = recognizer.recognize(handPose: emptyPose)

        // Assert
        XCTAssertNil(result, "Empty pose should not trigger any gesture")
    }

    func testEdgeCase_MultipleGestureTransition() {
        // Arrange
        let recognizer = GestureRecognizer()
        let peacePose = MockHandPoseProvider.createPeaceSign()
        let thumbsPose = MockHandPoseProvider.createThumbsUp()

        // Act - Switch between gestures rapidly
        _ = recognizer.recognize(handPose: peacePose)
        _ = recognizer.recognize(handPose: thumbsPose)  // Switch
        _ = recognizer.recognize(handPose: peacePose)  // Switch back

        // Assert - Should not trigger (no 3 consecutive same gestures)
        let result = recognizer.recognize(handPose: peacePose)
        XCTAssertNil(result, "Rapid gesture switching should not trigger detection")
    }
}
