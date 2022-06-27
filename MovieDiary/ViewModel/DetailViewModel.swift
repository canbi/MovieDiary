//
//  DetailViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Combine
import SwiftUI

class DetailViewModel: ObservableObject {
    let movie: Search
    private let fileManager: LocalFileManagerImage = .instance
    
    // Data
    private var dataService: JSONDataService!
    @Published var movieInfo: MovieResult? = nil
    private var cancellables = Set<AnyCancellable>()
    
    // Control
    @Published var clickedImage: UIImage? = nil
    @Published var showingZoomImageView: Bool = false
    
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
    
    func getImage() -> UIImage? {
        return fileManager.getImage(name: String(movie.imdbID))
    }
}
