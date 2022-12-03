//
//  SideMenuViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var crsImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerCell(tableViewCell: SideMenuTableViewCell.self)
    }
}

//MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: SideMenuTableViewCell.self, forIndexPath: indexPath)
        cell.cellConfig(section: indexPath.section, index: indexPath.row)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return 1
        default:
            return 0
        }
    }
    

}

//MARK: - UITableViewDelegate
extension SideMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
       
        print( cell.sideMenuLabel.text)
    }
}
