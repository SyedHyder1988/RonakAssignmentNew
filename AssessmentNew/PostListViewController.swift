//
//  PostListViewController.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import UIKit

final class PostListViewController: UIViewController {
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    @IBOutlet weak private var tableView: UITableView!
    
    let viewModel = PostListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpView()
    }
}

extension PostListViewController {
    private func setUpView() {
        self.title = "Posts"
        self.tableView.rowHeight = iPad ? 50 : UITableView.automaticDimension
        self.tableView.estimatedRowHeight = iPad ? 50 : UITableView.automaticDimension
        viewModel.delegate = self // Set the delegate
        self.fetchPosts()
    }
    
    private func fetchPosts() {
        self.showAlertLoader()
        viewModel.fetchPosts { [weak self] result in
            DispatchQueue.main.async { // Call reloadData on main thread
                self?.hideAlertLoader()
            }
            switch result {
            case .success(_):
                DispatchQueue.main.async { // Call reloadData on main thread
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                // Handle errors (optional)
                DispatchQueue.main.async { // Call reloadData on main thread
                    self?.showToast(message: error.localizedDescription)
                }
            }
        }
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return iPad ? 50 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let triggerThreshold = viewModel.allPosts.count - 5 // Load next page 5 rows before the end
        if indexPath.row >= triggerThreshold && !viewModel.isLoading {
            self.fetchPosts()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.allPosts[indexPath.row]
        self.showPostDetail(post: post)
    }
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.selectionStyle = .none
        let post = viewModel.allPosts[indexPath.row]
        
        guard let postCell = cell as? PostCell else { return cell }
        
        postCell.backgroundColor = indexPath.row % 2 == 0 ? .lightGray : .white
        postCell.showPost(post: post)
        
        return cell
    }
}

extension PostListViewController: UpdateUIProtocol {
    func updateUI() {
        DispatchQueue.main.async { // Call reloadData on main thread
            self.tableView.reloadData()
        } // Reload table view to reflect new data
    }
}

extension PostListViewController {
    private func showPostDetail(post: Post) {
        let vc = PostDetailRouter.createPostDetailModule(withPost: post)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
