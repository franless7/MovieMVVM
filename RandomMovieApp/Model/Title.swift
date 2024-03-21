//
//  Title.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 22.02.2024.
//

import Foundation

struct Title: Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let genreIds: [Int]
    let name: String?
    let originalTitle: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let voteCount: Int
    let releaseDate: String?
    let voteAverage: Double
    let originalLanguage: String
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case genreIds = "genre_ids"
        case name
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case originalLanguage = "original_language"
        case popularity
    }
}

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

