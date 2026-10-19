import Foundation

class Student: Identifiable {
    var id: String
    private var name: String
    private var age: Int

    // MARK: - Initializer
    init(id: String, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }

    // MARK: - Getters
    func getID() -> String  { return id }
    func getName() -> String { return name }
    func getAge() -> Int     { return age }

    // MARK: - Setters
    func setName(_ newName: String) throws {
        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AcademicError.emptyField("Student Name")
        }
        self.name = newName
    }

    func setAge(_ newAge: Int) throws {
        guard newAge > 0 else { throw AcademicError.invalidAge(newAge) }
        self.age = newAge
    }

    func setID(_ newID: String) throws {
        guard !newID.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AcademicError.emptyField("Student ID")
        }
        self.id = newID
    }

    // MARK: - Display
    func displayInfo() -> String {
        return "Student[ID=\(id), Name=\(name), Age=\(age)]"
    }
}
