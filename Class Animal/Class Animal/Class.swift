import Foundation

class Animal: Identifiable {
    let id = UUID()
    
    private var name: String
    private var birthYear: Int
    
    init(name: String, birthYear: Int) {
        self.name = name
        self.birthYear = birthYear
    }
    
    func getName() -> String { return name }
    func getBirthYear() -> Int { return birthYear }
    
    func displayInfo() -> String {
        return "Name: \(name) | Birth Year: \(birthYear)"
    }
    
    func makeSound() -> String {
        return "... (Silent)"
    }
}

class Dog: Animal {
    private var breed: String
    
    init(name: String, birthYear: Int, breed: String) {
        self.breed = breed
        super.init(name: name, birthYear: birthYear)
    }
    
    override func displayInfo() -> String {
        return super.displayInfo() + " | Type: Dog (\(breed))"
    }
    
    override func makeSound() -> String {
        return "Woof woof! 🐶"
    }
}

class Cat: Animal {
    override func makeSound() -> String {
        return "Meow meow! 🐱"
    }
    
    override func displayInfo() -> String {
        return super.displayInfo() + " | Type: Cat"
    }
}

class Bird: Animal {
    override func makeSound() -> String {
        return "Tweet tweet! 🐦"
    }
    
    override func displayInfo() -> String {
        return super.displayInfo() + " | Type: Bird"
    }
}
