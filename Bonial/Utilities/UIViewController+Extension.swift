//
//  UIViewController+Extension.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import UIKit

extension UIViewController {
    
    typealias alertAction = (title: String, handler: ((UIAlertAction) -> Void)?)
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   style: UIAlertController.Style = .alert,
                   action1: alertAction? = nil,
                   action2: alertAction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if let action = action1 {
            let okAction = UIAlertAction(title: action.title, style: .default, handler: action.handler)
            alert.addAction(okAction)
        }
        if let action = action2 {
            let cancelAction = UIAlertAction(title: action.title, style: .default, handler: action.handler)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true)
    }
    
}
