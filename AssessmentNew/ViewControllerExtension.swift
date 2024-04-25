//
//  ViewControllerExtension.swift
//  AssessmentNew
//
//  Created by Syed Hyder Zubair on 25/04/2024.
//

import Foundation
import UIKit

extension UIViewController {
    private func createAlertController(withTitle title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }
    
    func showAlertLoader(title: String? = nil, message: String = "Please wait...") {
        let alert = createAlertController(withTitle: title, message: message)
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.hidesWhenStopped = true
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        present(alert, animated: true, completion: nil)
    }
    
    func hideAlertLoader() {
        dismiss(animated: false, completion: nil)
    }
    
    func showToast(message: String, duration: TimeInterval = 4.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let dispatchTime = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            alert.dismiss(animated: true, completion: nil)
        }
        present(alert, animated: true, completion: nil)
    }
}
