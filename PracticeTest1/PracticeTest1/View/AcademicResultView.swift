import SwiftUI

struct AcademicResultView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            List {
                ForEach(AcademicRank.allCases, id: \.self) { rank in
                    let list = manager.students(inRank: rank)
                    Section {
                        if list.isEmpty {
                            Text("No students in this rank.")
                                .font(.caption).foregroundColor(.gray)
                        } else {
                            ForEach(list) { student in
                                RankRow(student: student,
                                        avg: manager.weightedAverage(ofStudent: student.getID()),
                                        rank: rank)
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: rank.icon)
                            Text(rank.rawValue.uppercased())
                            Spacer()
                            Text("\(list.count) students").font(.caption)
                        }
                        .foregroundColor(rank.color)
                    }
                }
            }
            .navigationTitle("Academic Ranking")
            .refreshable { manager.refresh() }
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
                        .font(.headline).foregroundColor(rank.color)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(student.getName()).font(.headline)
                Text(student.getID()).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Text(avg.map { String(format: "%.2f", $0) } ?? "—")
                .font(.title3.bold())
                .foregroundColor(rank.color)
        }
        .padding(.vertical, 2)
    }
}