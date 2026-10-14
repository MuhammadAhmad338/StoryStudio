import SwiftUI

struct StoryCanvasView: View {
    let colors: [Color]
    let title: String
    let subtitle: String
    let sticker: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: geometry.size.width * 0.85)
                    .offset(
                        x: geometry.size.width * 0.35,
                        y: -geometry.size.height * 0.3
                    )

                VStack(spacing: 0) {
                    HStack {
                        Text("YOUR BRAND")
                            .font(.system(
                                size: geometry.size.width * 0.033,
                                weight: .bold
                            ))
                            .tracking(2)

                        Spacer()

                        Image(systemName: "sparkles")
                    }

                    Spacer()

                    Text(sticker)
                        .font(.system(
                            size: geometry.size.width * 0.16
                        ))
                        .padding(.bottom, 18)

                    Text(title.isEmpty ? "YOUR STORY" : title.uppercased())
                        .font(.system(
                            size: geometry.size.width * 0.105,
                            weight: .black,
                            design: .rounded
                        ))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .lineLimit(4)

                    Text(subtitle)
                        .font(.system(
                            size: geometry.size.width * 0.038
                        ))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .padding(.top, 16)

                    Spacer()

                    Text("@YOURUSERNAME")
                        .font(.system(
                            size: geometry.size.width * 0.03,
                            weight: .semibold
                        ))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, geometry.size.width * 0.09)
                .padding(.vertical, geometry.size.height * 0.07)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .clipped()
        }
    }
}
