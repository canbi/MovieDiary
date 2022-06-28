//
//  GridDesign.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 26.06.2022.
//

import Foundation

enum GridDesign: String, CaseIterable, Identifiable {
    case oneColumn = "One Column"
    case twoColumn = "Two Column"
    
    var iconName: String {
        switch self {
        case .oneColumn: return "rectangle.grid.1x2"
        case .twoColumn: return "rectangle.grid.2x2"
        }
    }
    
    var id: Self { self }
}
