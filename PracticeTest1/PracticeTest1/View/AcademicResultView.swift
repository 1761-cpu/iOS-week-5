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
                
                List {
                    ForEach(AcademicRank.allCases, id: \.self) { rank in
                        let list = manager.students(inRank: rank)
                        
                        Section {
                            if list.isEmpty {
                                Text("No students in this rank.")
                                    .font(.caption).foregroundColor(.gray)
                                    .listRowCard()
                            } else {
                                ForEach(list) { student in
                                    RankRow(student: student,
                                            avg: manager.weightedAverage(ofStudent: student.getID()),
                                            rank: rank)
                                    .listRowCard(fill: rank.color.opacity(0.08),
                                                 border: rank.color.opacity(0.30))
                                }
                            }
                        } header: {
                            // Dùng SectionTag thay cho Text thông thường
                            SectionTag("\(rank.rawValue.uppercased()) - \(list.count) students", systemImage: rank.icon, color: rank.color)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .toolbar(.hidden, for: .navigationBar)
                .safeAreaInset(edge: .top, spacing: 0) {
                    TopBar(title: "RANKING", color: Theme.ranking, glassTint: Theme.ranking)
                }
                .refreshable { manager.refresh() }
            }
        }
    }
}

struct RankRow: View {
    let student: Student
    let avg: Double?
    let rank: AcademicRank

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(rank.color.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(student.getName().prefix(1)).uppercased())
                        .font(.headline)
                        .foregroundColor(rank.color)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(student.getName()).font(.headline)
                Text(student.getID()).font(.caption).foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 4) {
                if rank == .excellent {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.gold)
                        .font(.caption)
                }
                Text(avg.map { String(format: "%.2f", $0) } ?? "—")
                    .font(.title3.bold())
                    .foregroundColor(rank.color)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    AcademicResultView().environmentObject(SchoolManager.preview())
}
