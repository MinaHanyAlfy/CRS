//
//  SideMenuTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-03.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var sideMenuLabel: UILabel!
    @IBOutlet weak var sideMenuImageView: UIImageView!
    
    private let labelsArray = ["Home","AM Reports","PM Reports","Accounts","Customers","Prospection Tool","Refresh"]
    private let imagesArray = ["house.fill","sun.max.fill","moon.stars.fill","building.2.fill","person.3.fill","wifi.exclamationmark","repeat"]
    let coreData = CoreDataManager.shared
    let network = NetworkService.shared
    
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
    override func awakeFromNib() {
        super.awakeFromNib()
        sideMenuImageView.tintColor = UIColor(named: "bluePrimary")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func cellConfig(section: Int,index: Int){
        if section == 0 {
            sideMenuLabel.text = labelsArray[index]
            sideMenuImageView.image = UIImage(systemName: imagesArray[index])
            
        }else{
            sideMenuLabel.text = "Logout"
            sideMenuImageView.image = UIImage(systemName: "door.right.hand.open")
        }
    }
    
    func setSelectedCell(index: IndexPath, navigationController: UINavigationController, viewController: UIViewController) {
        if index.section == 0 {
            switch index.row {
            case 0:
                navigationController.dismiss(animated: true)
            case 1:
                let reportVc = ReportsViewController()
                reportVc.timeVisit = "AM"
                navigationController.pushViewController(reportVc, animated: true)
            case 2:
                let reportVc = ReportsViewController()
                reportVc.timeVisit = "PM"
                reportVc.isPM = true
                navigationController.pushViewController(reportVc, animated: true)
            case 3:
                let accountVc = AccountsViewController()
                navigationController.pushViewController(accountVc, animated: true)
            case 4:
                let customersVc = CustomersViewController()
                navigationController.pushViewController(customersVc, animated: true)
            case 5:
                let proToolVc = ProspectionToolViewController()
                navigationController.pushViewController(proToolVc, animated: true)
            default:
                coreData.clearAllWithoutUserInfo()
                callingAPI(navigationController: navigationController,viewController: viewController)
                //                let refreshVc = RefreshViewController()
//                navigationController.pushViewController(refreshVc, animated: true)
            }
        } else {
            let logOutVc = AuthenticationViewController()
            coreData.clearAll()
            logOutVc.modalPresentationStyle = .fullScreen
            viewController.present(logOutVc, animated: true)
        }
        
    }
    
}

extension SideMenuTableViewCell {
    func callingAPI(navigationController: UINavigationController,viewController: UIViewController){
        let user = coreData.getUserInfo()
        guard let level = user.level else {return}
        guard let id = user.idEncoded else {return}
        //Sameh Comapny
        let dispatchGroup = DispatchGroup()
        //To get products
        dispatchGroup.enter()
        NetworkService.shared.getResults(APICase: .getProducts(level: level, userId: id), decodingModel: Products.self) { response in
            switch response {
            case .success(let data):
                self.products = data
                dispatchGroup.leave()
            case .failure(let error):
                viewController.alertIssues(message: error.localizedDescription)
            }
        }
        //To get managers
        dispatchGroup.enter()
        NetworkService.shared.getResults(APICase: .getManagers(level: level, userId: id), decodingModel: Managers.self) { response in
            switch response {
            case .success(let data):
                self.managers = data
                dispatchGroup.leave()
            case .failure(let error):
                viewController.alertIssues(message: error.localizedDescription)
            }
        }
        
        //To get Customers
        dispatchGroup.enter()
        NetworkService.shared.getResults(APICase: .getCustomers(level: level, userId: id), decodingModel: Customers.self) { response in
            switch response {
            case .success(let data):
                self.customers = data
                dispatchGroup.leave()
            case .failure(let error):
                viewController.alertIssues(message: error.localizedDescription)
            }
        }
        //To get Accounts
        dispatchGroup.enter()
        NetworkService.shared.getResults(APICase: .getAccounts(level: level, userId: id), decodingModel: Accounts.self) { response in
            switch response {
            case .success(let data):
                self.accounts = data
                dispatchGroup.leave()
            case .failure(let error):
                viewController.alertIssues(message: error.localizedDescription)
            }
        }
        
        //To get Keys
        dispatchGroup.enter()
        NetworkService.shared.getResults(APICase: .getKeys(level: level, userId: id), decodingModel: Keys.self) { response in
            switch response {
            case .success(let data):
                self.keys = data
                dispatchGroup.leave()
            case .failure(let error):
                viewController.alertIssues(message: error.localizedDescription)
            }
        }
        
        //To get Pharmacies
        dispatchGroup.enter()
        NetworkService.shared.getResults(APICase: .getPharmacies(level: level, userId: id), decodingModel: Pharmacies.self) { response in
            switch response {
            case .success(let data):
                self.pharmacies = data
                dispatchGroup.leave()
            case .failure(let error):
                viewController.alertIssues(message: error.localizedDescription)
            }
        }
        
        
        dispatchGroup.notify(queue: .main){ [self] in
            print("All Data received successfully!")
            viewController.alertSuccessAndDismissViewController(message: "Your data loaded successfully!")

        }
    }
}
