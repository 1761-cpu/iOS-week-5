import SwiftUI
import UIKit

// ==========================================
// MARK: - SCREEN BACKGROUND
// ==========================================
extension View {
    /// - Parameters:

    ///   - fit:
    ///   - topOffset:
    ///   - fallback: màu nền nếu không tìm thấy ảnh.
    func screenBackground(
        _ imageName: String = " ",
        opacity: Double = 0.3,                /// overlay xám (0 = sáng, 1 = tối). Mặc định 0.3.
        fit: Bool = false,                    ///`true` → ảnh blur full-screen + ảnh focus phần trên (có mask gradient), dùng cho list/form.
        topOffset: CGFloat = 0,               /// đẩy ảnh focus xuống (bù cho nav bar / top bar).
        fallback: Color = Theme.tintBackdrop  ///màu nền nếu không tìm thấy ảnh.
    ) -> some View {
        self.scrollContentBackground(.hidden)
            .background {
                GeometryReader { geo in
                    ZStack(alignment: .top) {

                        if UIImage(named: imageName) != nil {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .scaleEffect(fit ? 1.15 : 1)
                                .blur(radius: fit ? 30 : 0) /// (blur nếu fit = true)
                                .clipped()

                            if fit {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width)
                                    .mask(
                                        LinearGradient(stops: [
                                            .init(color: .clear, location: 0),
                                            .init(color: .black, location: 0.08),
                                            .init(color: .black, location: 0.92),
                                            .init(color: .clear, location: 1)
                                        ], startPoint: .top, endPoint: .bottom)
                                    )
                                    .padding(.top, topOffset)
                            }
                        } else {
                            LinearGradient(
                                colors: [fallback, fallback.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                    .clipped()
                    .overlay(Color.gray.opacity(opacity))
                }
                .ignoresSafeArea()
            }
    }
}

// ==========================================
// MARK: - LIST ROW CARD
// ==========================================
struct ListRowCard: ViewModifier {
    var inset: CGFloat = 16
    var fill: Color = Theme.cardFill
    var border: Color = .clear

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 12).fill(fill))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(border, lineWidth: 1))
            .listRowInsets(EdgeInsets(top: 10, leading: inset, bottom: 4, trailing: inset))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

extension View {
    func listRowCard(
        inset: CGFloat = 16,
        fill: Color = Theme.cardFill,
        border: Color = .clear
    ) -> some View {
        modifier(ListRowCard(inset: inset, fill: fill, border: border))
    }
}

#Preview {
    ContentView()
}
