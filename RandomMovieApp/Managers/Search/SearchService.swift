//
//  SearchManager.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 6.03.2024.
//

import Foundation

final class SearchService {
    
    static let shared = SearchService()
    
    private init() {}
    
    func execute<T: Codable>(
        _ request: SearchRequest,
        expecting type: T.Type,
        completion: @escaping (Result <T, Error>) -> Void
    ) {
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(RMServiceError.failedToDataDecode))
            }
        }
        task.resume()
    }
    
    // MARK: - Private
    
    private func request(from rmRequest: SearchRequest) -> URLRequest? {
        guard let urlRequest = rmRequest.url else {
            return nil
        }
        let request = URLRequest(url: urlRequest)
        
        return request
    }
}



