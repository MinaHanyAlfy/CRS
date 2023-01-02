//
//  AddViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-11.
//

import UIKit
import CoreLocation

enum AddVisitSections : Int{
    case doctor = 0
    case doubleVisit = 1
    case product = 2
    case pharmacy = 3
    case comment = 4
    case nextVisit = 5
    case sendRequest = 6
    case button = 7
    
}


class AddViewController: UIViewController {

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
                return cell
            } else {
                let cell = tableView.dequeue(tableViewCell: AccountTableViewCell.self,forIndexPath: indexPath)
                return cell
            }
        case 1:
            let cell = tableView.dequeue(tableViewCell: DoubleVisitTableViewCell.self , forIndexPath: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeue(tableViewCell: ProductsTableViewCell.self , forIndexPath: indexPath)
            return cell
        case 3:
            
            if isPm {
                let cell = tableView.dequeue(tableViewCell: PharmaciesTableViewCell.self , forIndexPath: indexPath)
                if let nav = navigationController {
                    cell.config(navigationController: nav)
                }
                return cell
            } else {
                let cell = tableView.dequeue(tableViewCell: KeyPersonsTableViewCell.self, forIndexPath: indexPath)
                if let nav = navigationController {
                    cell.config(navigationController: nav)
                }
                return cell
            }
        case 4:
           let cell = tableView.dequeue(tableViewCell: CommentTableViewCell.self , forIndexPath: indexPath)
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
    }
}

//MARK: - AddSend
extension AddViewController: AddSendRequestVisitDelegate {
    func addDoubleVisitRequest(manager: Manager, message: String) {
        print("Manager: ",manager ,"-", message)
    }
}
