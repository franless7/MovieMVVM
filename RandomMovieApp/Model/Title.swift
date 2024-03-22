//
//  Title.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 22.02.2024.
//

import Foundation

struct Title: Codable {
    let id: Int
    let originalName: String?
    let genreIds: [Int]
    let name: String?
    let originalTitle: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case genreIds = "genre_ids"
        case name
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

