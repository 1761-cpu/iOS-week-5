import Foundation
import Combine

class StudentRecord: Identifiable, ObservableObject {
    let id = UUID()
    var student: Student
    var subject: Subject
    @Published private(set) var mark: Double
    var academicYear: Int

    // MARK: - Initializer
    init(student: Student,
         subject: Subject,
         mark: Double = 0.0,
         academicYear: Int) {
        self.student = student
        self.subject = subject
        self.academicYear = academicYear
        // Clamp an toàn khi khởi tạo
        self.mark = min(max(mark, 0.0), 10.0)
    }

    // MARK: - Methods
    func getMark() -> Double { return mark }

    func setMark(_ newMark: Double) throws {
        guard (0.0...10.0).contains(newMark) else {
            throw AcademicError.invalidMark(newMark)
        }
        self.mark = newMark 
    }

    func isPassed() -> Bool {
        return mark >= 5.0
    }

    func displayInfo() -> String {
        let status = isPassed() ? "PASSED" : "FAILED"
        return "Record: \(student.getName()) – \(subject.getName()): \(mark) (\(status))"
    }
}
