//
//  extensions.swift
//  SparkList
//
//  Created by User on 12/8/23.
//


import SwiftUI

struct AppearanceModeKey: EnvironmentKey {
    static var defaultValue: ColorScheme = .light// Default value is light mode
}

extension EnvironmentValues {
    var appearanceMode: ColorScheme {
        get { self[AppearanceModeKey.self] }
        set { self[AppearanceModeKey.self] = newValue }
    }
}
extension String {
    func removeNonNumeric() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}


extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
