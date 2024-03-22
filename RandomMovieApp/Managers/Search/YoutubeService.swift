//
//  YoutubeService.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 13.03.2024.
//

import Foundation

final class YoutubeService {
    
    static let shared = YoutubeService()
    
    private init() {}
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youtubeBaseUrl)q=\(query)&key=\(Constants.youtubeApiKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(results.items[0]))
                }
              
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
