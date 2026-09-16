import SwiftUI

struct WelcomeView: View {
    let onStart: () -> Void

    @State private var animating = false

    var body: some View {
        ZStack {
            AppColors.bg.ignoresSafeArea()

            MapLinesBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image("rutax-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)

                HStack(spacing: 0) {
                    Text("RUTA")
                        .font(.system(size: 44, weight: .black))
                        .foregroundColor(AppColors.text)
                    Text("X")
                        .font(.system(size: 44, weight: .black))
                        .foregroundColor(AppColors.primary)
                }
                .padding(.top, AppSpacing.lg)

                Rectangle()
                    .fill(AppColors.primary)
                    .frame(width: 52, height: 2.5)
                    .padding(.top, AppSpacing.sm)

                Text("Tu trufi, en tiempo real.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.muted)
                    .padding(.top, AppSpacing.md)

                Spacer()

                LoadingDots(animating: animating)
                    .padding(.bottom, AppSpacing.md)

                Text("COCHABAMBA  ·  BOLIVIA")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(3)
                    .foregroundColor(AppColors.muted.opacity(0.7))
                    .padding(.bottom, AppSpacing.xxl + AppSpacing.sm)
            }
        }
        .onTapGesture { onStart() }
        .onAppear { animating = true }
    }
}

private struct LoadingDots: View {
    let animating: Bool

    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 7, height: 7)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .opacity(animating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.18),
                        value: animating
                    )
            }
        }
    }
}

private struct MapLinesBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let curves: [(CGPoint, CGPoint, CGPoint, CGPoint)] = [
                (
                    CGPoint(x: size.width * 0.0,  y: size.height * 0.15),
                    CGPoint(x: size.width * 0.3,  y: size.height * 0.05),
                    CGPoint(x: size.width * 0.6,  y: size.height * 0.25),
                    CGPoint(x: size.width * 1.0,  y: size.height * 0.10)
                ),
                (
                    CGPoint(x: size.width * 0.0,  y: size.height * 0.35),
                    CGPoint(x: size.width * 0.25, y: size.height * 0.20),
                    CGPoint(x: size.width * 0.75, y: size.height * 0.45),
                    CGPoint(x: size.width * 1.0,  y: size.height * 0.30)
                ),
                (
                    CGPoint(x: size.width * 0.1,  y: size.height * 0.0),
                    CGPoint(x: size.width * 0.2,  y: size.height * 0.4),
                    CGPoint(x: size.width * 0.35, y: size.height * 0.6),
                    CGPoint(x: size.width * 0.5,  y: size.height * 1.0)
                ),
                (
                    CGPoint(x: size.width * 0.5,  y: size.height * 0.0),
                    CGPoint(x: size.width * 0.65, y: size.height * 0.3),
                    CGPoint(x: size.width * 0.8,  y: size.height * 0.55),
                    CGPoint(x: size.width * 0.9,  y: size.height * 1.0)
                ),
                (
                    CGPoint(x: size.width * 0.0,  y: size.height * 0.65),
                    CGPoint(x: size.width * 0.4,  y: size.height * 0.55),
                    CGPoint(x: size.width * 0.7,  y: size.height * 0.75),
                    CGPoint(x: size.width * 1.0,  y: size.height * 0.60)
                ),
            ]

            for (p0, c1, c2, p3) in curves {
                var path = Path()
                path.move(to: p0)
                path.addCurve(to: p3, control1: c1, control2: c2)
                ctx.stroke(
                    path,
                    with: .color(AppColors.text.opacity(0.07)),
                    style: StrokeStyle(lineWidth: 1.2)
                )
            }
        }
    }
}

#Preview {
    WelcomeView(onStart: {})
}
