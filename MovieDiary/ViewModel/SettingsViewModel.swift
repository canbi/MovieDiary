//
//  SettingsViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Foundation

class SettingsViewModel: ObservableObject {
    var settingManager: SettingManager?
    
    // Settings
    @Published var selectedTheme: Themes = .theme1
    @Published var selectedGrid: GridDesign = .oneColumn
    
    // Control
    var isAnythingChanged: Bool { !isThemeSame || !isSameGrid }
    var isThemeSame: Bool { selectedTheme == settingManager?.theme ?? .theme1 }
    var isSameGrid: Bool { selectedGrid == settingManager?.gridDesign ?? .oneColumn }
    
    // Constant
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    let apiURL = URL(string: "https://www.omdbapi.com")!
    
    
    init(){
        
    }
    
    func setup(_ settingManager: SettingManager) {
        self.settingManager = settingManager
        self._selectedTheme = Published(initialValue: settingManager.theme)
        self._selectedGrid = Published(initialValue: settingManager.gridDesign)
    }
    
    func applySettings(){
        if let settingManager = settingManager {
            settingManager.theme = selectedTheme
            settingManager.gridDesign = selectedGrid
        }
    }
}
