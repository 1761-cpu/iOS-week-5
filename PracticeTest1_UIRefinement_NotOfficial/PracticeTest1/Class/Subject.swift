import Foundation

class Subject: Identifiable {
    var id: String
    private var name: String
    private var credits: Int

    // MARK: - Initializer
    init(id: String, name: String, credits: Int) {
        self.id = id
        self.name = name
        self.credits = credits
    }

    // MARK: - Getters
    func getID() -> String    { return id }
    func getName() -> String  { return name }
    func getCredits() -> Int  { return credits }

    // MARK: - Setters
    func setName(_ newName: String) throws {
        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AcademicError.emptyField("Subject Name")
        }
        self.name = newName
    }

    func setCredits(_ newCredits: Int) throws {
        guard newCredits > 0 else { throw AcademicError.invalidCredits(newCredits) }
        self.credits = newCredits
    }

    func setID(_ newID: String) throws {
        guard !newID.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AcademicError.emptyField("Subject ID")
        }
        self.id = newID
    }

    // MARK: - Display
    func displayInfo() -> String {
        return "Subject[ID=\(id), Name=\(name), Credits=\(credits)]"
    }
}
