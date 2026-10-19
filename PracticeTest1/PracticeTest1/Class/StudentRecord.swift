import Foundation

class StudentRecord: Identifiable {
    /// Cần `Identifiable` để dùng trong SwiftUI `ForEach`
    let id = UUID()

    var student: Student
    var subject: Subject
    private var mark: Double
    var academicYear: Int   // cần để kiểm tra trùng môn trong cùng năm học

    // MARK: - Initializer
    init(student: Student,
         subject: Subject,
         mark: Double = 0,
         academicYear: Int) {
        self.student = student
        self.subject = subject
        // Clamp an toàn cho init — setter mới throw error
        self.mark = min(max(mark, 0.0), 10.0)
        self.academicYear = academicYear
    }

    // MARK: - Mark
    func getMark() -> Double { return mark }

    /// Setter có validate: ném lỗi nếu điểm ngoài [0, 10]
    func setMark(_ newMark: Double) throws {
        guard (0.0...10.0).contains(newMark) else {
            throw AcademicError.invalidMark(newMark)
        }
        self.mark = newMark
    }

    // MARK: - Passed?
    /// Theo business rule: mark >= 5.0 là đạt
    func isPassed() -> Bool {
        return mark >= 5.0
    }

    // MARK: - Display
    func displayInfo() -> String {
        let status = isPassed() ? "PASSED" : "FAILED"
        return "Record[\(student.getName()) – \(subject.getName()), mark=\(mark), \(status)]"
    }
}