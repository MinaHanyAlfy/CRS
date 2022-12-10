//
//  ProspectionToolViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import UIKit

class ProspectionToolViewController: UIViewController {
    @IBOutlet weak var prospectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    private var selectedindex : [Int?] = [nil, nil, nil,nil,nil,nil,nil,nil,nil]
    private var questions = ["How Many Patients Were Waiting in Your First Visit ?","When was this first visit ?","How Many patients were waiting in your last visit ?","When Was this last visit ?","How did the nearest pharmacist describe the prospected customer ?", "What is the right discription of the prospected customer ?","How did the nearest pharmacist describe the prospected customer ?","How was his reply on asking for a commitment ?","Who suggested this prospect ?"]
    
    private var answers = [
        ["0-1 Patients","2-4 Patients","5 or more Patients"],
        ["By the begining or middle os the physisian's working day","By the end of the physisian's working day"],
        ["0-1 Patients","2-4 Patients","5 or more Patients"],
        ["By the begining or middle os the physisian's working day","By the end of the physisian's working day"],
        ["Not Potential" , "Potential","Very Potential"],
        ["Spesialist","Consultant","Professor"],
        ["Least likely will prescribes your product class","May shift to your products class","Already prescribing your product class"],
        ["Negative","Possitive"],
        ["EX-Customer","Exhibition or Medical Directories","Cold Canvassing or New Clinic","Peer or Colleague Referral","Center of influence (KOL)"]]
    
    
    private var answerDictionary : [Int:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.addTarget(self, action: #selector(sumbitAction), for: .touchUpInside)
        setupNavigation()
        setupTableView()
        setupView()
    }
    private func setupView() {
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 16
        
    }
    private func setupNavigation() {
        title = "Prospection Tool"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(tableViewCell: ProspectionTableViewCell.self)
    }
    
    @objc private func sumbitAction() {
        var isNil = false
        for i in selectedindex {
            if let _ = i { } else {
                isNil = true
            }
        }
        if isNil {
            self.alertIssues(message: "Please, Answer all questions.")
            return
        } else {
            print("all answers submit")
            //Send answers
        
        }
    }
}

//MARK: - UITableViewDataSource
extension ProspectionToolViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: ProspectionTableViewCell.self , forIndexPath: indexPath)
        cell.cellConfig(indexPath: indexPath,isSelect: selectedindex[indexPath.section] == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 8, y: 8, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = questions[section]
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "bluePrimary")
        label.numberOfLines = 0
        label.sizeToFit()
        headerView.addSubview(label)
        
        return headerView
    }
}

//MARK: - UITableViewDelegate
extension ProspectionToolViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedindex[indexPath.section] = indexPath.row
        tableView.reloadData()
    }
}
