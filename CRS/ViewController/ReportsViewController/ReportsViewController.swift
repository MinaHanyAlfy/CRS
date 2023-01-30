//
//  ReportsViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import UIKit
import EmptyStateKit

class ReportsViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var timeVisitsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var comments : [String] = []
    private var reports: Reports = []{
        didSet {
            DispatchQueue.main.async { [self] in
                if reports.count > 0 && reports[0].serial != "NONE"  {
                    tableView.reloadData()
                } else {
                    tableView.setEmptyView(title: "You don't have any Visit.", message: "Check to add visit.")
                }
            }
        }
    }
    var isPM: Bool = false
    var timeVisit : String?{
        didSet{
            DispatchQueue.main.async {
                self.timeVisitsLabel.text = (self.timeVisit ?? "")+" Visits"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsAction()
        setupTableView()
    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpViews()
    }
    private func setupTableView() {
        tableView.registerCell(tableViewCell: ReportTableViewCell.self)
        if reports.count == 0 {
            tableView.setEmptyView(title: "You don't have any Visit.", message: "Check to add visit.")
        }
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setUpViews() {
        datePicker.backgroundColor = .white
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 12
        if isPM {
           title = "PM Reports"
        } else {
            title = "AM Reports"
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.titleView?.tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
//        let appearance = UINavigationBarAppearance()
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationItem.standardAppearance = appearance
        
    }
    
     private func buttonsAction() {
         sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
         addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    private func loadData() {
        let coredata = CoreDataManager.shared
        let user = coredata.getUserInfo()
        let date = "".todayDate
        if isPM {
            NetworkService.shared.getResultsStrings(APICase: .readPMVisits(level: user.level ?? "" , userId: coredata.getUserInfo().idEncoded ?? "" , reportDate: date), decodingModel: Reports.self) { response in
                switch response {
                case .success(let reports):
                    print("Reports: ",reports)
                case .failure(let error):
                    print("error: ",error)
                }
            }
        } else {
        
        NetworkService.shared.getResultsStrings(APICase: .readPMVisits(level: user.level ?? "" , userId: coredata.getUserInfo().idEncoded ?? "", reportDate: date), decodingModel: Reports.self) { response in
                switch response {
                case .success(let reports):
                    print("Reports: ",reports)
                case .failure(let error):
                    print("error: ",error)
                }
            }
        }
    }
    
    
}

//MARK: - Actions
extension ReportsViewController {
    @objc func sendAction() {
        guard let comment = commentTextField.text, comment.count > 3 else { return }
        comments.append(comment)
        tableView.reloadData()
    }
    @objc func addAction() {
        let vc = AddViewController()
        if isPM {
            vc.isPm = true
        }
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




//MARK: - UITableViewDataSource
extension ReportsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: ReportTableViewCell.self , forIndexPath: indexPath)
        cell.commentLabel.text = comments[indexPath.row]
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ReportsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: ", indexPath.row)
    }
}
