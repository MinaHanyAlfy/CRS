//
//  AddKeyPersonViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-29.
//

import UIKit

protocol AddKeyPersonViewrDelegate: AnyObject {
    func addKeyPersonObject(keyPerson: Key,comment: String)
}
class AddKeyPersonViewController: UIViewController {
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var specTextField: UITextField!
    @IBOutlet weak var keyPersonNameTextField: UITextField!
    @IBOutlet weak var keyPersonView: UIView!
    
    public weak var delegate: AddKeyPersonViewrDelegate?
    private var keyPersons: Keys = []
    private var keyPerson: Key?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let keyPerson = keyPerson else { return }
                handleKeyPersonView(keyPerson: keyPerson)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        keyPersonNameTextField.delegate = self
        handleViewController()
        keyPersons = CoreDataManager.shared.getKeys()
    }
    
    private func handleViewController() {
        keyPersonView.clipsToBounds = true
        keyPersonView.layer.cornerRadius = 8
        noButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        yesButton.addTarget(self, action: #selector(addPharmacyAction), for: .touchUpInside)
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
    @objc private func addPharmacyAction() {
        
        if let keyPerson = keyPerson {
            let comment = commentTextField.text ?? ""
            delegate?.addKeyPersonObject(keyPerson: keyPerson, comment: comment)
            self.dismiss(animated: true, completion: nil)
        } else {
            if ( keyPersonNameTextField.text != nil && keyPersonNameTextField.text != "" ) &&
                ( phoneTextField.text != nil && phoneTextField.text != "" ) &&
                ( specTextField.text != nil && specTextField.text != "" ) {
                let keyPerson = Key(keyPersonID: "", keyPersonName: keyPersonNameTextField.text, specialityName: specTextField.text, mobile: phoneTextField.text, accountID: "")
                let comment = commentTextField.text ?? ""
                delegate?.addKeyPersonObject(keyPerson: keyPerson, comment: comment)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func handleKeyPersonView(keyPerson: Key) {
        keyPersonNameTextField.text = keyPerson.keyPersonName
        phoneTextField.text = keyPerson.mobile
        specTextField.text = keyPerson.specialityName
    }


}



//MARK: - UITextFieldDelegate
extension AddKeyPersonViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !autoCompleteText( in : textField, using: string, suggestionsArray: keyPersons)
    }
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: Keys) -> Bool {
        if !string.isEmpty,
           let selectedTextRange = textField.selectedTextRange,
           selectedTextRange.end == textField.endOfDocument,
           let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
           let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestionsArray.filter {
                $0.keyPersonName!.hasPrefix(prefix)
            }
            if (matches.count > 0) {
                textField.text = matches[0].keyPersonName
                keyPerson = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
