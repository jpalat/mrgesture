import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel: SettingsViewModel

    init(permissionManager: PermissionManager) {
        self.viewModel = SettingsViewModel(permissionManager: permissionManager)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)

                Text("MRGesture Settings")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Hands-free control for your Mac")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            Divider()

            // Permissions Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Permissions")
                    .font(.headline)

                PermissionsView(
                    cameraGranted: viewModel.cameraPermissionGranted,
                    accessibilityGranted: viewModel.accessibilityPermissionGranted,
                    onRequestCamera: viewModel.requestCameraPermission,
                    onOpenAccessibility: viewModel.openAccessibilityPreferences
                )
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)

            // Gesture Settings Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Gesture Settings")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Sensitivity")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.1fx", viewModel.gestureSensitivity))
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }

                    Slider(value: Binding(
                        get: { viewModel.gestureSensitivity },
                        set: { viewModel.updateGestureSensitivity($0) }
                    ), in: 0.5...2.0, step: 0.1)

                    HStack {
                        Text("More Strict")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("More Lenient")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)

            // Gesture Mappings Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Gesture Mappings")
                    .font(.headline)

                GestureMappingRow(
                    gesture: "✌️ Peace Sign",
                    action: "Opens Alfred"
                )

                GestureMappingRow(
                    gesture: "👍 Thumbs Up",
                    action: "Switches to Ghostty"
                )

                GestureMappingRow(
                    gesture: "👆👇 Swipe Vertical",
                    action: "Scrolls up/down"
                )

                GestureMappingRow(
                    gesture: "👈👉 Swipe Horizontal",
                    action: "Scrolls left/right"
                )
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)

            Spacer()

            // Footer
            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .padding()
        .frame(width: 500, height: 550)
        .onAppear {
            viewModel.refreshPermissions()
        }
    }
}

// MARK: - Gesture Mapping Row

struct GestureMappingRow: View {
    let gesture: String
    let action: String

    var body: some View {
        HStack {
            Text(gesture)
                .font(.system(size: 24))

            Text(action)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Settings View Model

class SettingsViewModel: ObservableObject {
    @Published var cameraPermissionGranted: Bool = false
    @Published var accessibilityPermissionGranted: Bool = false
    @Published var gestureSensitivity: Double = 1.0

    private let permissionManager: PermissionManager
    private let configurationManager: ConfigurationManager

    init(permissionManager: PermissionManager, configurationManager: ConfigurationManager = ConfigurationManager()) {
        self.permissionManager = permissionManager
        self.configurationManager = configurationManager
        self.gestureSensitivity = configurationManager.gestureSensitivity
        refreshPermissions()
    }

    func refreshPermissions() {
        let status = permissionManager.checkPermissions()
        cameraPermissionGranted = status.cameraGranted
        accessibilityPermissionGranted = status.accessibilityGranted
    }

    func requestCameraPermission() {
        permissionManager.requestCameraAccess { [weak self] granted in
            self?.refreshPermissions()
        }
    }

    func openAccessibilityPreferences() {
        permissionManager.openSystemPreferences()
    }

    func updateGestureSensitivity(_ value: Double) {
        configurationManager.gestureSensitivity = value
        gestureSensitivity = value
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(permissionManager: PermissionManager())
    }
}
