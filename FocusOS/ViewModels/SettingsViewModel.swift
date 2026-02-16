import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var focusModeEnabled = true
    @Published var parentModeEnabled = false
}
