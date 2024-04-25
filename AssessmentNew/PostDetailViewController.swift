//
//  PostDetailViewController.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import UIKit

final class PostDetailViewController: UIViewController {
    var post: Post?
    @IBOutlet weak private var postIdLbl: UILabel!
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var bodyLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let post = self.post else { return }
        self.postIdLbl.text = post.id.description
        self.titleLbl.text = post.title
        self.bodyLbl.text = post.body
    }
}
