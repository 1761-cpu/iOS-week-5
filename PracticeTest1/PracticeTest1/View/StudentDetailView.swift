import SwiftUI

struct StudentDetailView: View {
    @EnvironmentObject var manager: SchoolManager
    let student: Student
    @State private var editingRecord: StudentRecord?

    var body: some View {
        let avg     = manager.weightedAverage(ofStudent: student.getID())
        let rank    = manager.rank(ofStudent: student.getID())
        let passed  = manager.passedCount(ofStudent: student.getID())
        let failed  = manager.failedCount(ofStudent: student.getID())
        let records = manager.records(ofStudent: student.getID())

        List {
            // MARK: Info
            Section("Student Info") {
                LabeledContent("ID",   value: student.getID())
                LabeledContent("Name", value: student.getName())
                LabeledContent("Age",  value: "\(student.getAge())")
            }

            // MARK: Summary
            Section("Summary") {
                LabeledContent("Weighted Average",
                               value: avg.map { String(format: "%.2f", $0) } ?? "—")

                HStack {
                    Text("Academic Rank")
                    Spacer()
                    if let rank {
                        Text(rank.rawValue)
                            .font(.subheadline.bold())
                            .padding(.horizontal, 8).padding(.vertical, 2)
                            .background(rank.color.opacity(0.15), in: Capsule())
                            .foregroundColor(rank.color)
                    } else {
                        Text("—").foregroundColor(.gray)
                    }
                }

                HStack {
                    Text("Passed Subjects")
                    Spacer()
                    Text("\(passed)")
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.passed)
                }
                HStack {
                    Text("Failed Subjects")
                    Spacer()
                    Text("\(failed)")
                        .fontWeight(.semibold)
                        .foregroundColor(failed > 0 ? Theme.danger : .gray)
                }
            }

            // MARK: Records
            Section {
                if records.isEmpty {
                    Text("No records yet.")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    ForEach(records) { record in
                        Button { editingRecord = record } label: {
                            RecordRow(record: record)
                        }
                        .buttonStyle(.plain)
                    }
                }
            } header: {
                SectionTag("Records (Tap to Edit)", systemImage: "pencil", color: Theme.marks)
            }
        }
        .navigationTitle(student.getName())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingRecord) { record in
            EditMarkView(record: record)
                .environmentObject(manager)
        }
    }
}

struct RecordRow: View {
    @ObservedObject var record: StudentRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(record.subject.getName()).font(.body)
                Text("\(record.subject.getID()) · \(record.subject.getCredits()) credits · \(record.academicYear)")
                    .font(.caption).foregroundColor(.gray)
            }
            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.1f", record.getMark()))
                    .font(.title3.bold())
                    .foregroundColor(Theme.marks)
                Text(record.isPassed() ? "PASSED" : "FAILED")
                    .font(.caption2.bold())
                    .foregroundColor(record.isPassed() ? Theme.passed : Theme.danger)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        StudentDetailView(student: SchoolManager.preview().students[0])
            .environmentObject(SchoolManager.preview())
    }
}
