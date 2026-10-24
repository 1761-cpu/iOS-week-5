import SwiftUI

struct AcademicResultView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.2),
                        Color.indigo.opacity(0.1),
                        Color.yellow.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 12) {
                    SummaryBanner(
                        icon: "chart.bar.fill",
                        title: "Academic ranking",
                        subtitle: String(format: "Excellent ≥ %.1f · Good ≥ %.1f · Average ≥ %.1f",
                                         SchoolManager.excellentMark,
                                         SchoolManager.goodMark,
                                         SchoolManager.averageMark),
                        value: String(manager.students.count),
                        valueLabel: "students",
                        color: Theme.ranking
                    )

                    List {
                        ForEach(AcademicRank.allCases, id: \.self) { rank in
                            let list = manager.students(inRank: rank)

                            Section {
                                if list.isEmpty {
                                    EmptyHint(systemImage: "tray", text: "No students in this rank.")
                                        .listRowCard()
                                } else {
                                    ForEach(list) { student in
                                        RankRow(student: student,
                                                avg: manager.weightedAverage(ofStudent: student.getID()),
                                                rank: rank)
                                            .listRowCard(fill: rank.color.opacity(0.10),
                                                         border: rank.color.opacity(0.30))
                                    }
                                }
                            } header: {
                                SectionTag("\(rank.rawValue.uppercased()) - \(list.count) students",
                                           systemImage: rank.icon,
                                           color: rank.color)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .refreshable { manager.refresh() }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                TopBar(title: "RANKING", color: Theme.ranking, glassTint: Theme.ranking)
            }
        }
    }
}

struct RankRow: View {
    @EnvironmentObject var manager: SchoolManager
    let student: Student
    let avg: Double?
    let rank: AcademicRank

    var body: some View {
        let count = manager.records(ofStudent: student.getID()).count

        HStack(spacing: 12) {
            LetterAvatar(letter: String(student.getName().prefix(1)), color: rank.color, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(student.getName()).font(.headline)
                HStack(spacing: 6) {
                    IDChip(text: student.getID(), color: rank.color)
                    Text(verbatim: "\(count) subjects")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            HStack(spacing: 4) {
                if rank == .excellent {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.gold)
                        .font(.caption)
                }
                Text(avg.map { String(format: "%.2f", $0) } ?? "—")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(rank.color)
            }
        }
    }
}

#Preview {
    AcademicResultView().environmentObject(SchoolManager.preview())
}
