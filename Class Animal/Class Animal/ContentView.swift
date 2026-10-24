import SwiftUI

struct ContentView: View {
    let animals: [Animal] = [
        Dog(name: "Buddy", birthYear: 2022, breed: "Poodle"),
        Cat(name: "Whiskers", birthYear: 2021),
        Bird(name: "Tweety", birthYear: 2023)
    ]
    
    var body: some View {
        NavigationStack {
            List(animals) { animal in
                VStack(alignment: .leading, spacing: 8) {
                    Text(animal.displayInfo())
                        .font(.headline)
                    
                    Text("Sound: \(animal.makeSound())")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Animal")
        }
    }
}

#Preview {
    ContentView()
}
