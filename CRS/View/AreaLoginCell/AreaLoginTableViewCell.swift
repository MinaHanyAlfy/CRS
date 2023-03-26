//
//  AreaLoginTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2023-03-24.
//

import UIKit

class AreaLoginTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var amOrPmLabel: UILabel!
    private var areaLogin: PreviousLoginElement?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        amOrPmLabel.text = ""
        areaLogin = nil
        dateLabel.text = ""
    }
    func cellConfig(areaLogin: PreviousLoginElement) {
        amOrPmLabel.text = areaLogin.amOrPm?.uppercased()
        self.areaLogin = areaLogin

        let dateArea = areaLogin.dateTime?.split(separator: " ",maxSplits: 2,omittingEmptySubsequences: false).first
        dateLabel.text = dateArea?.description
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
        
    @IBAction func mapAction(_ sender: Any) {
        if let areaLogin = self.areaLogin {
            openGoogleMap(long: areaLogin.longitude ?? "0.0" , lat: areaLogin.latitude ?? "0.0")
        }
    }
}
