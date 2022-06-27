//
//  MainViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Combine
import Foundation

class MainViewModel: ObservableObject {
    // Data
    private var dataService: JSONDataService!
    @Published var searchResults: SearchResult? = nil
    private var cancellables = Set<AnyCancellable>()
    
    // Control
    @Published var showingSettingsViewSheet: Bool = false
    
    
    init(){  
    }
    
    func setup(dataService: JSONDataService){
        self.dataService = dataService
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$searchResult
            .sink { [weak self] (returnedResults) in
                self?.searchResults = returnedResults
            }
            .store(in: &cancellables)
    }
}
