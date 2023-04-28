//
//  AddKeyPersonViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-29.
//

import UIKit
import DropDown

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
    var accountId: String?
    let dropDown = DropDown()
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
        self.hideKeyboardWhenTappedAround()
        keyPersons = CoreDataManager.shared.getKeys()
        
        var keys = keyPersons.filter { $0.accountID == accountId }
        dropDown.anchorView = view
        dropDown.direction = .bottom
        dropDown.width = 200
        DropDown.startListeningToKeyboard()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            keyPersonNameTextField.text = item
            keyPerson = keys[index]
        }

        dropDown.dataSource = keys.map({ $0.keyPersonName ?? "" })
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
            print("comment Decoded: ", comment.toBase64())
            delegate?.addKeyPersonObject(keyPerson: keyPerson, comment: comment)
            self.dismiss(animated: true, completion: nil)
        } else {
            if ( keyPersonNameTextField.text != nil && keyPersonNameTextField.text != "" ) &&
                ( phoneTextField.text != nil && phoneTextField.text != "" ) &&
                ( specTextField.text != nil && specTextField.text != "" ) {
                let keyPersonName = keyPersonNameTextField.text
                let keyPersonSpec = specTextField.text
                let keyPersonPhone = phoneTextField.text
                let comment = commentTextField.text ?? ""
                let keyPerson = Key(keyPersonID: "", keyPersonName: keyPersonName, specialityName: keyPersonSpec, mobile: keyPersonPhone, accountID: "")
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
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown.show()
    }
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
