import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("aiServiceMode") private var aiServiceModeRaw = AIServiceMode.mock.rawValue
    @AppStorage("openaiModel") private var openaiModelRaw = OpenAIModel.gpt5Mini.rawValue

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                PremiumCard {
                    Toggle("Focus Mode", isOn: $viewModel.focusModeEnabled)
                        .tint(AppColors.gold)
                    Divider().overlay(AppColors.strokeDefault)
                    Toggle("Parent Mode", isOn: $viewModel.parentModeEnabled)
                        .tint(AppColors.gold)
                }
                
                PremiumCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("AI Service")
                            .font(AppFont.caption())
                            .foregroundStyle(AppColors.textSecondary)
                        Picker("AI Service", selection: aiServiceModeBinding) {
                            ForEach(AIServiceMode.allCases) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Divider().overlay(AppColors.strokeDefault)
                        
                        Text("Model")
                            .font(AppFont.caption())
                            .foregroundStyle(AppColors.textSecondary)
                        Picker("Model", selection: openaiModelBinding) {
                            ForEach(OpenAIModel.allCases) { model in
                                Text(model.displayName).tag(model)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }

                PremiumCard(isInteractive: true) {
                    SettingsRow(title: "Notifications", icon: "bell.badge")
                }

                PremiumCard(isInteractive: true) {
                    SettingsRow(title: "About", icon: "info.circle")
                    Divider().overlay(AppColors.strokeDefault)
                    SettingsRow(title: "Feedback", icon: "envelope")
                }
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.backgroundPrimary)
        .navigationTitle("Settings")
    }
    
    private var aiServiceModeBinding: Binding<AIServiceMode> {
        Binding(
            get: { AIServiceMode(rawValue: aiServiceModeRaw) ?? .mock },
            set: { aiServiceModeRaw = $0.rawValue }
        )
    }
    
    private var openaiModelBinding: Binding<OpenAIModel> {
        Binding(
            get: { OpenAIModel(rawValue: openaiModelRaw) ?? .gpt5Mini },
            set: { openaiModelRaw = $0.rawValue }
        )
    }
}

private struct SettingsRow: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(AppColors.textGold)
            Text(title)
                .font(AppFont.body())
                .foregroundStyle(AppColors.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(.vertical, AppSpacing.sm)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .preferredColorScheme(.dark)
}
