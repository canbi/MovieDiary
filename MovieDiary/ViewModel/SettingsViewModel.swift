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
    
    // Control
    var isAnythingChanged: Bool { !isThemeSame }
    var isThemeSame: Bool { selectedTheme == settingManager?.theme ?? .theme1 }
    
    // Constant
    let personalURL = URL(string: "https://canbi.me")!
    let twitterURL = URL(string: "https://twitter.com/Canbiw")!
    let githubURL = URL(string: "https://github.com/canbi")!
    
    
    init(){
        
    }
    
    func setup(_ settingManager: SettingManager) {
        self.settingManager = settingManager
        self._selectedTheme = Published(initialValue: settingManager.theme)
    }
    
    func applySettings(){
        if let settingManager = settingManager {
            settingManager.theme = selectedTheme
        }
    }
}
