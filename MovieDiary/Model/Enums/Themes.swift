//
//  ColorTheme.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

enum Themes: String, CaseIterable, Identifiable  {
    case theme1 = "Theme1 Name"
    case theme2 = "Theme2 Name"
    case theme3 = "Theme3 Name"
    
    var mainColor: Color {
        switch self {
        case .theme1: return .red
        case .theme2: return .red
        case .theme3: return .orange
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .theme1: return .blue
        case .theme2: return .orange
        case .theme3: return .secondary
        }
    }
    
    var id: Self { self }
}
