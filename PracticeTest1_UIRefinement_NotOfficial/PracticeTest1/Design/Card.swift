import SwiftUI

// MARK: StudentCard
struct StudentCard: View {
    @EnvironmentObject var manager: SchoolManager
    let student: Student

    var body: some View {
        let id = student.getID()
        let avg = manager.weightedAverage(ofStudent: id)
        let rank = manager.rank(ofStudent: id)
        let recs = manager.records(ofStudent: id)
        let credits = recs.reduce(0) { $0 + $1.subject.getCredits() }
        let passed = manager.passedCount(ofStudent: id)
        let failed = manager.failedCount(ofStudent: id)

        VStack(alignment: .leading, spacing: 10) {
            // Head
            HStack(spacing: 12) {
                LetterAvatar(letter: String(student.getName().prefix(1)), color: Theme.students)
                VStack(alignment: .leading, spacing: 4) {
                    Text(student.getName()).font(.headline)
                    IDChip(text: id, color: Theme.students)
                }
                Spacer()
            }

            // Body
            InfoRow(label: "Age", value: String(student.getAge()))
            InfoRow(label: "Enrolled", value: "\(recs.count) subjects (\(credits) credits)")
            HStack(spacing: 6) {
                StatusPill(text: "\(passed) passed", color: Theme.passed)
                if failed > 0 {
                    StatusPill(text: "\(failed) failed", color: Theme.danger)
                }
                Spacer()
            }

            Divider()

            // Foot
            HStack(alignment: .bottom) {
                MetricBlock(label: "Weighted average",
                            value: avg.map { String(format: "%.2f", $0) } ?? "—",
                            color: rank?.color ?? .gray)
                Spacer()
                if let rank {
                    StatusPill(text: rank.rawValue, color: rank.color)
                }
            }
        }
    }
}

// MARK: SubjectCard
struct SubjectCard: View {
    @EnvironmentObject var manager: SchoolManager
    let subject: Subject

    var body: some View {
        let id = subject.getID()
        let recs = manager.records.filter { $0.subject.getID() == id }
        let enrolled = manager.enrolledCount(subjectID: id)
        let avg = manager.averageMark(inSubject: id)
        let passed = recs.filter { $0.isPassed() }.count
        let failed = recs.count - passed
        let passRate = recs.isEmpty ? "—"
                                    : "\(Int((Double(passed) / Double(recs.count) * 100).rounded()))%"
        let avgColor: Color = avg.map { $0 >= SchoolManager.passMark ? Theme.passed : Theme.danger } ?? .gray

        VStack(alignment: .leading, spacing: 10) {
            // Head
            HStack(spacing: 12) {
                IconBadge(systemName: "book.fill", color: Theme.subjects)
                VStack(alignment: .leading, spacing: 4) {
                    Text(subject.getName()).font(.headline)
                    IDChip(text: id, color: Theme.subjects)
                }
                Spacer()
            }

            // Body
            StatBox(items: [("Credits", String(subject.getCredits())),
                            ("Enrolled", String(enrolled)),
                            ("Pass rate", passRate)])

            Divider()

            // Foot
            HStack(alignment: .bottom) {
                MetricBlock(label: "Average mark",
                            value: avg.map { String(format: "%.2f", $0) } ?? "—",
                            color: avgColor)
                Spacer()
                if recs.isEmpty {
                    StatusPill(text: "No marks", color: .gray)
                } else if failed > 0 {
                    StatusPill(text: "\(failed) failed", color: Theme.danger)
                } else {
                    StatusPill(text: "100% pass", color: Theme.passed)
                }
            }
        }
    }
}

// MARK: RecordCard (in StudentDetailView)
struct RecordCard: View {
    @ObservedObject var record: StudentRecord

    var body: some View {
        let passed = record.isPassed()

        HStack(spacing: 12) {
            IconBadge(systemName: "book.fill", color: Theme.subjects, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.subject.getName()).font(.headline)
                HStack(spacing: 6) {
                    IDChip(text: record.subject.getID(), color: Theme.subjects)
                    Text(verbatim: "\(record.subject.getCredits()) credits · \(record.academicYear)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f", record.getMark()))
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundColor(passed ? Theme.marks : Theme.danger)
                StatusPill(text: passed ? "PASSED" : "FAILED",
                           color: passed ? Theme.passed : Theme.danger)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .contentShape(Rectangle())
    }
}
