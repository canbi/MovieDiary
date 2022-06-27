//
//  PhotoDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation
import Combine

class JSONDataService: ObservableObject {
    static var previewInstance = JSONDataService()
    
    @Published var searchResult: SearchResult!
    
    init(){
    }
    
    var searchSubscription: AnyCancellable?
}


// MARK: - Photo Functions
extension JSONDataService {
    func getSearchResult(for searchText: String,
                         type: SearchType? = nil,
                         year: Int? = nil,
                         page: Int = 1){
        let endpoint = Endpoint.search(for: searchText, type: type, year: year, page: page)
        
        guard let url = endpoint.url else { return }
        
        searchSubscription = NetworkingManager.download(url: url)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedResults) in
                guard let self = self else { return }
                self.searchResult = returnedResults
                self.searchSubscription?.cancel()
            })
    }
}
