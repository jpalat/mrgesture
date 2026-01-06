import SwiftUI

struct PermissionsView: View {
    let cameraGranted: Bool
    let accessibilityGranted: Bool
    let onRequestCamera: () -> Void
    let onOpenAccessibility: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Camera Permission
            PermissionRow(
                icon: "video.fill",
                title: "Camera Access",
                subtitle: "Required for hand gesture detection",
                isGranted: cameraGranted,
                action: onRequestCamera,
                actionTitle: cameraGranted ? "Granted" : "Request Access"
            )

            Divider()

            // Accessibility Permission
            PermissionRow(
                icon: "hand.point.up.left.fill",
                title: "Accessibility Access",
                subtitle: "Required for scrolling and keyboard control",
                isGranted: accessibilityGranted,
                action: onOpenAccessibility,
                actionTitle: accessibilityGranted ? "Granted" : "Open System Preferences"
            )

            if !accessibilityGranted {
                Text("To enable Accessibility:\n1. Click 'Open System Preferences'\n2. Find MRGesture in the list\n3. Check the box next to it")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Permission Row

struct PermissionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isGranted: Bool
    let action: () -> Void
    let actionTitle: String

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isGranted ? .green : .orange)
                .frame(width: 40)

            // Text
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    if isGranted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    } else {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Action Button
            if !isGranted {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView(
            cameraGranted: false,
            accessibilityGranted: true,
            onRequestCamera: {},
            onOpenAccessibility: {}
        )
        .padding()
        .frame(width: 450)
    }
}
