//
//  SearchRequest.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 6.03.2024.
//

import Foundation

enum SearchEndpoint: String {
    case searchMovie
    case searchTv
}

final class SearchRequest {
    
    private let endpoint: SearchEndpoint
    
    private var query: String

    private var urlString: String {
        var baseUrlString = Constants.baseUrl
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        switch endpoint {
        case .searchMovie:
            baseUrlString += "/3/search/movie?api_key="
            baseUrlString += Constants.apiKey
            baseUrlString += "&query=\(encodedQuery ?? query)"
            return baseUrlString
        case .searchTv:
            baseUrlString += "/3/search/tv?api_key="
            baseUrlString += Constants.apiKey
            baseUrlString += "&query=\(encodedQuery ?? query)"
            return baseUrlString
        }
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(
        endpoint: SearchEndpoint,
        query: String
    ) {
        self.endpoint = endpoint
        self.query = query
    }
    
}
