//
//  ColorTheme.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

enum Themes: String, CaseIterable, Identifiable  {
    case theme1 = "Sublime Light Theme 1"
    case theme2 = "Sublime Light Theme 2"
    case theme3 = "Blue Theme"
    case theme4 = "Red Theme"
    
    
    var mainColor: Color {
        switch self {
        case .theme1: return Color(red: 0.99, green: 0.36, blue: 0.49)
        case .theme2: return Color(red: 0.42, green: 0.51, blue: 0.98)
        case .theme3: return .blue
        case .theme4: return .red
        }
    }
    
    var id: Self { self }
}
