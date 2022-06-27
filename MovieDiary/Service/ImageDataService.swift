//
//  ImageDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation
import SwiftUI
import Combine

class ImageDataService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    
    private let photo: Search
    private let fileManager: LocalFileManagerImage = .instance
    private let imageName: String
    
    init(photo: Search) {
        self.photo = photo
        self.imageName = photo.imdbID
        getImage()
    }
}

// MARK: - Functions
extension ImageDataService {
    private func getImage() {
        if let savedImage = fileManager.getImage(name: imageName) {
            image = savedImage
        } else {
            downloadImage()
        }
    }
    
    private func downloadImage() {
        guard photo.poster != "N/A" else {
            self.image = UIImage(named: "no-image")
            return
        }
        guard let url = URL(string: photo.poster) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                let result = self.fileManager.saveImage(image: downloadedImage, name: self.imageName)
                print(result)
            })
    }
}
