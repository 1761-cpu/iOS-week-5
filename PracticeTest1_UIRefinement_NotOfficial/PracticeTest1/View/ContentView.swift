import SwiftUI

struct ContentView: View {
    @StateObject private var manager = SchoolManager(sample: true)

    var body: some View {
        TabView {
            StudentView()
                .tabItem { Label("Students", systemImage: "person.3.fill") }

            SubjectView()
                .tabItem { Label("Subjects", systemImage: "book.fill") }

            AcademicResultView()
                .tabItem { Label("Ranking", systemImage: "chart.bar.fill") }
        }
        .tint(Theme.students) 
        .environmentObject(manager)
    }
}

#Preview {
    ContentView()
}
