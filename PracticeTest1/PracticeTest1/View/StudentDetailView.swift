import SwiftUI

struct StudentDetailView: View {
    @EnvironmentObject var manager: SchoolManager
    let student: Student

    @State private var editingRecord: StudentRecord?

    var body: some View {
        let rs   = manager.records(ofStudent: student.getID())
        let avg  = manager.weightedAverage(ofStudent: student.getID())
        let rank = manager.rank(ofStudent: student.getID())

        List {
            // MARK: Thông tin sinh viên
            Section("Thông tin") {
                LabeledContent("ID", value: student.getID())
                LabeledContent("Họ tên", value: student.getName())
                LabeledContent("Tuổi", value: "\(student.getAge())")
            }

            // MARK: Kết quả học tập
            Section("Kết quả học tập") {
                HStack {
                    MetricCell(title: "GPA",
                               value: avg.map { String(format: "%.2f", $0) } ?? "—",
                               color: rank?.color ?? .gray)
                    Divider()
                    MetricCell(title: "Đạt",
                               value: "\(manager.passedCount(ofStudent: student.getID()))",
                               color: .green)
                    Divider()
                    MetricCell(title: "Rớt",
                               value: "\(manager.failedCount(ofStudent: student.getID()))",
                               color: .red)
                }
                if let rank {
                    HStack {
                        Text("Xếp loại:")
                        Spacer()
                        RankBadge(rank: rank)
                    }
                }
            }

            // MARK: Danh sách môn + điểm
            Section("Môn học & Điểm") {
                if rs.isEmpty {
                    Text("Chưa có môn nào.").foregroundColor(.gray)
                }
                ForEach(rs) { r in
                    Button {
                        editingRecord = r
                    } label: {
                        RecordRow(record: r)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(student.getName())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingRecord) { r in
            EditMarkView(record: r).environmentObject(manager)
        }
    }
}

// MARK: - Subviews
private struct MetricCell: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.bold())
                .foregroundColor(.gray)
            Text(value)
                .font(.title3.bold().monospacedDigit())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct RecordRow: View {
    let record: StudentRecord
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.subject.getName()).font(.body)
                HStack(spacing: 8) {
                    Text(record.subject.getID())
                        .font(.caption.monospaced())
                        .foregroundColor(.gray)
                    Text("\(record.subject.getCredits()) TC")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Năm \(record.academicYear)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f", record.getMark()))
                    .font(.headline.monospacedDigit())
                    .foregroundColor(record.isPassed() ? .green : .red)
                Text(record.isPassed() ? "PASS" : "FAIL")
                    .font(.caption2.bold())
                    .foregroundColor(record.isPassed() ? .green : .red)
            }
            Image(systemName: "pencil.circle.fill")
                .foregroundColor(.blue.opacity(0.7))
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        StudentDetailView(student: SchoolManager.preview().students[0])
            .environmentObject(SchoolManager.preview())
    }
}