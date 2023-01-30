//
//  PharmaciesTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit

protocol PharmaciesTableViewDelegate: AnyObject {
    func getPharmacies(pharmacies: Pharmacies,comments: [String])
}
class PharmaciesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addPharmacyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var pharmacies: Pharmacies = []
    private var comments: [String] = []
    private var navigationController: UINavigationController?
    public weak var delegate: PharmaciesTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addPharmacyButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        handleTableView()
    }
    
    func config(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(tableViewCell: PharmacyTableViewCell.self)
    }
    @objc private func addAction() {
        print("addd")
        let vc = AddPharmacyViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        navigationController?.present(vc, animated: true)
        
    }
    private func addPharmacy(pharmacy: Pharmacy,comment: String) {
        self.pharmacies.append(pharmacy)
        self.comments.append(comment)
        tableView.reloadData()
        delegate?.getPharmacies(pharmacies: pharmacies, comments: comments)
    }
}

//MARK: - AddPharmacyViewDelegate
extension PharmaciesTableViewCell : AddPharmacyViewDelegate {
    func addPharmacyObject(pharmacy: Pharmacy, comment: String) {
        
        addPharmacy(pharmacy: pharmacy,comment: comment)
        
    }
}

//MARK: - UITableViewDataSource
extension PharmaciesTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pharmacies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: PharmacyTableViewCell.self, forIndexPath: indexPath)
        cell.config(pharmacies: pharmacies,index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension PharmaciesTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - PharmacyTableViewDelegate
extension PharmaciesTableViewCell: PharmacyTableViewDelegate {
    func clearPharmacy(pharmacies: Pharmacies) {
        self.pharmacies = pharmacies
        tableView.reloadData()
    }   
}



