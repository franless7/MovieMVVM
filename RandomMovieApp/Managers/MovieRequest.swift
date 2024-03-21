//
//  RMRequest.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 25.02.2024.
//

import Foundation

final class MovieRequest {
    
    private let endPoint: MovieEndpoint
    
    public var isCheckPageNumberThree = true
    var page: Int = 1
    
    private var urlString: String {
        var string = Constants.baseUrl
    
        switch endPoint {
        case .trendingMovie:
            string += "/3/trending/movie/day?api_key="
            string += Constants.apiKey
            string += "&language=en-US&page=\(page)"
        case .trendingTv:
            string += "/3/trending/tv/day?api_key="
            string += Constants.apiKey
            string += "&language=en-US&page=\(page)"
        case .upComingMovie:
            string += "/3/movie/upcoming?api_key="
            string += Constants.apiKey
            string += "&language=en-US&page=\(page)"
        case .popularMovie:
            string += "/3/movie/popular?api_key="
            string += Constants.apiKey
            string += "&language=en-US&page=\(page)"
        case .topRated:
            string += "/3/movie/top_rated?api_key="
            string += Constants.apiKey
            string += "&language=en-US&page=\(page)"
        case .person:
            string += "/3/person/popular?api_key="
            string += Constants.apiKey
            string += "&page=\(page)"
        case .airingToday:
            string += "/3/tv/airing_today?api_key="
            string += Constants.apiKey
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(endPoint: MovieEndpoint) {
        self.endPoint = endPoint
    }
    
    public func incrementPage() {
        if page <= 3 {
            page += 1
        } else {
            isCheckPageNumberThree = false
        }
    }
}



// https://api.themoviedb.org/3/person/993784?apikey=e2253416fac0cd2476291eb33c92beb7

/// Search Movie
 // https://api.themoviedb.org/3/search/movie?api_key=697d439ac993538da4e3e60b54e762cd&query=Jason&page=1
/// Search Person
///
// https://api.themoviedb.org/3/search/person?api_key=697d439ac993538da4e3e60b54e762cd&query=jason
