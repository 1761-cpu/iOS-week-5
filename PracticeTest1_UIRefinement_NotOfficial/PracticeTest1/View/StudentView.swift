import SwiftUI

struct StudentView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            List(manager.students) { student in
                NavigationLink {
                    StudentDetailView(student: student)
                } label: {
                    StudentCard(student: student)
                }
                .listRowCard()
            }
            .listStyle(.plain)
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                TopBar(title: "STUDENTS", color: Theme.students, glassTint: Theme.students)
            }
            .refreshable { manager.refresh() }
            .screenBackground("stuView", fit: true, topOffset: 145)
        }
    }
}

#Preview {
    StudentView().environmentObject(SchoolManager.preview())
}
