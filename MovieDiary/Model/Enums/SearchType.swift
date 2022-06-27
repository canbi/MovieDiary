//
//  SearchType.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Foundation

enum SearchType: String, Codable {
    case movie = "movie"
    case series = "series"
    case episodes = "episode"
    case game = "game"
    
    var name: String {
        switch self {
        case .movie: return "Movie"
        case .series: return "Series"
        case .episodes: return "Episodes"
        case .game: return "Game"
        }
    }
}
