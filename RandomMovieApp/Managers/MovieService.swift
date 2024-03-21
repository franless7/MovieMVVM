//
//  RMService.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 25.02.2024.
//

import Foundation

enum RMServiceError: String, Error {
    case failedToCreateRequest
    case failedToGetData
    case failedToDataDecode
}

final class MovieService {
    
    static let shared = MovieService()
    
    private init() {}

    func execute<T: Codable>(
        _ request: MovieRequest,
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
    
    private func request(from rmRequest: MovieRequest) -> URLRequest? {
        guard let urlRequest = rmRequest.url else {
            return nil
        }
        let request = URLRequest(url: urlRequest)
        
        return request
    }
    
}
