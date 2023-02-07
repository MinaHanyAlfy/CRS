//
//  AuthenticationViewController.swift
//  CRS
//
//  Created by John Doe on 2022-11-25.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var companies: [String] = ["DEMO","OPI","EMA","PROVAK"]
    private var companyName: String = "demo"
    private var callResponse: String?{
        didSet{
            DispatchQueue.main.async {
                guard let callResponse = self.callResponse else { return }
                if callResponse == "verified" {
                    
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    self.alertIssues(message: "Please, recheck your data.")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    } 
    
    @IBAction func loginAction(_ sender: Any) {
        guard let password = passwordTextField.text else { return }
        print(companyName, password)
        self.callResponse = "verified"
    }
    
}

//MARK: - UIPickerViewDelegate
extension AuthenticationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return companies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected")
        companyName = companies[row].lowercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: companies[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
}

//MARK: - UIPickerViewDataSource
extension AuthenticationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.count
    }
}

//MARK: - UITextFieldDelegate
extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == self.passwordTextField {
               textField.endEditing(true)
           }
       }
}
