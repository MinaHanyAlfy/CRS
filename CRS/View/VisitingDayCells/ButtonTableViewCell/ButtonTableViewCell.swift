//
//  ButtonTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit
import CoreLocation
protocol ButtonTableViewCellDelegate: AnyObject {
    func cancelAction()
    func nextVisitAction()
    func reportAction(location: CLLocation)
    func reportAction()
    func sendRequestAction()
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    public weak var delegate: ButtonTableViewCellDelegate?
    var locManager = CLLocationManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(title: String) {
        button.setTitle(title, for: .normal)
        if title == "Next Visit" {
            button.addTarget(self, action: #selector(nextVisitTap), for: .touchUpInside)
        } else if title == "Send Request" {
            button.addTarget(self, action: #selector(sendRequestTap), for: .touchUpInside)
        } else if title == "Report" {
            locManager.requestWhenInUseAuthorization()
            button.addTarget(self, action: #selector(reportTap), for: .touchUpInside)
        } else if title == "Cancel" {
            button.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        }
        
    }
    
    @objc private func nextVisitTap() {
        delegate?.nextVisitAction()
    }
    
    @objc private func sendRequestTap() {
        delegate?.sendRequestAction()
    }
    
    @objc private func reportTap() {
        var currentLocation: CLLocation!
         if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
             currentLocation = locManager.location
             delegate?.reportAction(location: currentLocation)
         }else {
             delegate?.reportAction()
         }
        
    }
    
    @objc private func cancelTap() {
        delegate?.cancelAction()
    }
}
