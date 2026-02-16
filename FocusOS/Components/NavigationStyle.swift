import SwiftUI

extension View {
    func focusNavigationStyle() -> some View {
        self
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
    }
}
