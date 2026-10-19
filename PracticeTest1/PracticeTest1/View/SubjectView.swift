import SwiftUI

struct SubjectView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            List(manager.subjects) { subject in
                SubjectRow(subject: subject)
                    .listRowCard()
            }
            .listStyle(.plain)
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                TopBar(title: "SUBJECTS", color: Theme.subjects, glassTint: Theme.subjects)
            }
            .screenBackground("subView", fit: true, topOffset: 135)
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
                    .background(Theme.subjects.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 4))
                    .foregroundColor(Theme.subjects)
            }

            HStack(spacing: 16) {
                Label("\(subject.getCredits()) credits", systemImage: "book")
                Label("\(enrolled) enrolled",           systemImage: "person.2")
                Spacer()
                if let avg {
                    Text("Avg \(String(format: "%.2f", avg))")
                        .fontWeight(.semibold)
                        .foregroundColor(avg >= SchoolManager.passMark
                                         ? Theme.passed : Theme.danger)
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

#Preview {
    SubjectView().environmentObject(SchoolManager.preview())
}
