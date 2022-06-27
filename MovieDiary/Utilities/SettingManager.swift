//
//  SettingManager.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

class SettingManager: ObservableObject {
    static var previewInstance = SettingManager()
    private let defaults = UserDefaults.standard
    
    var theme: Themes {
        didSet {
            defaults.set(theme.rawValue, forKey: SettingManager.themeKey)
        }
    }
    
    
    @Published var gridDesign: GridDesign = .oneColumn {
        didSet {
            defaults.set(gridDesign.rawValue, forKey: SettingManager.gridDesignKey)
        }
    }
    
    init(){
        self.theme = Themes(rawValue: (defaults.string(forKey: SettingManager.themeKey) ?? "")) ?? .theme1
        
        self._gridDesign = Published(initialValue: GridDesign(rawValue: (defaults.string(forKey: SettingManager.gridDesignKey) ?? "")) ?? .oneColumn)
    }
}

// MARK: Functions
extension SettingManager {
    
    func changeGrid(){
        gridDesign = gridDesign == .oneColumn ? .twoColumn : .oneColumn
    }
}

// MARK: Keys
extension SettingManager {
    static private let themeKey: String = "themeKey"
    static private let gridDesignKey: String = "gridDesignKey"
}
