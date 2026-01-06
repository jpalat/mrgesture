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
                    gesture: "👆 Swipe Up/Down",
                    action: "Scrolls page"
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
        .frame(width: 500, height: 450)
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

    private let permissionManager: PermissionManager

    init(permissionManager: PermissionManager) {
        self.permissionManager = permissionManager
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
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(permissionManager: PermissionManager())
    }
}
