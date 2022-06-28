//
//  CoreDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//


import SwiftUI
import CoreData

class CoreDataDataService: ObservableObject {
    var moc: NSManagedObjectContext
    private var favorites: [CDMovie]
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        
        do {
            self.favorites = try self.moc.fetch(fetchRequest) as [CDMovie]
        } catch let error {
            print("error FetchRequest curiosity \(error)")
            self.favorites = []
        }
    }
    
    func saveMOC() {
        if self.moc.hasChanges {
            try? self.moc.save()
            
            favorites = getFavorites()
        }
    }
}

// MARK: - Photo Functions
extension CoreDataDataService {
    func getFavorites() -> [CDMovie] {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        
        var returnedMovies: [CDMovie] = []
        
        do {
            returnedMovies = try self.moc.fetch(fetchRequest) as [CDMovie]
        } catch let error {
            print("error FetchRequest spirit \(error)")
            returnedMovies = []
        }
        
        return returnedMovies
    }
    
    func saveMovie(movie: MovieResult) -> CDMovie {
        let newMovie = CDMovie(context: self.moc)
        newMovie.addFavoritesDate = .now
        newMovie.imdbId = movie.imdbID
        newMovie.imdbRating = movie.imdbRating
        newMovie.imdbVotes = movie.imdbVotes
        newMovie.metacriticScore = movie.metacriticScore
        newMovie.rottenScore = movie.rottenTomatoesScore
        newMovie.title = movie.title
        newMovie.year = movie.year
        newMovie.rated = movie.rated
        newMovie.released = movie.released
        newMovie.runtime = movie.runtime
        newMovie.genre = movie.genre
        newMovie.director = movie.director
        newMovie.writer = movie.writer
        newMovie.actors = movie.actors
        newMovie.plot = movie.plot
        newMovie.language = movie.language
        newMovie.country = movie.country
        newMovie.awards = movie.awards
        newMovie.poster = movie.poster
        newMovie.type = movie.type
        newMovie.dvd = movie.dvd
        newMovie.boxOffice = movie.boxOffice
        newMovie.production = movie.production
        newMovie.website = movie.website
        newMovie.totalSeasons = movie.totalSeasons
        
        saveMOC()
        print("saved in coredata")
        return newMovie
    }
    
    func deleteMovie(movie: CDMovie){
        self.moc.delete(movie)
        print("remove from coredata")
        saveMOC()
    }
    
    func getMovie(imdbId: String) -> CDMovie? {
        favorites.first(where: { $0.imdbId == imdbId })
    }
    
    func isFavorited(imdbId: String) -> Bool {
        return getMovie(imdbId: imdbId) != nil
    }
}
