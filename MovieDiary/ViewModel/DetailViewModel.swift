//
//  DetailViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Combine
import SwiftUI

class DetailViewModel: ObservableObject {
    let movie: Search?
    let cdMovie: CDMovie?
    var mainVM: MainViewModel
    
    // Utility
    private let fileManager: LocalFileManagerImage = .instance
    private let fileManagerForFavorites: LocalFileManagerImage = LocalFileManagerImage(folderName: "favorites",
                                                                                       appFolder: .documentDirectory)
    
    // Data
    private var dataService: JSONDataService!
    @Published var movieInfo: MovieResult? = nil
    private var cancellables = Set<AnyCancellable>()
    
    // Core Data
    var coreDataService: CoreDataDataService!
    var coreDataObject: CDMovie?
    
    // Control
    @Published var clickedImage: UIImage? = nil
    @Published var showingZoomImageView: Bool = false
    @Published var isFavorited = false
    
    init(movie: Search?, cdMovie: CDMovie?, mainVM: MainViewModel){
        self.movie = movie
        self.cdMovie = cdMovie
        self.mainVM = mainVM
    }
}

// MARK: Setup Functions
extension DetailViewModel {
    func setup(dataService: JSONDataService, coreDataService: CoreDataDataService){
        self.dataService = dataService
        self.coreDataService = coreDataService
        
        if let movie = movie {
            addSubscribers()
            dataService.getMovieInfo(for: movie.imdbID, plot: "full")
            self.coreDataObject = coreDataService.getMovie(imdbId: movie.imdbID)
        } else {
            self.coreDataObject = cdMovie
        }
        
        self.isFavorited = self.coreDataObject != nil
    }
    
    func addSubscribers() {
        dataService.$movieInfo
            .sink { [weak self] (returnedMovieInfo) in
                self?.movieInfo = returnedMovieInfo
            }
            .store(in: &cancellables)
    }
}

// MARK: Image Functions
extension DetailViewModel {
    func getImage() -> UIImage? {
        if let movie = movie {
            return fileManager.getImage(name: String(movie.imdbID))
        } else {
            if let imdbId = cdMovie!.imdbId {
                return fileManagerForFavorites.getImage(name: imdbId)
            }
        }
        
        return nil
    }
    
    func zoomImage() {
        clickedImage = getImage()
        showingZoomImageView = true
    }
}

// MARK: Favorites
extension DetailViewModel {
    func favoriteButton(dismissAction: @escaping () -> Void){
        if isFavorited {
            removeFavorite(dismissAction: dismissAction)
        } else {
            setFavorite()
        }
        mainVM.updateFavorites()
    }
    
    func setFavorite(){
        if let movie = movie, let movieInfo = movieInfo {
            self.coreDataObject =  coreDataService.saveMovie(movie: movieInfo)
            isFavorited.toggle()
            
            saveForOffline(movie: movie)
        }
    }
    
    func removeFavorite(dismissAction: @escaping () -> Void){
        if let movie = movie {
            if let coreDataObject = coreDataObject {
                coreDataService.deleteMovie(movie: coreDataObject)
                isFavorited.toggle()
            }
            
            let result = fileManagerForFavorites.deleteItem(name: movie.imdbID, type: fileManagerForFavorites.type)
            print("\(result) + photo deleting from directory")
        } else {
            coreDataService.deleteMovie(movie: coreDataObject!)
            isFavorited.toggle()
            dismissAction()
        }
    }
    
    func saveForOffline(movie: Search){
        let uiimage = getImage()
        if let uiimage = uiimage {
            let result = fileManagerForFavorites.saveImage(image: uiimage, name: movie.imdbID, compressionQuality: 0.8)
            print("\(result) + manual photo saving")
        }
    }
}
