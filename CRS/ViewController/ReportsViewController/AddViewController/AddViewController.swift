//
//  AddViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-11.
//

import UIKit
import CoreLocation
import SVProgressHUD


class AddViewController: UIViewController {
    let network = NetworkService.shared
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(tableViewCell: PharmaciesTableViewCell.self)
        tableView.registerCell(tableViewCell: ProductsTableViewCell.self)
        tableView.registerCell(tableViewCell: DoctorTableViewCell.self)
        tableView.registerCell(tableViewCell: DoubleVisitTableViewCell.self)
        tableView.registerCell(tableViewCell: CommentTableViewCell.self)
        tableView.registerCell(tableViewCell: ButtonTableViewCell.self)
        //        tableView.registerCell(tableViewCell: NextVisitTableViewCell.self)
        //        tableView.registerCell(tableViewCell: RequestTableViewCell.self)
        tableView.registerCell(tableViewCell: KeyPersonsTableViewCell.self)
        tableView.registerCell(tableViewCell: AccountTableViewCell.self)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    private var planNextVisitDate: String = ""
    private var planManager: Manager?
    private var planMessage: String = ""
    private var customer: Customer?
    private var account: Account?
    private var keyPersons: Keys = []
    private var encodedKeyPersons: Keys = []
    private var pharmacies: Pharmacies = []
    private var encodedPharmacies: Pharmacies = []
    private var manager: Manager?
    private var product_1: Product?
    private var product_2: Product?
    private var product_3: Product?
    private var product_4: Product?
    private var comment: String = ""
    private var date: String = ""
    private let user = CoreDataManager.shared.getUserInfo()
    private var pharmacyComments: [String] = []
    private var keyPersonsComments: [String] = []
    var reportAM: ReportAM?
    var reportPM: ReportPM?
    var isPm: Bool = false
    var isOPenToUpdate: Bool = false
    
    private var buttons = ["Next Visit","Send Request","Report","Cancel"]
    private var buttonsForUpdate = ["Next Visit","Send Request","Update","Cancel"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        date = todayDate()
        setupNavigation()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendDataToAddVisitingDayToUpdate()
    }
    
    private func setupNavigation() {
        if isPm {
            if isOPenToUpdate {
                title = "Update PM Visit"
            } else {
                title = "Adding New PM Visit"
            }
        } else {
            if isOPenToUpdate {
                title = "Update AM Visit"
            } else {
                title = "Adding New AM Visit"
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func setupTableView() {
        //        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func todayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}

//MARK: - UITableViewDataSource -
extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 6:
            return 4
        case 5:
            return 4
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if isPm {
                let cell = tableView.dequeue(tableViewCell: DoctorTableViewCell.self , forIndexPath: indexPath)
                cell.cellConfigToUpdate(isOpenToUpdate: isOPenToUpdate)
                cell.delegate = self
                cell.isOpenToUpdate = isOPenToUpdate
                return cell
            } else {
                let cell = tableView.dequeue(tableViewCell: AccountTableViewCell.self,forIndexPath: indexPath)
                cell.delegate = self
                cell.isOpenToUpdate = isOPenToUpdate
                cell.cellConfigToUpdate(isOpenToUpdate: isOPenToUpdate)
                return cell
            }
        case 1:
            let cell = tableView.dequeue(tableViewCell: DoubleVisitTableViewCell.self , forIndexPath: indexPath)
            cell.delegate = self
            cell.cellConfigToUpdate(isOpenToUpdate: isOPenToUpdate)
            return cell
        case 2:
            let cell = tableView.dequeue(tableViewCell: ProductsTableViewCell.self , forIndexPath: indexPath)
            cell.delegate = self
            cell.cellConfigToUpdate(isOpenToUpdate: isOPenToUpdate)
            return cell
        case 3:
            
            if isPm {
                let cell = tableView.dequeue(tableViewCell: PharmaciesTableViewCell.self , forIndexPath: indexPath)
                if let nav = navigationController {
                    cell.config(navigationController: nav)
                    cell.delegate = self
                }
                return cell
            } else {
                let cell = tableView.dequeue(tableViewCell: KeyPersonsTableViewCell.self, forIndexPath: indexPath)
                if let nav = navigationController {
                    cell.config(navigationController: nav)
                    cell.delegate = self
                }
                
                return cell
            }
        case 4:
            let cell = tableView.dequeue(tableViewCell: CommentTableViewCell.self , forIndexPath: indexPath)
            cell.delegate = self
            cell.cellConfigToUpdate(isOpenToUpdate: isOPenToUpdate)
            return cell
            
        default:
            let cell = tableView.dequeue(tableViewCell: ButtonTableViewCell.self , forIndexPath: indexPath)
            if isOPenToUpdate {
                
                cell.config(title: buttonsForUpdate[indexPath.row],isOpenToUpdate: isOPenToUpdate)
            } else {
                cell.config(title: buttons[indexPath.row],isOpenToUpdate: isOPenToUpdate)
            }
            cell.delegate = self
            return cell
        }
    }
    
    
}

////MARK: - UITableViewDelegate -
//extension AddViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Index: ", indexPath.row)
//    }
//}
//MARK: - ButtonTableViewCellDelegate -
extension AddViewController: ButtonTableViewCellDelegate {
    func updateAction() {
        print("Update Action")
        if isPm {
            updateReportPM()
        } else {
            updateReportAM()
        }
    }
    
    func nextVisitAction() {
        print("NextVisit")
        let vc = AddNextVisitViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    func sendRequestAction() {
        let vc = AddSendRequestVisitViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
        print("Send request")
    }
    func reportAction() {
        if manager?.id != nil {
            if planNextVisitDate == "" {
                alertIssues(message: "Please choose the next visiting day ")
            }
        }
        
        if isPm {
            sendPMReports(user: user,sendingDate: date)
        } else {
            sendAMReports(user: user, sendingDate: date)
        }
        
        print("Report")
    }
    
    func reportAction(location: CLLocation) {
        print("Report")
        print("Success Date ", date)
        if isPm {
            guard let customer = customer else { return }
            if manager?.id != nil {
                if planNextVisitDate == "" {
                    alertIssues(message: "Please choose the next visiting day ")
                }
            }
            if customer.customerLongitude == "" || customer.customerLongitude == nil || customer.customerLatitude == "" || customer.customerLatitude == nil {
                let alert = UIAlertController(title: "Location", message: "Set this location for this customer ?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes",style: .default, handler: { action in
                    self.saveCustomerLocation(customer: customer, long: "\(location.coordinate.longitude)", lat: "\(location.coordinate.latitude)")
                    print(location)
                }))
                alert.addAction(UIAlertAction(title: "No",style: .default, handler: { action in
                    self.sendPMReports(user: self.user, sendingDate: self.date)
                    self.dismiss(animated: true)
                }))
                present(alert, animated: true)
            } else {
                self.sendPMReports(user: user, sendingDate: date)
            }
            
            
        } else {
            guard let account = account else { return }
            if manager?.id != nil {
                if planNextVisitDate == "" {
                    alertIssues(message: "Please choose the next visiting day ")
                }
            }
            if account.accountLongitude == "" || account.accountLongitude == nil || account.accountLatitude == "" || account.accountLatitude == nil {
                DispatchQueue.main.async { [self] in
                    let alert = UIAlertController(title: "Location", message: "Set this location for this Account ?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes",style: .default, handler: { action in
                        self.saveAccountLocation(account: account, long: "\(location.coordinate.longitude)", lat: "\(location.coordinate.latitude)")
                        print(location)
                    }))
                    alert.addAction(UIAlertAction(title: "No",style: .default, handler: { action in
                        self.sendAMReports(user: self.user, sendingDate: self.date)
                        self.dismiss(animated: true)
                    }))
                    present(alert, animated: true)
                }
            } else {
                self.sendAMReports(user: user, sendingDate: date)
            }
        }
    }
    
    func cancelAction() {
        print("Cancel")
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - SendingReports & Store Locations -
extension AddViewController {
    private func saveCustomerLocation(customer: Customer, long: String, lat: String) {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        NetworkService.shared.getResultsStrings(APICase: .storeCustomerLocation(customerId: customer.customerID ?? "", lat: lat, long: long), decodingModel: ResponseString.self) { resp in
            switch resp {
            case .success(let response):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                self.handleStoreLocationResponse(response: response, long: long, lat: lat)
            case .failure(let error):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.alertIssues(message: "\(error)")
                }
            }
        }
    }
    
    private func saveAccountLocation(account: Account, long: String, lat: String) {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        NetworkService.shared.getResultsStrings(APICase: .storeAccountLocation(accountId: account.accountID ?? "", lat: lat, long: long), decodingModel: ResponseString.self) { resp in
            switch resp {
            case .success(let response):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                self.handleStoreLocationResponse(response: response, long: long, lat: lat)
            case .failure(let error):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.alertIssues(message: "\(error)")
                }
            }
        }
    }
    
    private func handleStoreLocationResponse(response: String,long: String, lat: String) {
        if response == "Location_Stored" {
            DispatchQueue.main.async {
                self.alertIssues(message: "Location stored successfully")
            }
            if isPm {
                sendPMReports(user: user, sendingDate: date)
            } else {
                sendAMReports(user: user, sendingDate: date)
            }
        } else {
            DispatchQueue.main.async {
                self.alertIssues(message: "Try again")
            }
        }
    }
    
    private func sendPMReports(user: User,sendingDate: String,long: String? = "",lat: String? = "") {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        guard let customer = self.customer else {
            alertIssues(message: "Please update Customer field.")
            return
        }
        guard let product = self.product_1 else {
            alertIssues(message: "Please check at least 1 product.")
            return
        }
        let pharmacyIDs: String = pharmacies.map { $0.pharmacyID ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let pharmacyNames: String = pharmacies.map { $0.pharmacyName?.toBase64() ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let pharmacyPhones: String = pharmacies.map { $0.phone?.toBase64() ?? "Unavalible Phone" } .joined(separator: " | ")
        let pharmacyAddresses: String = pharmacies.map { $0.address?.toBase64() ?? "Unavalible Address" } .joined(separator: " | ")
        let pharmacyComments: String = pharmacyComments.map { $0 } .joined(separator: " | ")
        
        network.getResultsStrings(APICase: .addPMVisit(level: user.level!, userId: user.idEncoded!, manager_level: self.manager?.level , manager_id: self.manager?.id, product_1: product.productID ?? "", product_2: product_2?.productID, product_3: product_3?.productID, product_4: product_4?.productID, customer_id: customer.customerID ?? "", lat: customer.customerLatitude, long: customer.customerLongitude, comment: comment, plan_date: sendingDate, recipient_level: planManager?.level, recipient_id: planManager?.id, message: planMessage, visiting_day_date: planNextVisitDate, p_ids: pharmacyIDs, p_names: pharmacyNames, p_addresses: pharmacyAddresses, p_phones: pharmacyPhones, p_comments: pharmacyComments), decodingModel: ResponseString.self) { response in
            switch response {
            case .success(let message):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if message == "Added" {
                        self.alertSuccessAndDismissViewController(message: "Report added successfully")
                    } else if message == "Reported_Day" {
                        self.alertIssues(message: "Reporting day already submitted and cannot be modified")
                    } else if message == "Reported_Visit" {
                        self.alertIssues(message: "Report for the same customer in the same day already reported")
                    } else {
                        self.alertIssues(message: message)
                    }
                }
                print("Response: ",message)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertIssues(message: error.localizedDescription)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func sendAMReports(user: User,sendingDate: String,long: String? = "",lat: String? = "") {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        guard let account = self.account else {
            alertIssues(message: "Please update Account field.")
            return
        }
        guard let product = self.product_1 else {
            alertIssues(message: "Please check at least 1 product.")
            return
        }
        let keyPerIDs: String = keyPersons.map { $0.keyPersonID ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let keyPerNames: String = keyPersons.map { $0.keyPersonName?.toBase64() ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let keyPerMobiles: String = keyPersons.map { $0.mobile?.toBase64() ?? "Unavalible Phone" } .joined(separator: " | ")
        let keyPerSpecial: String = keyPersons.map { $0.specialityName?.toBase64() ?? "Unavalible Address" } .joined(separator: " | ")
        let kerPerComments: String = keyPersonsComments.map { $0 } .joined(separator: " | ")
        
        network.getResultsStrings(APICase: .addAMVisit(level: user.level!, userId: user.idEncoded!, manager_level: self.manager?.level , manager_id: self.manager?.id, product_1: product.productID ?? "0", product_2: product_2?.productID, product_3: product_3?.productID, product_4: product_4?.productID, account_id: account.accountID, lat: account.accountLatitude, long: account.accountLongitude, comment: comment, plan_date: sendingDate, recipient_level: planManager?.level, recipient_id: planManager?.id, message: planMessage, visiting_day_date: planNextVisitDate, k_ids: keyPerIDs, k_names: keyPerNames , k_specialities: keyPerSpecial, k_mobiles: keyPerMobiles, k_comments: kerPerComments), decodingModel: ResponseString.self) { response in
            switch response {
            case .success(let message):
                print("Response: ",message)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if message == "Added" {
                        self.alertSuccessAndDismissViewController(message: "Report added successfully")
                    } else if message == "Reported_Day" {
                        self.alertIssues(message: "Reporting day already submitted and cannot be modified")
                    } else if message == "Reported_Visit" {
                        self.alertIssues(message: "Report for the same account in the same day already reported")
                    } else {
                        self.alertIssues(message: message)
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
    
    private func updateReportPM () {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        guard self.customer != nil else {
            alertIssues(message: "Please update Customer field.")
            return
        }
        guard self.product_1 != nil else {
            alertIssues(message: "Please check at least 1 product.")
            return
        }
        let pharmacyIDs: String = pharmacies.map { $0.pharmacyID ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let pharmacyNames: String = pharmacies.map { $0.pharmacyName?.toBase64() ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let pharmacyPhones: String = pharmacies.map { $0.phone?.toBase64() ?? "Unavalible Phone" } .joined(separator: " | ")
        let pharmacyAddresses: String = pharmacies.map { $0.address?.toBase64() ?? "Unavalible Address" } .joined(separator: " | ")
        let pharmacyComments: String = pharmacyComments.map { $0 } .joined(separator: " | ")
        let serial = UserDefaults.standard.string(forKey: "serial")
        network.getResultsStrings(APICase: .updatePMVisit(serial: serial ?? "",manager_level: manager?.level ?? "", managerId: manager?.id ?? "", product_1: product_1?.productID ?? "", product_2: product_2?.productID ?? "", product_3: product_3?.productID ?? "", product_4: product_4?.productID ?? "", comment: comment, p_ids: pharmacyIDs, p_names: pharmacyNames, p_addresses: pharmacyAddresses, p_phones: pharmacyPhones, p_comments: pharmacyComments), decodingModel: ResponseString.self) { result in
            switch result {
            case .success(let response):
                self.handleUpdateResponse(response: response)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        print(serial)
    
    }
    
    private func updateReportAM () {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        guard self.account != nil else {
            alertIssues(message: "Please update Account field.")
            return
        }
        guard self.product_1 != nil else {
            alertIssues(message: "Please check at least 1 product.")
            return
        }
        
        let keyPerIDs: String = keyPersons.map { $0.keyPersonID ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let keyPerNames: String = keyPersons.map { $0.keyPersonName?.toBase64() ?? "Unavalible Pharmacy" } .joined(separator: " | ")
        let keyPerMobiles: String = keyPersons.map { $0.mobile?.toBase64() ?? "Unavalible Phone" } .joined(separator: " | ")
        let keyPerSpecial: String = keyPersons.map { $0.specialityName?.toBase64() ?? "Unavalible Address" } .joined(separator: " | ")
        let kerPerComments: String = keyPersonsComments.map { $0 } .joined(separator: " | ")
        let serial = UserDefaults.standard.string(forKey: "serial")
        print(serial)
        network.getResultsStrings(APICase: .updateAMVisit(serial: serial ?? "", manager_level: manager?.level ?? "", managerId: manager?.id ?? "", product_1: product_1?.productID ?? "", product_2: product_2?.productID ?? "", product_3: product_3?.productID ?? "", product_4: product_4?.productID ?? "", comment: comment, k_ids: keyPerIDs, k_names: keyPerNames, k_specialities: keyPerSpecial, k_mobiles: keyPerMobiles, k_comments: kerPerComments), decodingModel: ResponseString.self) { result in
            switch result {
            case .success(let response):
                self.handleUpdateResponse(response: response)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    
    }
    
    private func handleUpdateResponse(response: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        if response == "Updated" {
            alertIssues(message: "Report updated successfully")
        } else if response == "Reported_Day" {
            alertIssues(message: "Report already submitted and cannot be edited")
        } else {
            alertIssues(message: response)
        }
    }
}


//MARK: - AddNextVisitDelegate
extension AddViewController: AddNextVisitDelegate {
    func nextVisitTime(date: String) {
        print("Success Date: ", date)
        self.planNextVisitDate = date
    }
}

//MARK: - AddSendRequestVisitDelegate
extension AddViewController: AddSendRequestVisitDelegate {
    func addDoubleVisitRequest(manager: Manager, message: String) {
        print("Manager: ",manager ,"-", message)
        self.planManager = manager
        self.planMessage = message
    }
}

//MARK: - DoctorTableViewDelegate
extension AddViewController: DoctorTableViewDelegate {
    func getCustomer(customer: Customer) {
        print("Doctor ", customer)
        self.customer = customer
    }
}

//MARK: - AccountTableViewDelegate
extension AddViewController: AccountTableViewDelegate {
    func getAccount(account: Account) {
        print("Account ", account)
        self.account = account
    }
}

//MARK: - CommentTableViewDelegate
extension AddViewController: CommentTableViewDelegate {
    func getComment(comment: String) {
        print("Comment, ", comment)
        self.comment = comment
    }
}

//MARK: - CommentTableViewDelegate
extension AddViewController: DoubleVisitTableViewDelegate {
    func getManagerDoubleVisit(manager: Manager) {
        print("Manager, ", manager)
        self.manager = manager
    }
}

//MARK: - KeyPersonsTableViewDelegate
extension AddViewController: KeyPersonsTableViewDelegate {
    func getKeyPersons(keyPersons: Keys,comments: [String]) {
        print("KeyPersons, ", keyPersons)
        self.keyPersons = keyPersons
        self.keyPersonsComments = comments
    }
}

//MARK: - PharmaciesTableViewDelegate
extension AddViewController: PharmaciesTableViewDelegate {
    func getPharmacies(pharmacies: Pharmacies,comments: [String]) {
        print("Pharmacies, ", pharmacies)
        self.pharmacies = pharmacies
        self.pharmacyComments = comments
    }
}

//MARK: - ProductsTableViewDelegate
extension AddViewController: ProductsTableViewDelegate {
    func getFirstProduct(product: Product) {
        print("First Product, ", product)
        self.product_1 = product
    }
    
    func getSecondProduct(product: Product) {
        print("Second Product, ", product)
        self.product_2 = product
    }
    
    func getThirdProduct(product: Product) {
        print("Third Product, ", product)
        self.product_3 = product
    }
    
    func getFourthProduct(product: Product) {
        print("Fourth Product, ", product)
        self.product_4 = product
    }
}

//MARK: - Update Data -
extension AddViewController {
    func sendDataToAddVisitingDayToUpdate () {
        if isPm {
            guard reportPM != nil else { return }
            UserDefaults.standard.set(reportPM?.visitComment, forKey: "visitComment")
            UserDefaults.standard.set(reportPM?.hManagerDv, forKey: "hManagerDv")
            UserDefaults.standard.set(reportPM?.mManagerDv, forKey: "mManagerDv")
            UserDefaults.standard.set(reportPM?.fManagerDv, forKey: "fManagerDv")
            UserDefaults.standard.set(reportPM?.visitingDayDate, forKey: "visitingDayDate")
            UserDefaults.standard.set(reportPM?.product1_ID, forKey: "product1_ID")
            UserDefaults.standard.set(reportPM?.product2_ID, forKey: "product2_ID")
            UserDefaults.standard.set(reportPM?.product3_ID, forKey: "product3_ID")
            UserDefaults.standard.set(reportPM?.product4_ID, forKey: "product4_ID")
            UserDefaults.standard.set(reportPM?.dvReport, forKey: "dvReport")
            //            UserDefaults.standard.set(reportPM?.customerName, forKey: "customerName")
            UserDefaults.standard.set(reportPM?.customerID, forKey: "customerID")
            UserDefaults.standard.set(reportPM?.serial, forKey: "serial")
            //            UserDefaults.standard.set(reportPM?.customerPotential, forKey: "customerPotential")
            //            UserDefaults.standard.set(reportPM?.customerPrescription, forKey: "customerPrescription")
            
            //            UserDefaults.standard.set(reportPM?.pIDS, forKey: "pIDS")
            //            UserDefaults.standard.set(reportPM?.pNames, forKey: "pNames")
            //            UserDefaults.standard.set(reportPM?.pMobiles, forKey: "pMobiles")
            //            UserDefaults.standard.set(reportPM?.pSpecialities, forKey: "pSpecialities")
            //            UserDefaults.standard.set(reportPM?.pComments, forKey: "pComments")
            //            UserDefaults.standard.set(reportPM?.specialityName, forKey: "specialityName")
            
        } else {
            guard reportAM != nil else { return }
            UserDefaults.standard.set(reportAM?.visitComment, forKey: "visitComment")
            UserDefaults.standard.set(reportAM?.hManagerDv, forKey: "hManagerDv")
            UserDefaults.standard.set(reportAM?.mManagerDv, forKey: "mManagerDv")
            UserDefaults.standard.set(reportAM?.fManagerDv, forKey: "fManagerDv")
            UserDefaults.standard.set(reportAM?.visitingDayDate, forKey: "visitingDayDate")
            UserDefaults.standard.set(reportAM?.product1_ID, forKey: "product1_ID")
            UserDefaults.standard.set(reportAM?.product2_ID, forKey: "product2_ID")
            UserDefaults.standard.set(reportAM?.product3_ID, forKey: "product3_ID")
            UserDefaults.standard.set(reportAM?.product4_ID, forKey: "product4_ID")
            UserDefaults.standard.set(reportAM?.serial, forKey: "serial")
            //            UserDefaults.standard.set(reportAM?.accountName, forKey: "accountName")
            UserDefaults.standard.set(reportAM?.accountID, forKey: "accountID")
            //            UserDefaults.standard.set(reportAM?.accountPotential, forKey: "accountPotential")
            //            UserDefaults.standard.set(reportAM?.accountPrescription, forKey: "accountPrescription")
            //            UserDefaults.standard.set(reportAM?.dvReport, forKey: "dvReport")
            //            UserDefaults.standard.set(reportAM?.kIDS, forKey: "kIDS")
            //            UserDefaults.standard.set(reportAM?.kNames, forKey: "kNames")
            //            UserDefaults.standard.set(reportAM?.kMobiles, forKey: "kMobiles")
            //            UserDefaults.standard.set(reportAM?.kSpecialities, forKey: "kSpecialities")
            //            UserDefaults.standard.set(reportAM?.kComments, forKey: "kComments")
            //            UserDefaults.standard.set(reportAM?.specialityName, forKey: "specialityName")
        }
    }
}
