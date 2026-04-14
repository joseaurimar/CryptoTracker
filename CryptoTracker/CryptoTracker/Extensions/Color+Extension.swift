//
//  Color+Extension.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 25/03/26.
//

import SwiftUI

extension Color {
    static let theme = ThemeColor()
}

struct ThemeColor {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("PositiveValueColor")
    let red = Color("NegativeValueColor")
    let secondaryText = Color("SecondaryTextColor")
}
