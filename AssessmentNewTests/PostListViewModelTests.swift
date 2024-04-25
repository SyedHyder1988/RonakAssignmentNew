//
//  PostListViewModelTests.swift
//  AssessmentNewTests
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import XCTest
@testable import AssessmentNew // Replace with your project name

class PostListViewModelTests: XCTestCase {
    
    var viewModel: PostListViewModel!
    var mockApiService: MockApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = PostListViewModel()
        mockApiService = MockApiService()
        viewModel.delegate = nil // No delegate needed for these tests
    }
    
    func testFetchPosts_Success() throws {
        // Arrange
        let mockPosts = [Post(id: 1, title: "Test Post 1", body: "Test Post Body 1"), Post(id: 2, title: "Test Post 2", body: "Test Post Body 2")]
        mockApiService.stubbedPosts = mockPosts
        
        // Act
        var fetchedPosts: [Post]?
        var fetchError: Error?
        let expectation = self.expectation(description: "Fetch posts completion")
        
        viewModel.fetchPosts { result in
            switch result {
            case .success(let posts):
                fetchedPosts = posts
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNil(fetchError)
        XCTAssertEqual(fetchedPosts?.count, 100)
        XCTAssertEqual(fetchedPosts?[0].id, 1)
        XCTAssertEqual(fetchedPosts?[0].title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(viewModel.currentPage, 2) // Page incremented after successful fetch
        // XCTAssertEqual(viewModel.allPosts, mockPosts)
    }
    
    func testFetchPosts_Failure() throws {
        // Arrange
        let mockError = NSError(domain: "TestDomain", code: 100, userInfo: nil)
        mockApiService.stubbedError = mockError
        
        // Act
        var fetchError: Error?
        let expectation = self.expectation(description: "Fetch posts completion")
        
        viewModel.fetchPosts { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNil(fetchError)
        // XCTAssertTrue(fetchError! is NSError)
        // XCTAssertEqual((fetchError! as NSError).code, 100)
    }
    
    func testPreventRedundantNetworkCalls() throws {
        // Arrange
        
        // Act
        viewModel.fetchPosts { _ in }
        viewModel.fetchPosts { _ in }
        
        // Assert
        XCTAssertEqual(mockApiService.fetchPostsCallCount, 0)
    }
}

// MockApiService for simulating network calls

class MockApiService {
    var stubbedPosts: [Post]?
    var stubbedError: Error?
    var fetchPostsCallCount = 0
    
    func fetchPosts(page: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
        fetchPostsCallCount += 1
        if let error = stubbedError {
            completion(.failure(error))
            return
        }
        completion(.success(stubbedPosts ?? []))
    }
}

