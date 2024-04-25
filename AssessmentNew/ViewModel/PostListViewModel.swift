//
//  PostListViewModel.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import Foundation

// UpdateUIProtocol can be defined in your view controller or another class
protocol UpdateUIProtocol: AnyObject {
    func updateUI()
}

final class PostListViewModel {
    var currentPage: Int = 1
    var isLoading: Bool = false
    var allPosts: [Post] = [] // Accumulated fetched posts
    weak var delegate: UpdateUIProtocol? // Delegate to notify UI updates (optional)
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard !isLoading else { return } // Prevent redundant network calls
        isLoading = true
        
        ApiService.fetchPosts(page: currentPage) { result in
            self.isLoading = false
            switch result {
            case .success(let newPosts):
                self.allPosts.append(contentsOf: newPosts)
                self.currentPage += 1 // Update currentPage after successful fetch
                completion(.success(self.allPosts)) // Return accumulated data
                self.delegate?.updateUI() // Notify delegate (optional)
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
}
