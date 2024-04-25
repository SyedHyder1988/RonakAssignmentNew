//
//  Post.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import Foundation
// Model for your post data
struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}
