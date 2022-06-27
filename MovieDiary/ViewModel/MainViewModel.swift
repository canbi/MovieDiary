//
//  MainViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    var scrollViewProxy: ScrollViewProxy!
    
    // Data
    private var dataService: JSONDataService!
    @Published var searchResults: SearchResult? = nil
    private var cancellables = Set<AnyCancellable>()
    
    // Control
    @Published var showingSettingsViewSheet: Bool = false
    @Published var showingFilterViewSheet: Bool = false
    @Published var showingOnlyFavorites:  Bool = false
    @Published var selectedMovie: Search? = nil
    @Published var searchText = ""
    @Published var searching = false {
        didSet {
            isPageLoading = true
        }
    }
    @Published var currentPageNumber: Int = 1
    @Published var isPageLoading = false
    
    // Filters
    @Published var searchType: SearchType = .all
    @Published var searchYear: Int? = nil
    
    var maxPageNumber: Int { Int(ceil(Double(searchResults?.totalResults ?? "10.0")! / 10.0)) }
    var initialState: Bool { searchResults == nil && !isPageLoading }
    var notFoundState: Bool { searchResults?.search?.isEmpty ?? true  && !isPageLoading }
    var justStartedSearchingState: Bool { searchResults == nil || isPageLoading }
    
    
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
                self?.isPageLoading = false
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] (returnedResults) in
                guard let self = self else { return }
                self.dataService.getSearchResult(for: returnedResults, type: self.searchType, year: self.searchYear)
            }
            .store(in: &cancellables)
        
        $currentPageNumber
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] (returnedPageNumber) in
                guard let self = self else { return }
                self.dataService.getSearchResult(for: self.searchText, type: self.searchType, year: self.searchYear, page: returnedPageNumber)
            }
            .store(in: &cancellables)
        
        $searchType
            .sink { [weak self] (returnedSearchType) in
                guard let self = self else { return }
                self.dataService.getSearchResult(for: self.searchText, type: returnedSearchType, year: self.searchYear)
            }
            .store(in: &cancellables)
        
        $searchYear
            .sink { [weak self] (returnedSearchYear) in
                guard let self = self else { return }
                self.dataService.getSearchResult(for: self.searchText, type: self.searchType, year: returnedSearchYear)
            }
            .store(in: &cancellables)
    }
    
    func changePage(to number:Int){
        isPageLoading = true
        currentPageNumber = number
        scrollViewProxy.scrollTo("top", anchor: .top)
    }
}
