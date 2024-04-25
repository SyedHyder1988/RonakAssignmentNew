//
//  ApiService.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError
    case decodingError(error: Error)
}

final class ApiService {
    static let baseURL = "https://jsonplaceholder.typicode.com"
}

extension ApiService {
    static func fetchPosts(page: Int, completion: @escaping (Result<[Post], APIError>) -> Void) {
        guard let url = URL(string: baseURL + "/posts?page=\(page)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        print(url.absoluteString)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError))
                print(error.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.networkError))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error: error)))
                print("an error in catch")
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}
