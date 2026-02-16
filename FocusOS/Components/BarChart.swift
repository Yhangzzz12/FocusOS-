import SwiftUI

struct BarChart: View {
    let values: [Double]
    let labels: [String]
    @State private var animate = false

    init(values: [Double], labels: [String]) {
        self.values = values
        self.labels = labels
    }

    var body: some View {
        GeometryReader { geo in
            let maxValue = max(values.max() ?? 1, 1)
            let barWidth = (geo.size.width / CGFloat(values.count)) * 0.5

            HStack(alignment: .bottom, spacing: (geo.size.width / CGFloat(values.count)) * 0.5) {
                ForEach(values.indices, id: \.self) { index in
                    VStack(spacing: AppSpacing.xs) {
                        Capsule()
                            .fill(AppColors.gold)
                            .frame(width: barWidth, height: animate ? barHeight(value: values[index], maxValue: maxValue, height: geo.size.height) : 0)
                            .animation(.easeInOut(duration: 0.6).delay(Double(index) * 0.05), value: animate)
                        Text(labels.indices.contains(index) ? labels[index] : "")
                            .font(AppFont.caption())
                            .foregroundStyle(AppColors.textTertiary)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .onAppear { animate = true }
        }
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.backgroundCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.strokeDefault, lineWidth: AppStroke.default)
        )
    }

    private func barHeight(value: Double, maxValue: Double, height: CGFloat) -> CGFloat {
        let chartHeight = Swift.max(0, height - 24)
        return CGFloat(value / maxValue) * chartHeight
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        BarChart(values: [35, 50, 40, 60, 20, 55, 45], labels: ["M", "T", "W", "T", "F", "S", "S"])
            .padding()
    }
    .preferredColorScheme(.dark)
}
