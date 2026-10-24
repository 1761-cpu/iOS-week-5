import SwiftUI

struct StudentDetailView: View {
    @EnvironmentObject var manager: SchoolManager
    let student: Student
    @State private var editingRecord: StudentRecord?

    var body: some View {
        let id      = student.getID()
        let avg     = manager.weightedAverage(ofStudent: id)
        let rank    = manager.rank(ofStudent: id)
        let passed  = manager.passedCount(ofStudent: id)
        let failed  = manager.failedCount(ofStudent: id)
        let records = manager.records(ofStudent: id)
        let credits = records.reduce(0) { $0 + $1.subject.getCredits() }

        List {
            // MARK: Profile & Summary Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 14) {
                    LetterAvatar(letter: String(student.getName().prefix(1)),
                                 color: Theme.students, size: 56)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(student.getName()).font(.title3.bold())
                        HStack(spacing: 6) {
                            IDChip(text: id, color: Theme.students)
                            Text(verbatim: "Age \(student.getAge())")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }

                Divider()

                HStack(alignment: .bottom) {
                    MetricBlock(label: "Weighted average",
                                value: avg.map { String(format: "%.2f", $0) } ?? "—",
                                color: rank?.color ?? .gray)
                    Spacer()
                    if let rank {
                        StatusPill(text: rank.rawValue, color: rank.color)
                    }
                }

                StatBox(items: [("Passed", String(passed)),
                                ("Failed", String(failed)),
                                ("Credits", String(credits))])
            }
            .listRowCard()

            // MARK: Record List
            Section {
                if records.isEmpty {
                    EmptyHint(systemImage: "tray", text: "No records yet.")
                        .listRowCard()
                } else {
                    ForEach(records) { record in
                        Button { editingRecord = record } label: {
                            RecordCard(record: record)
                        }
                        .buttonStyle(.plain)
                        .listRowCard()
                    }
                }
            } header: {
                SectionTag("Records (Tap to Edit)", systemImage: "pencil", color: Theme.marks)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Theme.tintBackdrop.ignoresSafeArea())
        .navigationTitle(student.getName())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingRecord) { record in
            EditMarkView(record: record)
                .environmentObject(manager)
        }
    }
}

#Preview {
    NavigationStack {
        StudentDetailView(student: SchoolManager.preview().students[0])
            .environmentObject(SchoolManager.preview())
    }
}
