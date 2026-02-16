import SwiftUI

struct Motion {
    static let snappy = Animation.snappy(duration: 0.2, extraBounce: 0.1)
    static let ease = Animation.easeInOut(duration: 0.25)
    static let pulse = Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)
}
