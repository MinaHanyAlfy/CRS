//
//  AddViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-11.
//

import UIKit
import CoreLocation

class AddViewController: UIViewController {
    let network = NetworkServiceMock.shared
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
        tableView.registerCell(tableViewCell: NextVisitTableViewCell.self)
        tableView.registerCell(tableViewCell: RequestTableViewCell.self)
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
    private var pharmacies: Pharmacies = []
    private var manager: Manager?
    private var product_1: Product?
    private var product_2: Product?
    private var product_3: Product?
    private var product_4: Product?
    private var comment: String = ""
    private var pharmacyComments: [String] = []
    private var keyPersonsComments: [String] = []
    private var buttons = ["Next Visit","Send Request","Report","Cancel"]
    var isPm: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupNavigation() {
        title = "Adding New Visit"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

//MARK: - UITableViewDataSource
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
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeue(tableViewCell: AccountTableViewCell.self,forIndexPath: indexPath)
                cell.delegate = self
                return cell
            }
        case 1:
            let cell = tableView.dequeue(tableViewCell: DoubleVisitTableViewCell.self , forIndexPath: indexPath)
                cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeue(tableViewCell: ProductsTableViewCell.self , forIndexPath: indexPath)
                cell.delegate = self
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
            return cell
            
        default:
            let cell = tableView.dequeue(tableViewCell: ButtonTableViewCell.self , forIndexPath: indexPath)
            cell.config(title: buttons[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    
}

//MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: ", indexPath.row)
    }
}

extension AddViewController: ButtonTableViewCellDelegate {
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: String = dateFormatter.string(from: Date())
        print("Next Visit ", date)
        let user = CoreDataManager.shared.getUserInfo()
        print("user ID: ", user.idDecoded, user.level)
        if isPm {
            
            let pharmacyIDs: String = pharmacies.map { $0.pharmacyID ?? "Unavalible Pharmacy" } .joined(separator: " | ")
            let pharmacyNames: String = pharmacies.map { $0.pharmacyName ?? "Unavalible Pharmacy" } .joined(separator: " | ")
            let pharmacyPhones: String = pharmacies.map { $0.phone ?? "Unavalible Phone" } .joined(separator: " | ")
            let pharmacyAddresses: String = pharmacies.map { $0.address ?? "Unavalible Address" } .joined(separator: " | ")
            guard let customer = self.customer else {
                alertIssues(message: "Please update Customer field.")
                return
            }
            guard let product = self.product_1 else {
                alertIssues(message: "Please check at least 1 product.")
                return
            }
            
            
            let pharmacyComments: String = pharmacyComments.map { $0 } .joined(separator: " | ")
            network.getResultsStrings(APICase: .addPMVisit(level: user.level!, userId: user.idDecoded!, manager_level: self.manager?.level , manager_id: self.manager?.id, product_1: product.productID ?? "", product_2: product_2?.productID, product_3: product_3?.productID, product_4: product_4?.productID, customer_id: customer.customerID ?? "", lat: customer.customerLatitude, long: customer.customerLongitude, comment: comment, plan_date: date, recipient_level: planManager?.level, recipient_id: planManager?.id, message: planMessage, visiting_day_date: planNextVisitDate, p_ids: pharmacyIDs, p_names: pharmacyNames, p_addresses: pharmacyAddresses, p_phones: pharmacyPhones, p_comments: pharmacyComments), decodingModel: ResponseString.self) { response in
                switch response {
                case .success(let message):
                    DispatchQueue.main.async {
                        if message == "Added" {
                            self.alertSuccessAndDismissViewController(message: "Report added successfully")
                        }
                    }
                    print("Response: ",message)
                case .failure(let error):
                    self.alertIssues(message: error.localizedDescription)
                }
           
            }
        } else {
            guard let account = self.account else {
                alertIssues(message: "Please update Account field.")
                return
            }
            guard let product = self.product_1 else {
                alertIssues(message: "Please check at least 1 product.")
                return
            }
            let keyPerIDs: String = keyPersons.map { $0.keyPersonID ?? "Unavalible Pharmacy" } .joined(separator: " | ")
            let keyPerNames: String = keyPersons.map { $0.keyPersonName ?? "Unavalible Pharmacy" } .joined(separator: " | ")
            let keyPerMobiles: String = keyPersons.map { $0.mobile ?? "Unavalible Phone" } .joined(separator: " | ")
            let keyPerSpecial: String = keyPersons.map { $0.specialityName ?? "Unavalible Address" } .joined(separator: " | ")
            let kerPerComments: String = keyPersonsComments.map { $0 } .joined(separator: " | ")
            
            network.getResultsStrings(APICase: .addAMVisit(level: user.level!, userId: user.idDecoded!, manager_level: self.manager?.level , manager_id: self.manager?.id, product_1: product.productID ?? "", product_2: product_2?.productID, product_3: product_3?.productID, product_4: product_4?.productID, account_id: account.accountID, lat: account.accountLatitude, long: account.accountLongitude, comment: comment, plan_date: date, recipient_level: planManager?.level, recipient_id: planManager?.id, message: planMessage, visiting_day_date: planNextVisitDate, k_ids: keyPerIDs, k_names: keyPerNames , k_specialities: keyPerSpecial, k_mobiles: keyPerMobiles, k_comments: kerPerComments), decodingModel: ResponseString.self) { response in
                switch response {
                case .success(let message):
                    print("Response: ",message)
                    if message == "Added" {
                        self.alertSuccessAndDismissViewController(message: "Report added successfully")
                    }
                case .failure(let error):
                    self.alertIssues(message: error.localizedDescription)
                }
           
            }
            
        }
            
        
        print("Report")
    }
    func reportAction(location: CLLocation) {
        print("Report")
        let alert = UIAlertController(title: "Location", message: "Set this location for this customer ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes",style: .default, handler: { action in
            //Send Location to update it in JAVA
            /*RequestQueue queue = Volley.newRequestQueue(NewPMVisitActivity.this);
             String ApplicationURL = S_Pref.getString("ApplicationURL", "");
             String store_customer_location_url = ApplicationURL + "" +
             "?customer_id="+customer_id+
             "&lat="+current_latitude+
             "&long="+current_longitude+
             "&store_customer_location=x";
             
             StringRequest stringRequest = new StringRequest(com.android.volley.Request.Method.GET, store_customer_location_url, storeCustomerLocationResponseListener, ErrorListener);
             queue.add(stringRequest);*/
            print(location)
        }))
        alert.addAction(UIAlertAction(title: "No",style: .default, handler: { action in
            //Dismiss it
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
        //Save Visit
    }
    
    func cancelAction() {
        print("Cancel")
        self.navigationController?.popViewController(animated: true)
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
