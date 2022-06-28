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
    var networkMonitor: NetworkMonitor? = nil
    
    // Data
    private var dataService: JSONDataService!
    @Published var searchResults: SearchResult? = nil
    private var cancellables = Set<AnyCancellable>()
    var networkSubscription: AnyCancellable?
    
    // CoreData
    var coreDataService: CoreDataDataService!
    @Published var favoriteMovies: [CDMovie] = []
    @Published var filteredFavoriteMovies: [CDMovie] = []
    
    // Control
    @Published var showingSettingsViewSheet: Bool = false
    @Published var showingFilterViewSheet: Bool = false
    @Published var showingOnlyFavorites:  Bool = false
    @Published var selectedMovie: Search? = nil
    @Published var selectedOfflineMovie: CDMovie? = nil
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
    var initialState: Bool { searchResults == nil && !isPageLoading && !showingOnlyFavorites }
    private var notFoundOnlineState: Bool { searchResults?.search?.isEmpty ?? true && !isPageLoading}
    private var notFoundOfflineState: Bool { filteredFavoriteMovies.isEmpty && !searchText.isEmpty }
    var notFoundState: Bool {
        if showingOnlyFavorites {
            return notFoundOfflineState
        }
        return notFoundOnlineState
    }
    var noFavoritesState: Bool {showingOnlyFavorites && filteredFavoriteMovies.isEmpty && searchText.isEmpty }
    var showDummyCellsState: Bool {
        if showingOnlyFavorites {
            return filteredFavoriteMovies.isEmpty
        }
        
        return searchResults == nil || isPageLoading
    }
    var showPageNumberState: Bool { searchResults != nil && !(searchResults?.search?.isEmpty ?? true) && !showingOnlyFavorites }
    
    init(){
    }
    
    func setup(dataService: JSONDataService, cdDataService: CoreDataDataService, networkMonitor: NetworkMonitor){
        self.dataService = dataService
        self.networkMonitor = networkMonitor
        self.coreDataService = cdDataService
        self.showingOnlyFavorites = true
        addSubscribers()
        
        // Core Data Favorites
        self.favoriteMovies = coreDataService.getFavorites()
        self.filteredFavoriteMovies = favoriteMovies
    }
    
    func addSubscribers() {
        networkSubscription = networkMonitor?.$isConnected
            .sink { [weak self] (isConnected) in
                guard let self = self else { return }
                if isConnected {
                    self.showingOnlyFavorites = false
                    self.networkMonitor!.stopMonitoring()
                    self.networkSubscription?.cancel()
                }
            }
        
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
                if self.showingOnlyFavorites {
                    self.updateFilteredFavorites(returnedSearchText: returnedResults, type: self.searchType, year: self.searchYear)
                } else {
                    self.dataService.getSearchResult(for: returnedResults, type: self.searchType, year: self.searchYear)
                }
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
                if self.showingOnlyFavorites {
                    self.updateFilteredFavorites(returnedSearchText: self.searchText, type: returnedSearchType, year: self.searchYear)
                } else {
                    self.dataService.getSearchResult(for: self.searchText, type: returnedSearchType, year: self.searchYear)
                }
            }
            .store(in: &cancellables)
        
        $searchYear
            .sink { [weak self] (returnedSearchYear) in
                guard let self = self else { return }
                if self.showingOnlyFavorites {
                    self.updateFilteredFavorites(returnedSearchText: self.searchText, type: self.searchType, year: returnedSearchYear)
                } else {
                    self.dataService.getSearchResult(for: self.searchText, type: self.searchType, year: returnedSearchYear)
                }
            }
            .store(in: &cancellables)
    }
    
    func changePage(to number:Int){
        isPageLoading = true
        currentPageNumber = number
        scrollViewProxy.scrollTo("top", anchor: .top)
    }
    
    func updateFavorites(){
        self.favoriteMovies = self.coreDataService.getFavorites()
    }
    
    private func updateFilteredFavorites(returnedSearchText: String, type: SearchType, year: Int?){
        let searchText = returnedSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        self.filteredFavoriteMovies = self.filterFavorites(title: searchText, type: type, year: year)
    }
    
    private func filterFavorites(title: String, type: SearchType, year: Int?) -> [CDMovie] {
        let lowercasedText = title.lowercased()
        
        return favoriteMovies.filter { (movie) -> Bool in
            let searchTextBool = movie.title!.lowercased().contains(lowercasedText) ||
                                    movie.plot!.lowercased().contains(lowercasedText) ||
                                    title.isEmpty
            let typeBool = type == .all || movie.type! == type.rawValue
            let yearBool = year == nil ||  movie.year! == String(year ?? 1)
            
            return searchTextBool && typeBool && yearBool
        }
    }
}
