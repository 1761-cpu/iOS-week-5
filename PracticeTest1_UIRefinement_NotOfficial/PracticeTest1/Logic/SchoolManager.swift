import Foundation
import Combine

final class SchoolManager: ObservableObject {
    // MARK: - Published data
    @Published private(set) var students: [Student] = []
    @Published private(set) var subjects: [Subject] = []
    @Published private(set) var records:  [StudentRecord] = []

    // MARK: - Thresholds (business rules)
    static let passMark: Double      = 5.0
    static let averageMark: Double   = 5.0
    static let goodMark: Double      = 7.0
    static let excellentMark: Double = 8.5

    init(sample: Bool = false) {
        if sample { loadSampleData() }
    }

    // MARK: - Add
    func addStudent(_ s: Student) throws {
        guard !students.contains(where: { $0.getID() == s.getID() }) else {
            throw AcademicError.duplicateStudent(s.getID())
        }
        students.append(s)
    }

    func addSubject(_ s: Subject) throws {
        guard !subjects.contains(where: { $0.getID() == s.getID() }) else {
            throw AcademicError.duplicateSubject(s.getID())
        }
        subjects.append(s)
    }

    // MARK: - Registration
    func register(studentID: String,
                  subjectID: String,
                  mark: Double = 0,
                  academicYear: Int) throws {
        guard let stu = students.first(where: { $0.getID() == studentID }) else {
            throw AcademicError.studentNotFound(studentID)
        }
        guard let sub = subjects.first(where: { $0.getID() == subjectID }) else {
            throw AcademicError.subjectNotFound(subjectID)
        }

        // Business rule: no duplicate registration of the same subject in the same year
        let exists = records.contains {
            $0.student.getID()   == studentID &&
            $0.subject.getID()   == subjectID &&
            $0.academicYear      == academicYear
        }
        guard !exists else {
            throw AcademicError.duplicateEnrollment(studentID: studentID,
                                                    subjectID: subjectID,
                                                    academicYear: academicYear)
        }

        let rec = StudentRecord(student: stu, subject: sub,
                                mark: mark, academicYear: academicYear)
        try rec.setMark(mark)   // validate mark in [0, 10]
        records.append(rec)
    }

    // MARK: - Update mark (Task 5)
    func updateMark(recordID: UUID, newMark: Double) throws {
        guard let idx = records.firstIndex(where: { $0.id == recordID }) else { return }
        try records[idx].setMark(newMark)
        records = records
    }

    func refresh() {
        objectWillChange.send()
    }

    // MARK: - Queries
    func records(ofStudent id: String) -> [StudentRecord] {
        records.filter { $0.student.getID() == id }
               .sorted { $0.subject.getID() < $1.subject.getID() }
    }

    func students(inRank rank: AcademicRank) -> [Student] {
        students
            .filter { self.rank(ofStudent: $0.getID()) == rank }
            .sorted {
                (weightedAverage(ofStudent: $0.getID()) ?? 0) >
                (weightedAverage(ofStudent: $1.getID()) ?? 0)
            }
    }

    // MARK: - Statistics (Task 3)
    /// Weighted average: Σ(mark × credits) ÷ Σ(credits)
    func weightedAverage(ofStudent id: String) -> Double? {
        let rs = records(ofStudent: id)
        guard !rs.isEmpty else { return nil }
        let weighted = rs.reduce(0.0) { $0 + $1.getMark() * Double($1.subject.getCredits()) }
        let credits  = rs.reduce(0.0) { $0 + Double($1.subject.getCredits()) }
        return credits > 0 ? weighted / credits : nil
    }

    /// Ranking: Excellent ≥ 8.5 | Good ≥ 7.0 | Average ≥ 5.0 | Fail < 5.0
    func rank(ofStudent id: String) -> AcademicRank? {
        guard let avg = weightedAverage(ofStudent: id) else { return nil }
        if avg >= Self.excellentMark { return .excellent }
        if avg >= Self.goodMark      { return .good }
        if avg >= Self.averageMark   { return .average }
        return .fail
    }

    func passedCount(ofStudent id: String) -> Int {
        records(ofStudent: id).filter { $0.isPassed() }.count
    }
    func failedCount(ofStudent id: String) -> Int {
        records(ofStudent: id).filter { !$0.isPassed() }.count
    }

    func enrolledCount(subjectID: String) -> Int {
        Set(records.filter { $0.subject.getID() == subjectID }
                    .map { $0.student.getID() }).count
    }

    func averageMark(inSubject id: String) -> Double? {
        let rs = records.filter { $0.subject.getID() == id }
        guard !rs.isEmpty else { return nil }
        return rs.reduce(0.0) { $0 + $1.getMark() } / Double(rs.count)
    }

    // MARK: - Sample data (≥4 students, ≥4 subjects, ≥8 records)
    private func loadSampleData() {
        let sv1 = Student(id: "SV001", name: "Nguyễn Ánh", age: 20)
        let sv2 = Student(id: "SV002", name: "Phạm Bảo", age: 21)
        let sv3 = Student(id: "SV003", name: "Trần Đông", age: 20)
        let sv4 = Student(id: "SV004", name: "Hạ Cẩm", age: 22)
        students = [sv1, sv2, sv3, sv4]

        let ios = Subject(id: "CSE101", name: "iOS Programming",  credits: 3)
        let dsa = Subject(id: "CSE201", name: "Data Structures",  credits: 4)
        let alg = Subject(id: "CSE301", name: "Algorithms",       credits: 3)
        let db  = Subject(id: "CSE202", name: "Database Systems", credits: 3)
        subjects = [ios, dsa, alg, db]

        records = [
            // SV001 – Excellent
            StudentRecord(student: sv1, subject: ios, mark: 9.0, academicYear: 2024),
            StudentRecord(student: sv1, subject: dsa, mark: 8.5, academicYear: 2024),
            StudentRecord(student: sv1, subject: alg, mark: 9.5, academicYear: 2024),
            // SV002 – Average (one fail inside)
            StudentRecord(student: sv2, subject: ios, mark: 4.0, academicYear: 2024),
            StudentRecord(student: sv2, subject: dsa, mark: 6.5, academicYear: 2024),
            StudentRecord(student: sv2, subject: db,  mark: 7.0, academicYear: 2024),
            // SV003 – Average
            StudentRecord(student: sv3, subject: ios, mark: 5.0, academicYear: 2024),
            StudentRecord(student: sv3, subject: alg, mark: 5.5, academicYear: 2024),
            // SV004 – Good
            StudentRecord(student: sv4, subject: dsa, mark: 8.0, academicYear: 2024),
            StudentRecord(student: sv4, subject: db,  mark: 8.5, academicYear: 2024),
        ]
    }
}

extension SchoolManager {
    static func preview() -> SchoolManager {
        SchoolManager(sample: true)
    }
}
