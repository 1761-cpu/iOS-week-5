//
//  Theme.swift
//  PracticeTest1
//
//  Created by MAY 04 on 19/10/26.
//


import SwiftUI

// MARK: - HEX → Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - App Theme
enum Theme {
    // Tab colors
    static let students = Color(hex: "#8B8000")   // dark olive  – Students tab
    static let subjects = Color(hex: "#6E260E")   // dark brown  – Subjects tab
    static let ranking  = Color(hex: "#4C2942")   // purple      – Ranking tab

    // Academic rank colors
    static let excellent = Color(hex: "#16A34A")  // green
    static let good      = Color(hex: "#2563EB")  // blue
    static let average   = Color(hex: "#EA580C")  // orange
    static let fail      = Color(hex: "#DC2626")  // red

    // Semantic
    static let passed   = Color(hex: "#059669")   // emerald  – PASSED badge
    static let danger   = Color(hex: "#DC2626")   // red      – FAILED badge
    static let gold     = Color(hex: "#FFBF00")   // amber    – stars / highlights
    static let marks    = Color(hex: "#CD7F32")   // copper   – mark label

    // Surfaces
    static let cardFill    = Color.white.opacity(0.95)
    static let tintBackdrop = Color(hex: "#F2F2F7") // systemGroupedBackground
}