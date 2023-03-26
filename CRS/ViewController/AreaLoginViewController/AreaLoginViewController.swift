//
//  AreaLoginViewController.swift
//  CRS
//
//  Created by John Doe on 2023-03-19.
//

import UIKit
import CoreLocation
import DZNEmptyDataSet
import SVProgressHUD

class AreaLoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var locManager = CLLocationManager()
    private var previousLogin: PreviousLogin = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                if previousLogin.count > 0 && previousLogin[0].amOrPm != "NONE"  {
                    tableView.reloadData()
                } else {
                    if previousLogin.count == 1 && previousLogin[0].amOrPm == "NONE" {
                        previousLogin.removeFirst()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    private var isPM: Bool = false
    private let user = CoreDataManager.shared.getUserInfo()
    private let network = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPreviousAreaLogin()
        datePicker.backgroundColor = .white
        datePicker.contentVerticalAlignment = .center
        datePicker.contentHorizontalAlignment = .center
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 12
        tableView.registerCell(tableViewCell: AreaLoginTableViewCell.self)
    }

    @IBAction func dateValueChanged(_ sender: Any) {
        getPreviousAreaLogin()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let alert = UIAlertController(title: "AM or PM ?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "AM", style: .default,handler: { _ in
            self.isPM = false
            self.makeLogin(isPM: false)
        }))
        alert.addAction(UIAlertAction(title: "PM", style: .default,handler: { _ in
            self.isPM = true
            self.makeLogin(isPM: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.sourceRect = self.loginButton.bounds
        alert.popoverPresentationController?.sourceView = self.loginButton
        present(alert, animated: true)
                        
    }
    
    private func makeLogin(isPM: Bool) {
        
        var currentLocation: CLLocation!
         if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways {
             currentLocation = locManager.location
             SVProgressHUD.show()
             if isPM {
                 network.getResultsStrings(APICase: .addLogIn(level: user.level ?? "", userId: user.idEncoded ?? "", am_Or_pm: "pm", lat: "\(currentLocation.coordinate.latitude)", long: "\(currentLocation.coordinate.longitude)"), decodingModel: ResponseString.self) { result in
                     switch result {
                     case .success(let response):
                         if response == "success" {
                             DispatchQueue.main.async {
                                 SVProgressHUD.dismiss()
                                 self.alertSuccessAndDismissViewController(message: "Logged in successfully")
                                 self.getPreviousAreaLogin(isToday: true)
                             }
                         }
                     case .failure(let error):
                         DispatchQueue.main.async {
                             SVProgressHUD.dismiss()
                             self.alertIssues(message: error.localizedDescription)
                         }
                     }
                 }
             } else {
                 network.getResultsStrings(APICase: .addLogIn(level: user.level ?? "", userId: user.idEncoded ?? "", am_Or_pm: "am", lat: "\(currentLocation.coordinate.latitude)", long: "\(currentLocation.coordinate.longitude)"), decodingModel: ResponseString.self) { result in
                     switch result {
                     case .success(let response):
                         if response == "success" {
                             DispatchQueue.main.async {
                                 SVProgressHUD.dismiss()
                                 self.alertSuccessAndDismissViewController(message: "Logged in successfully")
                                 self.getPreviousAreaLogin(isToday: true)
                             }
                         }
                     case .failure(let error):
                         DispatchQueue.main.async {
                             SVProgressHUD.dismiss()
                             self.alertIssues(message: error.localizedDescription)
                         }
                     }
                 }
             }
         }
    }
    
    //Calling API To get Previous Area Login
    func getPreviousAreaLogin(isToday: Bool? = false) {
        SVProgressHUD.show()
        if isToday ?? false {
            network.getResults(APICase: .getPreviousAreaLogin(level: user.level ?? "", userId: user.idEncoded ?? "", date: "".todayDate), decodingModel: PreviousLogin.self) { result in
                switch result {
                case .success(let response):
                    self.previousLogin = response
                    SVProgressHUD.dismiss()

                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.alertIssues(message: error.localizedDescription)
                    }
                }
            }
        } else {
            network.getResults(APICase: .getPreviousAreaLogin(level: user.level ?? "", userId: user.idEncoded ?? "", date: datePicker.date.updateDate), decodingModel: PreviousLogin.self) { result in
                switch result {
                case .success(let response):
                    self.previousLogin = response
                    SVProgressHUD.dismiss()

                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.alertIssues(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}


//MARK: - UITableViewDataSource -
extension AreaLoginViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: AreaLoginTableViewCell.self ,forIndexPath: indexPath)
        cell.cellConfig(areaLogin: previousLogin[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousLogin.count
    }
}
//MARK: - UITableViewDelegate -
extension AreaLoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}


//MARK: - DZNEmptyDataSetSource -
extension AreaLoginViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(systemName: "bell.fill")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let quote = "You don't have any previous Login."
        let attributedQuote = NSMutableAttributedString(string: quote)
        return attributedQuote
    }
}
