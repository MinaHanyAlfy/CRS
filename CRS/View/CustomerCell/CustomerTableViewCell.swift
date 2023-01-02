//
//  CustomerTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private var customer: Customer?
    private var account: Account?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCell() {
        mapButton.clipsToBounds = true
        mapButton.layer.cornerRadius = 12
        mapButton.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
    }
    
    func cellConfig(index: Int, isAccount: Bool = false) {
        
        if isAccount {
            zoneLabel.isHidden = true
        }
    }
    
    func config(customer: Customer) {
        self.customer = customer
        nameLabel.text = customer.customerName
        categoryLabel.text = customer.pharmacy
        zoneLabel.text = customer.specialityName
    }
    
    func config(account: Account) {
        self.account = account
        nameLabel.text = account.accountName
        categoryLabel.text = account.specialityName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        categoryLabel.text = ""
        zoneLabel.text = ""
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
    
    @objc private func mapAction() {
        if let customer = self.customer {
            openGoogleMap(long: customer.customerLongitude ?? "0.0" , lat: customer.customerLatitude ?? "0.0")
        }
        
        if let account = self.account {
            openGoogleMap(long: account.accountLongitude ?? "0.0" , lat: account.accountLatitude ?? "0.0")
        }
        
    }
}
