import SwiftUI

enum AcademicRank: String, CaseIterable, Hashable {
    case excellent = "Excellent"
    case good      = "Good"
    case average   = "Average"
    case fail      = "Fail"

    var color: Color {
        switch self {
        case .excellent: return Theme.excellent
        case .good:      return Theme.good
        case .average:   return Theme.average
        case .fail:      return Theme.fail
        }
    }

    var icon: String {
        switch self {
        case .excellent: return "star.fill"
        case .good:      return "hand.thumbsup.fill"
        case .average:   return "equal.circle.fill"
        case .fail:      return "exclamationmark.triangle.fill"
        }
    }
}
