import SwiftUI

// MARK: - Chips & Badges
struct IDChip: View {
    let text: String
    var color: Color = Theme.students

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 5))
    }
}

struct StatusPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
    }
}

// MARK: - Avatars
struct LetterAvatar: View {
    let letter: String
    let color: Color
    var size: CGFloat = 44

    var body: some View {
        Text(letter.uppercased())
            .font(.system(size: size * 0.45, weight: .bold))
            .foregroundColor(color)
            .frame(width: size, height: size)
            .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct IconBadge: View {
    let systemName: String
    let color: Color
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundColor(color)
            .frame(width: size, height: size)
            .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Info Rows & Metrics
struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).foregroundColor(.gray)
            Spacer()
            Text(value).fontWeight(.medium)
        }
        .font(.system(size: 13))
    }
}

struct MetricBlock: View {
    let label: String
    let value: String
    var color: Color = .primary

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
    }
}

/// Rounded gray box containing multiple side-by-side metrics
struct StatBox: View {
    let items: [(label: String, value: String)]

    var body: some View {
        HStack(alignment: .top) {
            ForEach(items.indices, id: \.self) { i in
                VStack(alignment: .leading, spacing: 2) {
                    Text(items[i].label.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                    Text(items[i].value)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.10), in: RoundedRectangle(cornerRadius: 10))
    }
}

struct EmptyHint: View {
    let systemImage: String
    let text: String
    var color: Color = .gray

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(text)
        }
        .font(.subheadline)
        .foregroundColor(color)
    }
}

// MARK: - Summary Banner
struct SummaryBanner: View {
    let icon: String
    let title: String
    let subtitle: String
    let value: String
    let valueLabel: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 14, weight: .bold))
                Text(subtitle).font(.system(size: 11)).foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                Text(value)
                    .font(.system(size: 26, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                Text(valueLabel).font(.system(size: 10)).foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 16)
    }
}
