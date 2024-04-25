//
//  PostCell.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import Foundation
import UIKit

final class PostCell: UITableViewCell {
    @IBOutlet weak private var idLbl:UILabel!
    @IBOutlet weak private var titleLbl: UILabel!
    
    func showPost(post: Post) {
        self.idLbl.text = post.id.description
        self.titleLbl.text = post.title
    }
}
