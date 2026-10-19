import SwiftUI

struct StudentView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            List(manager.students) { student in
                NavigationLink {
                    StudentDetailView(student: student)
                } label: {
                    StudentRow(student: student)
                }
                .listRowCard()
            }
            .listStyle(.plain)
            .toolbar(.hidden, for: .navigationBar) // 👈 Ẩn thanh mặc định
            .safeAreaInset(edge: .top, spacing: 0) {
                TopBar(title: "STUDENTS", color: Theme.students, glassTint: Theme.students)
            }
            .refreshable { manager.refresh() }
            .screenBackground("stuView",
                              fit: true,
                              topOffset: 145)
        }
    }
}

struct StudentRow: View {
    @EnvironmentObject var manager: SchoolManager
    let student: Student

    var body: some View {
        let avg  = manager.weightedAverage(ofStudent: student.getID())
        let rank = manager.rank(ofStudent: student.getID())

        HStack(spacing: 12) {
            Circle()
                .fill(Theme.students.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(student.getName().prefix(1)).uppercased())
                        .font(.headline)
                        .foregroundColor(Theme.students)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(student.getName()).font(.headline)
                Text("\(student.getID()) · Age \(student.getAge())")
                    .font(.caption).foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(avg.map { String(format: "%.2f", $0) } ?? "—")
                    .font(.title3.bold())
                    .foregroundColor(rank?.color ?? .gray)
                if let rank {
                    Text(rank.rawValue)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(rank.color.opacity(0.15), in: Capsule())
                        .foregroundColor(rank.color)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StudentView().environmentObject(SchoolManager.preview())
}
