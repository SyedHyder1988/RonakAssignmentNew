//
//  PostDetailRouter.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import Foundation
import UIKit

final class PostDetailRouter {
    class func createPostDetailModule(withPost post: Post) -> UIViewController {
        let vcId = "PostDetailViewController"
        guard let vC = storyboard.instantiateViewController(identifier: vcId) as? PostDetailViewController else {
            return UIViewController()
        }
        vC.post = post
        return vC
    }
    
    class private var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: .main)
    }
}
