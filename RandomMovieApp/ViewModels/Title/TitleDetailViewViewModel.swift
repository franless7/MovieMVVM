//
//  TitleDetailViewViewModel.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 26.02.2024.
//

import Foundation

struct TitleDetailViewViewModel {
    let title: String
    let posterUrl: String
    let titleOverview: String
    let youtubeView: VideoElement
    let voteAverage: Double
    let genreIds: [Int]
}
