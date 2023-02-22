//
//  SearchResultViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import DZNEmptyDataSet

class SearchResultViewController: UIViewController {
    
    var customers: Customers = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var accounts: Accounts = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var isPm: Bool = false
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: CustomerTableViewCell.self)
        tableView.registerCell(tableViewCell: AccountTableViewCell.self)
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
        tableView.emptyDataSetSource = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
    }
    
    
    
}

//MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(customers[indexPath.row])
    }
}

//MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPm {
            return customers.count
        }
        return accounts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: CustomerTableViewCell.self, forIndexPath: indexPath)
        if isPm {
            cell.config(customer: customers[indexPath.row])
        } else {
            cell.config(account: accounts[indexPath.row])
        }
        return cell
        
    }
    
    
}

//MARK: - DZNEmptyDataSetSource -
extension SearchResultViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(systemName: "bell.fill")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var quote = ""
        if isPm {
            quote = "You don't have any Customers"
        } else {
            quote = "You don't have any Accounts"
        }
        let attributedQuote = NSMutableAttributedString(string: quote)
        return attributedQuote
    }
}

