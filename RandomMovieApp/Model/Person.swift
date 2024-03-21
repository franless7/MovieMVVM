//
//  Person.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 29.02.2024.
//

import Foundation

struct Person: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let known_for_department: String?
    let name: String?
    let original_name: String?
    let popularity: Double
    let profile_path: String?
 //   let known_for: [knownFor]
}

struct PersonPopularResponse: Codable {
    let results: [Person]
}

struct knownFor: Codable {
    let id: Int
    let title: String
    let original_title: String
}

