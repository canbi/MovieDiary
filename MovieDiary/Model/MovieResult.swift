//
//  MovieResult.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Foundation

// MARK: - Welcome
struct MovieResult: Codable {
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type: String
    let dvd, boxOffice, production, website: String?
    let totalSeasons: String?
    let response: String
    
    var genres: [String] {
        genre.components(separatedBy: ", ")
    }
    
    var metacriticScore: String? {
        ratings.first(where: { $0.source == "Metacritic"} )?.value
    }
    
    var rottenTomatoesScore: String? {
        ratings.first(where: { $0.source == "Rotten Tomatoes"} )?.value
    }
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case totalSeasons
        case response = "Response"
    }
}

// MARK: - Rating
struct Rating: Codable {
    let source, value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
