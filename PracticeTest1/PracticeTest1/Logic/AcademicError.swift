import Foundation

enum AcademicError: LocalizedError {
    case emptyField(String)
    case duplicateStudent(String)
    case duplicateSubject(String)
    case studentNotFound(String)
    case subjectNotFound(String)
    case invalidMark(Double)
    case invalidCredits(Int)
    case invalidAge(Int)
    case duplicateEnrollment(studentID: String, subjectID: String, academicYear: Int)

    var errorDescription: String? {
        switch self {
        case .emptyField(let f):          return "\(f) cannot be empty."
        case .duplicateStudent(let id):   return "Student ID \(id) already exists."
        case .duplicateSubject(let id):   return "Subject ID \(id) already exists."
        case .studentNotFound(let id):    return "Student with ID \(id) not found."
        case .subjectNotFound(let id):    return "Subject with ID \(id) not found."
        case .invalidMark(let m):         return "Mark \(m) must be between 0 and 10."
        case .invalidCredits(let c):      return "Credits \(c) must be greater than 0."
        case .invalidAge(let a):          return "Age \(a) must be greater than 0."
        case .duplicateEnrollment(let s, let sub, let y):
            return "Student \(s) already registered for \(sub) in academic year \(y)."
        }
    }
}