//
//  ReportsViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet
class ReportsViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeVisitsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let coredata = CoreDataManager.shared
    private let user = CoreDataManager.shared.getUserInfo()
    private let network = NetworkService.shared
    private var comments : [String] = []
    private var reportsAM: ReportsAM = []{
        didSet {
            DispatchQueue.main.async { [self] in
                if reportsAM.count > 0 && reportsAM[0].serial != "NONE"  {
                    tableView.reloadData()
                } else {
                    if reportsAM.count == 1 && reportsAM[0].serial == "NONE" {
                        reportsAM.removeFirst()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    private var reportsPM: ReportsPM = []{
        didSet {
            DispatchQueue.main.async { [self] in
                if reportsPM.count > 0 && reportsPM[0].serial != "NONE"  {
                    tableView.reloadData()
                } else {
                    if reportsPM.count == 1 && reportsPM[0].serial == "NONE" {
                        reportsPM.removeFirst()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    private var visitingDay: VisitingDayResponse? {
        didSet {
            DispatchQueue.main.async {
                if self.visitingDay?[0].visitingDayStatus != "NONE" {
                    if self.visitingDay?[0].visitingDayComment != nil {
                        self.commentTextField.text = self.visitingDay?[0].visitingDayComment
                    }
                    if self.visitingDay?[0].visitingDayStatus == "reported" {
                        self.reportButton.backgroundColor = .gray
                        self.reportButton.setTitle("Sent", for: .normal)
                        self.reportButton.isEnabled = false
                    } else {
                        self.reportButton.backgroundColor = .systemPurple
                        self.reportButton.setTitle("Report", for: .normal)
                        self.reportButton.isEnabled = true
                    }
                } else {
                    self.reportButton.backgroundColor = .systemPurple
                    self.reportButton.setTitle("Report", for: .normal)
                    self.reportButton.isEnabled = true
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
        loadData()
        datePicker.backgroundColor = .white
        datePicker.contentVerticalAlignment = .center
        datePicker.contentHorizontalAlignment = .center
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        print(datePicker.date.updateDate)
        let date = datePicker.date.updateDate
        loadData(date: date)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpViews()
    }
    
    
    
    private func setupTableView() {
        tableView.registerCell(tableViewCell: ReportTableViewCell.self)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.emptyDataSetSource = self
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.allowsSelection = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressForDeleteVisit(sender:)))
        tableView.addGestureRecognizer(longPress)
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
    }
    
    private func buttonsAction() {
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    //MARK: - For Report Day -
    @IBAction func reportAction(_ sender: Any) {
        let alert = UIAlertController(title: "Report", message: "Report this day ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: { [self] alert in
            callingReport()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.sourceRect = self.reportButton.bounds
        alert.popoverPresentationController?.sourceView = self.reportButton
        self.present(alert, animated: true)
    }
    
    //MARK: - Delete Visit -
    @objc private func handleLongPressForDeleteVisit(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if isPM {
                    if reportsPM[indexPath.row].serial != "" {
                        SVProgressHUD.show()
                        deleteAction(serial: reportsPM[indexPath.row].serial ?? "")
                    }
                } else {
                    if reportsAM[indexPath.row].serial != "" {
                        SVProgressHUD.show()
                        deleteAction(serial: reportsAM[indexPath.row].serial)
                    }
                }
            }
        }
    }
}

//MARK: - Actions
extension ReportsViewController {
    
    //MARK: - Send Visiting Day Comment -
    @objc func sendAction() {
        guard let comment = commentTextField.text, comment.count > 3 else { return }
        let date = datePicker.date.updateDate
        if isPM {
            SVProgressHUD.show()
            network.getResultsStrings(APICase: .updatePMVisitingDayComment(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date, comment: comment.toBase64()), decodingModel: ResponseString.self) { resp in
                switch resp {
                case .success(let response):
                    self.updateCommentResponse(response: response)
                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.alertIssues(message: error.localizedDescription)
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            network.getResultsStrings(APICase: .updateAMVisitingDayComment(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date, comment: comment.toBase64()), decodingModel: ResponseString.self) { resp in
                switch resp {
                case .success(let response):
                    self.updateCommentResponse(response: response)
                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.alertIssues(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //MARK: - Add Visit -
    @objc func addAction() {
        let vc = AddViewController()
        if isPM {
            vc.isPm = true
        }
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Delete Visit -
    private func deleteAction(serial: String) {
        if isPM {
            network.getResultsStrings(APICase: .deletePMVisit(serial: serial), decodingModel: ResponseString.self) { result in
                switch result {
                case .success(let response):
                    self.deleteResponse(response: response)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    self.alertIssues(message: error.localizedDescription)
                }
            }
        } else {
            network.getResultsStrings(APICase: .deleteAMVisit(serial: serial), decodingModel: ResponseString.self) { result in
                switch result {
                case .success(let response):
                    self.deleteResponse(response: response)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    self.alertIssues(message: error.localizedDescription)
                }
            }
        }
      
    }
}

//MARK: - UITableViewDataSource -
extension ReportsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPM {
            return reportsPM.count
        }
        return reportsAM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: ReportTableViewCell.self , forIndexPath: indexPath)
        if isPM {
            cell.cellConfig(report: reportsPM[indexPath.row])
        } else {
            cell.cellConfig(report: reportsAM[indexPath.row])
        }
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension ReportsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: ", indexPath.row)
        let vc = AddViewController()
        if isPM {
            vc.isPm = true
            vc.reportPM = reportsPM[indexPath.row]
            vc.isOPenToUpdate = true
            
        } else {
            vc.reportAM = reportsAM[indexPath.row]
            vc.isOPenToUpdate = true
        }
        vc.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Data -
extension ReportsViewController {
    private func updateCommentResponse(response: String) {
        SVProgressHUD.dismiss()
        if response == "Done" {
            self.alertIssues(message: "Comment Updated")
        } else if response == "Reported_Day" {
            self.alertIssues(message: "Report already submitted and cannot be edited")
        } else {
            self.alertIssues(message: response)
        }
    }
    private func callingReport() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        let date = datePicker.date.updateDate
        if isPM {
            network.getResultsStrings(APICase: .reportPMVisitingDay(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: ResponseString.self) { resp in
                switch resp {
                case .success(let response):
                    DispatchQueue.main.async { [self] in
                        handleResponse(response: response)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.alertIssues(message: error.localizedDescription)
                    }
                }
            }
        } else {
            network.getResultsStrings(APICase: .reportAMVisitingDay(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: ResponseString.self) { resp in
                switch resp {
                case .success(let response):
                    DispatchQueue.main.async { [self] in
                        handleResponse(response: response)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.alertIssues(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func handleResponse(response: String) {
        SVProgressHUD.dismiss()
        if response == "Done" {
            self.alertSuccessAndDismissViewController(message: "Visiting Day Reported")
        } else if response == "No_Report" {
            self.alertIssues(message: "No Report Submitted")
        } else if response == "Not_Allowed" {
            self.alertSuccessAndDismissViewController(message: "Can not Report that old")
        } else {
            self.alertIssues(message: response)
        }
    }
    
    private func deleteResponse(response: String) {
        SVProgressHUD.dismiss()
        if response == "Deleted" {
            self.alertIssues(message: "Report deleted successfully")
            
        } else if response == "Reported_Day" {
            self.alertIssues(message: "Report already submitted and cannot be edited")
        } else {
            self.alertIssues(message: response)
        }
    }
    
    private func loadData(date: String) {
        SVProgressHUD.show()
        if isPM {
            network.getResults(APICase: .readPMVisits(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: ReportsPM.self) { response in
                switch response {
                case .success(let reports):
                    SVProgressHUD.dismiss()
                    self.reportsPM = reports
                    print("Reports: ",reports)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
            network.getResults(APICase: .readPMVisitingDay(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: VisitingDayResponse.self) { result in
                switch result {
                case .success(let response):
                    if response[0].visitingDayComment != nil {
                        self.visitingDay = response
                    }
                    
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
        } else {
            network.getResults(APICase: .readAMVisits(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: ReportsAM.self) { response in
                switch response {
                case .success(let reports):
                    SVProgressHUD.dismiss()
                    self.reportsAM = reports
                    print("Reports: ",reports)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
            network.getResults(APICase: .readAMVisitingDay(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: VisitingDayResponse.self) { result in
                switch result {
                case .success(let response):
                    if response[0].visitingDayComment != nil {
                        self.visitingDay = response
                    }
                    
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
        }
    }
    
    private func loadData() {
        SVProgressHUD.show()
        let date = "".todayDate
        if isPM {
            network.getResults(APICase: .readPMVisits(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: ReportsPM.self) { response in
                switch response {
                case .success(let reports):
                    SVProgressHUD.dismiss()
                    self.reportsPM = reports
                    print("Reports: ",reports)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
            network.getResults(APICase: .readPMVisitingDay(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: VisitingDayResponse.self) { result in
                switch result {
                case .success(let response):
                    if response[0].visitingDayComment != nil {
                        self.visitingDay = response
                    }
                    
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
        } else {
            network.getResults(APICase: .readAMVisits(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: ReportsAM.self) { response in
                switch response {
                case .success(let reports):
                    SVProgressHUD.dismiss()
                    self.reportsAM = reports
                    print("Reports: ",reports)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
            network.getResults(APICase: .readAMVisitingDay(level: user.level ?? "", userId: user.idEncoded ?? "", reportDate: date), decodingModel: VisitingDayResponse.self) { result in
                switch result {
                case .success(let response):
                    if response[0].visitingDayComment != nil {
                        self.visitingDay = response
                    }
                    
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("error: ",error)
                }
            }
        }
    }
}

//MARK: - DZNEmptyDataSetSource -
extension ReportsViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(systemName: "bell.fill")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let quote = "You don't have any Visit."
        let attributedQuote = NSMutableAttributedString(string: quote)
        return attributedQuote
    }
}
