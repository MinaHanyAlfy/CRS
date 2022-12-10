//
//  ReportsViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import UIKit

class ReportsViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeVisitsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var timeVisit : String?{
        didSet{
            DispatchQueue.main.async {
                self.timeVisitsLabel.text = (self.timeVisit ?? "")+" Visits"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(tableViewCell: ProspectionTableViewCell.self)
        // Do any additional setup after loading the view.
    }



}
//MARK: - UITableViewDataSource
extension ReportsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: ProspectionTableViewCell.self , forIndexPath: indexPath)
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension ReportsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: ", indexPath.row)
    }
}

