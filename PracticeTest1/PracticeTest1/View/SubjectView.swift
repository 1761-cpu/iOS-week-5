import SwiftUI

struct SubjectView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            List(manager.subjects) { subject in
                SubjectRow(subject: subject)
            }
            .navigationTitle("Subjects")
        }
    }
}

struct SubjectRow: View {
    @EnvironmentObject var manager: SchoolManager
    let subject: Subject

    var body: some View {
        let enrolled = manager.enrolledCount(subjectID: subject.getID())
        let avg      = manager.averageMark(inSubject: subject.getID())

        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(subject.getName()).font(.headline)
                Spacer()
                Text(subject.getID())
                    .font(.caption2.bold().monospaced())
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.purple.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 4))
                    .foregroundColor(.purple)
            }
            HStack(spacing: 16) {
                Label("\(subject.getCredits()) credits", systemImage: "book")
                Label("\(enrolled) enrolled",           systemImage: "person.2")
                Spacer()
                if let avg {
                    Text("Avg \(String(format: "%.2f", avg))")
                        .fontWeight(.semibold)
                        .foregroundColor(avg >= SchoolManager.passMark ? .green : .red)
                } else {
                    Text("No marks").foregroundColor(.gray)
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}