//
//  DetailViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
    let movie: Search
    
    // Data
    private var dataService: JSONDataService!
    @Published var movieInfo: MovieResult? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(movie: Search){
        self.movie = movie
    }
    
    func setup(dataService: JSONDataService){
        self.dataService = dataService
        addSubscribers()
        dataService.getMovieInfo(for: movie.imdbID, plot: "full")
    }
    
    func addSubscribers() {
        dataService.$movieInfo
            .sink { [weak self] (returnedMovieInfo) in
                self?.movieInfo = returnedMovieInfo
            }
            .store(in: &cancellables)
    }
}
