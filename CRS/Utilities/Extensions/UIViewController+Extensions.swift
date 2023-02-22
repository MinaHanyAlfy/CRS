//
//  UIViewController+Extensions.swift
//  CRS
//
//  Created by John Doe on 2022-11-26.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func alertIssues(message: String) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func alertSuccessAndDismissViewController(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { alert in
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
}
