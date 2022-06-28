//
//  CDMovie+CoreDataProperties.swift
//  MovieDiary
//
//  Created by Can Bi on 28.06.2022.
//
//

import Foundation
import CoreData


extension CDMovie {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMovie> {
        return NSFetchRequest<CDMovie>(entityName: "CDMovie")
    }
    
    @NSManaged public var addFavoritesDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var released: String?
    @NSManaged public var runtime: String?
    @NSManaged public var genre: String?
    @NSManaged public var director: String?
    @NSManaged public var actors: String?
    @NSManaged public var writer: String?
    @NSManaged public var plot: String?
    @NSManaged public var language: String?
    @NSManaged public var country: String?
    @NSManaged public var awards: String?
    @NSManaged public var rated: String?
    @NSManaged public var poster: String?
    @NSManaged public var imdbRating: String?
    @NSManaged public var imdbVotes: String?
    @NSManaged public var imdbId: String?
    @NSManaged public var type: String?
    @NSManaged public var boxOffice: String?
    @NSManaged public var production: String?
    @NSManaged public var website: String?
    @NSManaged public var totalSeasons: String?
    @NSManaged public var dvd: String?
    @NSManaged public var metacriticScore: String?
    @NSManaged public var rottenScore: String?
    
    var wrappedId: String { imdbId ?? UUID().uuidString }
    
    var genres: [String]? {
        if let genre = genre {
            return genre.components(separatedBy: ", ")
        }
        return nil
    }
    
}

extension CDMovie : Identifiable {
    
}
