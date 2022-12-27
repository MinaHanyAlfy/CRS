//
//  AddPharmacyViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-26.
//

import UIKit



protocol AddPharmacyViewDelegate: AnyObject {
    func addPharmacyObject(pharmacy: Pharmacy,comment: String)
}
class AddPharmacyViewController: UIViewController {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var specTextField: UITextField!
    @IBOutlet weak var pharmacyNameTextField: UITextField!
    @IBOutlet weak var pharmacyView: UIView!
    
    public weak var delegate: AddPharmacyViewDelegate?
    private var pharmacies: Pharmacies = []
    private var pharmacy: Pharmacy?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let pharmacy = pharmacy else { return }
                handlePharmacyView(pharmacy: pharmacy)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pharmacyNameTextField.delegate = self
        handleViewController()
        pharmacies = CoreDataManager.shared.getPharmacy()
    }
    
    private func handleViewController() {
        pharmacyView.clipsToBounds = true
        pharmacyView.layer.cornerRadius = 8
        
        noButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        yesButton.addTarget(self, action: #selector(addPharmacyAction), for: .touchUpInside)
      
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
    @objc private func addPharmacyAction() {
        
        if let pharmacy = pharmacy {
            let comment = commentTextField.text ?? ""
            delegate?.addPharmacyObject(pharmacy: pharmacy,comment: comment)
            self.dismiss(animated: true, completion: nil)
        } else {
            if ( pharmacyNameTextField.text != nil && pharmacyNameTextField.text != "" ) &&
                ( phoneTextField.text != nil && phoneTextField.text != "" ) &&
                ( specTextField.text != nil && specTextField.text != "" ) {
                 let pharmacy = Pharmacy(pharmacyID: "", pharmacyName: pharmacyNameTextField.text, address: specTextField.text , phone: phoneTextField.text, customerID: "")
                let comment = commentTextField.text ?? ""
                delegate?.addPharmacyObject(pharmacy: pharmacy,comment: comment)
                self.dismiss(animated: true, completion: nil)
            }
        }    
    }
    
    private func handlePharmacyView(pharmacy: Pharmacy) {
        pharmacyNameTextField.text = pharmacy.pharmacyName
        phoneTextField.text = pharmacy.phone
        specTextField.text = pharmacy.address
    }
}

//MARK: - UITextFieldDelegate
extension AddPharmacyViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !autoCompleteText( in : textField, using: string, suggestionsArray: pharmacies)
    }
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: Pharmacies) -> Bool {
        if !string.isEmpty,
           let selectedTextRange = textField.selectedTextRange,
           selectedTextRange.end == textField.endOfDocument,
           let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
           let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestionsArray.filter {
                $0.pharmacyName!.hasPrefix(prefix)
            }
            if (matches.count > 0) {
                textField.text = matches[0].pharmacyName
                pharmacy = matches[0]
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
