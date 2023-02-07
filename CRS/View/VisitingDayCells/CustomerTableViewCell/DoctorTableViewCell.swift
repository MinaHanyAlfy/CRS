//
//  DoctorTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit

protocol DoctorTableViewDelegate: AnyObject {
    func getCustomer(customer: Customer)
}
class DoctorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var rxPotLabel: UILabel!
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var spLabel: UILabel!
    @IBOutlet weak var doctorTextField: UITextField!
    public weak var delegate: DoctorTableViewDelegate?
    private var customer: Customer? {
        didSet {
            DispatchQueue.main.async { [self] in
               handleCellView()
            }
        }
    }
    private var customers: Customers = []
    var iSOpenToUpdate: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doctorTextField.delegate = self
        mapButton.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        customers = CoreDataManager.shared.getCustomers()
        if iSOpenToUpdate {
            var id = UserDefaults.standard.value(forKey: "customerID") as? String
            if id != nil {
                customer = customers.filter { $0.customerID == id }[0]
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc private func mapAction (){
        guard let customer = customer else { return }
        openGoogleMap(long: customer.customerLongitude ?? "0.0", lat: customer.customerLatitude ?? "0.0")
        
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
        guard let customer = customer else { return }
        spLabel.text = customer.specialityName
        potLabel.text = customer.customerPotential
        rxPotLabel.text = customer.customerPrescription
        delegate?.getCustomer(customer: customer)
    }
}

//MARK: - UITextFieldDelegate
extension DoctorTableViewCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return !autoCompleteText( in : textField, using: string, suggestionsArray: customers)
    }
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: Customers) -> Bool {
            if !string.isEmpty,
                let selectedTextRange = textField.selectedTextRange,
                selectedTextRange.end == textField.endOfDocument,
                let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
                let text = textField.text( in : prefixRange) {
                let prefix = text + string
                let matches = suggestionsArray.filter {
                    $0.customerName!.hasPrefix(prefix)
                }
                if (matches.count > 0) {
                    textField.text = matches[0].customerName
                    customer = matches[0]
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

