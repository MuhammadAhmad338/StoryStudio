import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Group {
                #if os(iOS)
                Color(.systemBackground)
                #else
                Color(NSColor.textBackgroundColor)
                #endif
            }
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.purple)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

                Text("StoryStudio")
                    .font(.googleSansFlex(size: 42, weight: .bold))
                    .foregroundStyle(.primary)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
