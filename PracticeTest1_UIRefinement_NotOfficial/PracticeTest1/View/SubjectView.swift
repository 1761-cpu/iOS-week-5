import SwiftUI

struct SubjectView: View {
    @EnvironmentObject var manager: SchoolManager

    var body: some View {
        NavigationStack {
            List(manager.subjects) { subject in
                SubjectCard(subject: subject)
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

#Preview {
    SubjectView().environmentObject(SchoolManager.preview())
}
