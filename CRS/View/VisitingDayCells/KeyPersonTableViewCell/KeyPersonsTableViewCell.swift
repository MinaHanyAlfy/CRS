//
//  KeyPersonsTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-29.
//

import UIKit

protocol KeyPersonsTableViewDelegate: AnyObject {
    func getKeyPersons(keyPersons: Keys,comments: [String])
}
class KeyPersonsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addKeyPersonButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var keyPersons: Keys = []
    private var navigationController: UINavigationController?
    public weak var delegate: KeyPersonsTableViewDelegate?
    private var comments: [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        addKeyPersonButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        handleTableView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func handleTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(tableViewCell: KeyPersonTableViewCell.self)
    }
    @objc private func addAction() {
        print("addd")
        let vc = AddKeyPersonViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        navigationController?.present(vc, animated: true)
        
    }
    private func addKeyPerson(keyPerson: Key,comment: String) {
        self.keyPersons.append(keyPerson)
        self.comments.append(comment)
        tableView.reloadData()
        delegate?.getKeyPersons(keyPersons: self.keyPersons,comments: comments)
    }
    
}

//MARK: - AddPharmacyViewDelegate
extension KeyPersonsTableViewCell : AddKeyPersonViewrDelegate {
    func addKeyPersonObject(keyPerson: Key, comment: String) {
        addKeyPerson(keyPerson: keyPerson,comment: comment)
    }
}

//MARK: - UITableViewDataSource
extension KeyPersonsTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keyPersons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: KeyPersonTableViewCell.self, forIndexPath: indexPath)
        cell.config(keyPersons: keyPersons,index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension KeyPersonsTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - PharmacyTableViewDelegate
extension KeyPersonsTableViewCell: KeyPersonTableViewDelegate {
    func clearKeyPerson(keyPersons: Keys) {
        self.keyPersons = keyPersons
        tableView.reloadData()
    }
}




