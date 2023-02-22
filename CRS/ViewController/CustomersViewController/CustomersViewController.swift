//
//  CustomersViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import UIKit
import DZNEmptyDataSet
class CustomersViewController: UIViewController {
  
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: CustomerTableViewCell.self)
        tableView.allowsSelection = false

        return tableView
    }()
    private let searchController : UISearchController = {
        let searchResultViewController = SearchResultViewController()
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "Search for Customer with zone"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    private let coreData = CoreDataManager.shared
    private var customers: Customers?{
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
        fetchCustomers()
        searchController.searchResultsUpdater = self
    }
    private func fetchCustomers () {
        customers = coreData.getCustomers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupNavigation() {
        navigationItem.title = "Customers"
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
        tableView.backgroundColor = .white
        tableView.emptyDataSetSource = self
    }
}

//MARK: - UISearchResultsUpdating
extension CustomersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        resultsController.isPm = true
        resultsController.customers = customers?.filter{ $0.customerName!.contains(query) } ?? []
    }
}

//MARK: - UITableViewDataSource
extension CustomersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: CustomerTableViewCell.self , forIndexPath: indexPath)
        guard let customer = customers?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.config(customer: customer)
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension CustomersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // DidSelect
    }
}

//MARK: - DZNEmptyDataSetSource -
extension CustomersViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(systemName: "bell.fill")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let quote = "You don't have any Customers."
        let attributedQuote = NSMutableAttributedString(string: quote)
        return attributedQuote
    }
}


