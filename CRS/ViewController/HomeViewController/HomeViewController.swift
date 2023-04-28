//
//  HomeViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-01.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    @IBOutlet var mapView: GMSMapView!
    
    var company: CompanyElement?
    var long: Double = 0.0
    var lat: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.isUserInteractionEnabled = true
        numberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mobileNumberTapped)))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let company = company else {
             return
        }
        if (companyNameLabel.text == nil) == (company.name != nil) {
            SVProgressHUD.show()
        }
        DispatchQueue.main.async {
            [self] in
            self.companyNameLabel.text = company.name
            self.departmentLabel.text = company.title
            self.locationLabel.text = company.address
            if company.latitude != nil && company.longitude != nil {
                lat = Double(company.latitude ?? "0.0" )!
                long = Double(company.longitude ?? "0.0")!
            }
            self.numberLabel.text = company.tel
            print("Camera :", long , lat)
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 18)
            SVProgressHUD.dismiss()
        }
    }
    
    @objc func mobileNumberTapped() {
        if numberLabel.text != "" && numberLabel.text != "Number" {
            UIApplication.shared.openURL(URL(string: "tel://+20222030198")!)
        }
        

    }
   
    
}
