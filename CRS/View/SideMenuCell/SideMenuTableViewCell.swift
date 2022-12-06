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
    let cdManager = CoreDataManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
                navigationController.pushViewController(reportVc, animated: true)
            case 2:
                let reportVc = ReportsViewController()
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
                let refreshVc = RefreshViewController()
                navigationController.pushViewController(refreshVc, animated: true)
            }
        } else {
            let logOutVc = AuthenticationViewController()
//            cdManager.clearUserInfo()
            cdManager.clearAll()
            logOutVc.modalPresentationStyle = .fullScreen
            viewController.present(logOutVc, animated: true)
        }
        
    }
    
}
