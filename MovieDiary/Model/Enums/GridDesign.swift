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
    
    var id: Self { self }
}
