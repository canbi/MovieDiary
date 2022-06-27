//
//  MovieDiaryApp.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

@main
struct MovieDiaryApp: App {
    let dataService: JSONDataService = JSONDataService()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataService)
        }
    }
}
