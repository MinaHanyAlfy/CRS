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
    
    
    var q1: Int = 0, q2: Int = 0, q3: Int = 0, q4: Int = 0, q5: Int = 0, q6: Int = 0, q7: Int = 0, q8: Int = 0, q9: Int = 0
    var potScore: Int = 0 , prespScore: Int = 0
    
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
            
            var potString: String = ""
            var prepString: String = ""
            potScore = q2 + q4 + q5 + q6 + q9
            prespScore = q7 + q8
            
            if potScore < 21 { potString = "LOW" }
            if potScore > 20 && potScore < 36 { potString = "MEDIUM" }
            if potScore > 35 { potString = "HIGH" }
            if prespScore < 12 { prepString = "LOW" }
            if prespScore > 11 && prespScore < 20 { prepString = "MEDIUM" }
            if prespScore > 19 { prepString = "HIGH" }
            
            let alert = UIAlertController(title: "Score", message: "Your answers indicate \(potString) potentiality & \(prepString) prescription level.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                q1 = 2
                break
            }else if indexPath.row == 1 {
                q1 = 4
                break
            }else if indexPath.row == 2 {
                q1 = 6
                break
            }
            break
        case 1:
            if indexPath.row == 0{
                q2 = q1
                break
            }else if indexPath.row == 1 {
                q2 = q1+4
                break
            }
            break
        case 2:
            if indexPath.row == 0{
                q3 = 2
                break
            }else if indexPath.row == 1 {
                q3 = 4
                break
            }else if indexPath.row == 2 {
                q3 = 6
                break
            }
            break
        case 3:
            if indexPath.row == 0{
                q4 = q3
                break
            }else if indexPath.row == 1 {
                q4 = q3 + 4
                break
            }
            break
        case 4:
            if indexPath.row == 0{
                q5 = 2
                break
            }else if indexPath.row == 1 {
                q5 = 6
                break
            }else if indexPath.row == 2 {
                q5 = 10
                break
            }
            break
        case 5:
            if indexPath.row == 0{
                q6 = 6
                break
            }else if indexPath.row == 1 {
                q6 = 8
                break
            }else if indexPath.row == 2 {
                q6 = 10
                break
            }
            break
        case 6:
            if indexPath.row == 0{
                q7 = 2
                break
            }else if indexPath.row == 1 {
                q7 = 6
                break
            }else if indexPath.row == 2 {
                q7 = 10
                break
            }
            break
        case 7:
            if indexPath.row == 0{
                q8 = 2
                break
            }else if indexPath.row == 1 {
                q8 = 10
                break
            }
            break
        case 8:
            if indexPath.row == 0{
                q9 = 2
                break
            } else if indexPath.row == 1 {
                q9 = 4
                break
            } else if indexPath.row == 2 {
                q9 = 6
                break
            } else if indexPath.row == 3 {
                q9 = 8
                break
            } else if indexPath.row == 4 {
                q9 = 10
                break
            }
            break
        default:
            print("")
        }
    }
}

