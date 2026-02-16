import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat

    init(progress: Double, lineWidth: CGFloat = 10) {
        self.progress = progress
        self.lineWidth = lineWidth
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.strokeDefault, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0, min(progress, 1)))
                .stroke(AppColors.gold, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(Motion.ease, value: progress)
        }
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        ProgressRing(progress: 0.7, lineWidth: 12)
            .frame(width: 140, height: 140)
    }
    .preferredColorScheme(.dark)
}
