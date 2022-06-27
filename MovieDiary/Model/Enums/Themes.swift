//
//  ColorTheme.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

enum Themes: String, CaseIterable, Identifiable  {
    case theme1 = "Blue Theme"
    case theme2 = "Red Theme"
    case theme3 = "Green Theme"
    case theme4 = "Orange Theme"
    
    var mainColor: Color {
        switch self {
        case .theme1: return .blue
        case .theme2: return .red
        case .theme3: return .green
        case .theme4: return .orange
        }
    }
    
    var id: Self { self }
}
