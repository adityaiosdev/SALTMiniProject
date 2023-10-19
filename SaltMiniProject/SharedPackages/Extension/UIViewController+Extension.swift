//
//  UIViewController+Extension.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
