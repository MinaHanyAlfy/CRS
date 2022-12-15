//
//  LoginViewController.swift
//  CRS
//
//  Created by John Doe on 2022-11-28.
//

import UIKit
import WebKit
import SideMenu

class LoginViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var levels: [String] = ["Representative","First_Line_Manager","Middle_Manager","Higher_Manager"]
    private var levelName: String = "Representative"
    private var company: Company?
    private var username: String?
    private var password: String?
    let coreData = CoreDataManager.shared
    private var userId: String?{
        didSet{
            DispatchQueue.main.async { [self] in
                guard let username = username, let password = password else { return }
                callingAPI(username: username, password: password, level: levelName)
            }
        }
    }
    private var products : Products?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let products = products else { return }
                coreData.saveProducts(products: products)
            }
        }
    }
    private var managers: Managers?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let managers = managers else { return }
                coreData.saveManagers(managers: managers)
            }
        }
    }
    private var customers: Customers?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let customers = customers else { return }
                coreData.saveCustomers(customers: customers)
            }
        }
    }
    private var accounts: Accounts?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let accounts = accounts else { return }
                coreData.saveAccounts(accounts: accounts)
            }
        }
    }
    private var keys: Keys?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let keys = keys else { return }
                coreData.saveKeys(keys: keys)
            }
        }
    }
    private var pharmacies: Pharmacies?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                guard let pharmacies = pharmacies else { return }
                coreData.savePharmacy(pharmacies: pharmacies)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.tintColor = .white
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, password != "", username != "" else {
            self.alertIssues(message: "Please, Check your level, username and password")
            return
        }
        self.username = username
        self.password = password
        
        //To get ID
        NetworkServiceMock.shared.getResultsStrings(APICase: .userLoginID(name: username, password: password, level: levelName), decodingModel: ResponseString.self) { response in
            switch response {
            case .success(let data):
                self.userId = data
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)

            }
        }
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        if let url = URL(string: "https://ark-crs.com/PrivacyPolicy.docx") {
            UIApplication.shared.open(url)
        }
    }
    
    
}

//MARK: - UIPickerViewDelegate
extension LoginViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return levels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected", levels[row])
        levelName = levels[row]
//        self.pickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: levels[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
}

//MARK: - UIPickerViewDataSource
extension LoginViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == self.passwordTextField {
               textField.endEditing(true)
           }
       }
}

//MARK: - Calling API NETWORK AFTER LOGIN
extension LoginViewController {
    private func callingAPI(username: String,password: String,level: String){
        //Sameh Comapny
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkServiceMock.shared.getResults(APICase: .companyAuth(company: username, password: password, level: level), decodingModel: Company.self, completed: { response in
            switch response {
            case .success(let data):
                self.company = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        })
        //To get products
        dispatchGroup.enter()
        guard let id = userId else { return }
        NetworkServiceMock.shared.getResults(APICase: .getProducts(level: level, userId: id), decodingModel: Products.self) { response in
            switch response {
            case .success(let data):
                self.products = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        }
        //To get managers
        dispatchGroup.enter()
        NetworkServiceMock.shared.getResults(APICase: .getManagers(level: level, userId: id), decodingModel: Managers.self) { response in
            switch response {
            case .success(let data):
                self.managers = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        }
        
        //To get Customers
        dispatchGroup.enter()
        NetworkServiceMock.shared.getResults(APICase: .getCustomers(level: level, userId: id), decodingModel: Customers.self) { response in
            switch response {
            case .success(let data):
                self.customers = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        }
        //To get Accounts
        dispatchGroup.enter()
        NetworkServiceMock.shared.getResults(APICase: .getAccounts(level: level, userId: id), decodingModel: Accounts.self) { response in
            switch response {
            case .success(let data):
                self.accounts = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        }
        
        //To get Keys
        dispatchGroup.enter()
        NetworkServiceMock.shared.getResults(APICase: .getKeys(level: level, userId: id), decodingModel: Keys.self) { response in
            switch response {
            case .success(let data):
                self.keys = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        }
        
        //To get Pharmacies
        dispatchGroup.enter()
        NetworkServiceMock.shared.getResults(APICase: .getPharmacies(level: level, userId: id), decodingModel: Pharmacies.self) { response in
            switch response {
            case .success(let data):
                self.pharmacies = data
                dispatchGroup.leave()
            case .failure(let error):
                self.alertIssues(message: error.localizedDescription)
            }
        }
        
        
        dispatchGroup.notify(queue: .main){ [self] in
            guard let company = company?.first else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            initialViewController.company = company
            print("All Data received successfully!")
            let navigationController = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.pushViewController(initialViewController, animated: false)
            CoreDataManager.shared.saveUserInfo(user: User(name: self.username,id: userId, company: CompanyElement(serial: company.serial, name: company.name, pass: company.pass, title: company.title, address: company.address, latitude: company.latitude, longitude: company.longitude, tel: company.tel, retrospectiveReport: company.retrospectiveReport)))
            self.present(navigationController, animated: true)
        }
    }
    
    
    
    
}

