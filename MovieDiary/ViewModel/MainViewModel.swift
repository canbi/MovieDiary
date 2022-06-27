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
    @Published var selectedMovie: Search? = nil
    @Published var searchText = ""
    @Published var searching = false
    
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
        
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] (returnedResults) in
                self?.dataService.getSearchResult(for: returnedResults)
            }
            .store(in: &cancellables)
    }
}
