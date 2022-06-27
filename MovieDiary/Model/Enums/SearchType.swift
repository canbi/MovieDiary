//
//  SearchType.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Foundation

enum SearchType: String, Codable, CaseIterable, Identifiable {
    case all = ""
    case game = "game"
    case episodes = "episode"
    case movie = "movie"
    case series = "series"
    
    var name: String {
        switch self {
        case .all: return "All types"
        case .movie: return "Movie"
        case .series: return "Series"
        case .episodes: return "Episodes"
        case .game: return "Game"
        }
    }
    
    var id: Self { self }
}
