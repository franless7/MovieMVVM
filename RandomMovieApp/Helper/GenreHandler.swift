//
//  GenreHandler.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 19.03.2024.
//

import Foundation

class GenreHandler {
    
    static let shared = GenreHandler()
    
    private let genreCode = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]
    
     public func genreNames(for ids: [Int]) -> [String] {
        var names = [String]()
        for id in ids {
            if let name = genreCode[id] {
                names.append(name)
            }
        }
        return names
    }
}
