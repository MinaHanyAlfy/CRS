//
//  HomeViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-01.
//

import UIKit
import GoogleMaps


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
     
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let company = company else {
             return
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
            let camera = GMSCameraPosition(
                latitude: self.lat ,
                longitude: self.long,
                zoom: 16
            )
            self.mapView = GMSMapView(frame : self.view.bounds, camera: camera)
        }
    }
}
