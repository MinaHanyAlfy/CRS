//
//  SearchResultViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    private var customers: Customers = []
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: CustomersTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpTableView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    
    
}

//MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(customers[indexPath.row])
    }
}

//MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: CustomersTableViewCell.self, forIndexPath: indexPath)
        
        cell.config(name: customers[indexPath.row].customerName ?? "Unknown")
        
        return cell
    }
    
    
}
