import Foundation
import AVFoundation
import CoreVideo

class CameraManager: NSObject {
    private var captureSession: AVCaptureSession?
    private let sessionQueue = DispatchQueue(label: "com.mrgesture.camera")
    private var isSessionRunning = false

    // Callback for processed frames
    var onFrameProcessed: ((HandPose) -> Void)?

    // Performance settings
    private var targetFrameRate: Int = 30
    private var isProcessing = false

    // MARK: - Session Lifecycle

    func startSession() {
        sessionQueue.async { [weak self] in
            self?.setupCaptureSession()
            self?.captureSession?.startRunning()
            self?.isSessionRunning = true
            print("✓ Camera session started")
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
            self?.isSessionRunning = false
            print("✓ Camera session stopped")
        }
    }

    // MARK: - Setup

    private func setupCaptureSession() {
        guard captureSession == nil else { return }

        let session = AVCaptureSession()

        // Use medium preset for balance of quality and performance (640x480)
        session.sessionPreset = .medium

        // Get default camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ Failed to access camera")
            return
        }

        // Configure camera for target frame rate
        do {
            try camera.lockForConfiguration()

            // Set frame rate to 30 FPS max
            camera.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(targetFrameRate))
            camera.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(targetFrameRate))

            camera.unlockForConfiguration()
        } catch {
            print("⚠️ Could not configure camera frame rate: \(error)")
        }

        // Add camera input
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("❌ Cannot add camera input")
                return
            }
        } catch {
            print("❌ Error creating camera input: \(error)")
            return
        }

        // Add video output
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sessionQueue)

        // Use 32BGRA format for compatibility with Vision framework
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]

        // Drop frames if processing takes too long
        output.alwaysDiscardsLateVideoFrames = true

        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            print("❌ Cannot add video output")
            return
        }

        captureSession = session
    }

    // MARK: - Configuration

    func setFrameRate(_ fps: Int) {
        targetFrameRate = min(max(fps, 15), 30) // Clamp between 15-30 FPS
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        // Drop frame if still processing previous frame
        guard !isProcessing else { return }
        isProcessing = true

        // Get pixel buffer from sample buffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            isProcessing = false
            return
        }

        // Process frame with hand pose detector
        processFrame(pixelBuffer)

        isProcessing = false
    }

    private func processFrame(_ pixelBuffer: CVPixelBuffer) {
        // This will be called by HandPoseDetector
        // For now, create a placeholder that will be replaced when we integrate HandPoseDetector

        // The actual processing will be:
        // HandPoseDetector.shared.processFrame(pixelBuffer) { [weak self] handPose in
        //     self?.onFrameProcessed?(handPose)
        // }
    }
}
