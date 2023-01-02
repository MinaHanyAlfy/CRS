//
//  AccountTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-29.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var rxPotLabel: UILabel!
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var spLabel: UILabel!
    @IBOutlet weak var accountNameTextField: UITextField!
    
    private var account: Account?
    private var accounts: Accounts = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accountNameTextField.delegate = self
        mapButton.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        accounts = CoreDataManager.shared.getAccounts()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @objc private func mapAction (){
        guard let account = account else { return }
        openGoogleMap(long: account.accountLongitude ?? "0.0", lat: account.accountLatitude ?? "0.0")
    }
    
    func openGoogleMap(long: String,lat: String) {
        if long != "0.0" && lat != "0.0"{
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
    
    
    func handleCellView() {
        guard let account = account else { return }
        spLabel.text = account.specialityName
        potLabel.text = account.accountPotential
        rxPotLabel.text = account.accountPrescription
    }
}
//MARK: - UITextFieldDelegate
extension AccountTableViewCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return !autoCompleteText( in : textField, using: string, suggestionsArray: accounts)
    }
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: Accounts) -> Bool {
            if !string.isEmpty,
                let selectedTextRange = textField.selectedTextRange,
                selectedTextRange.end == textField.endOfDocument,
                let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
                let text = textField.text( in : prefixRange) {
                let prefix = text + string
                let matches = suggestionsArray.filter {
                    $0.accountName!.hasPrefix(prefix)
                }
                if (matches.count > 0) {
                    textField.text = matches[0].accountName
                    account = matches[0]
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
            handleCellView()
            return true
    }
    
    
    
}
