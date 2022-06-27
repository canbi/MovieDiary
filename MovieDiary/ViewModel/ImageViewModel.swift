//
//  ImageViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Combine
import SwiftUI
import UIKit

class ImageViewModel: ObservableObject {
    private let photo: Search
    
    // Control
    @Published var isLoading: Bool = false
    
    // Data
    @Published var image: UIImage? = nil
    private let imageDataService: ImageDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Search){
        self.photo = photo
        self.imageDataService = ImageDataService(photo: photo)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        imageDataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
