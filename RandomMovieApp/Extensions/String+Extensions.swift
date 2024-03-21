//
//  String+Extensions.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 8.03.2024.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    static func formattedVoteAverage(voteAverage: Double) -> String {
        let formattedVoteAverage = String(format: "%.1f", voteAverage)
        return "IMDB \(formattedVoteAverage)"
    }
}


    
    

