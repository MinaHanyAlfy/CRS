//
//  AccountsViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import UIKit

class AccountsViewController: UIViewController {

    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: CustomerTableViewCell.self)
        return tableView
    }()
    private let searchController : UISearchController = {
        let searchResultViewController = SearchResultViewController()
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "Search for Account with zone"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private var accounts: Accounts?{
        didSet {
            DispatchQueue.main.async {
                [self] in
                tableView.reloadData()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        view.addSubview(tableView)
        fetchAccounts()
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupNavigation() {
        title = "Accounts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchAccounts () {
        let coreData = CoreDataManager.shared
        accounts = coreData.getAccounts()
    }
}
//MARK: - UISearchResultsUpdating
extension AccountsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        
        
    }
}

//MARK: - UITableViewDataSource
extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: CustomerTableViewCell.self , forIndexPath: indexPath)
        cell.cellConfig(index: indexPath.row, isAccount: true)
        guard let account = accounts?[indexPath.row] else { return UITableViewCell() }
        cell.config(account: account)
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: ", indexPath.row)
    }
}
