//
//  ImageOfflineViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

class ImageOfflineViewModel: ObservableObject {
    private let movie: CDMovie
    
    // Control
    @Published var isLoading: Bool = false
    
    // Data
    @Published var image: UIImage? = nil
    
    //Utility
    private let fileManagerForFavorites: LocalFileManagerImage = LocalFileManagerImage(folderName: "favorites",
                                                                                       appFolder: .documentDirectory)
    
    init(movie: CDMovie){
        self.movie = movie
        self.isLoading = true
        self.loadImage()
    }
    
    private func loadImage(){
        if let imdbId = movie.imdbId {
            self.image = fileManagerForFavorites.getImage(name: imdbId)
            self.isLoading = false
        }
    }
}
