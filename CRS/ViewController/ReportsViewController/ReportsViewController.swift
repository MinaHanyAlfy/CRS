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
    
    private var comments : [String] = []
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
        tableView.registerCell(tableViewCell: ReportTableViewCell.self)
        // Do any additional setup after loading the view.
    }

    private func setupTableView() {
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
     private func buttonsAction() {
         sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
         addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
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

