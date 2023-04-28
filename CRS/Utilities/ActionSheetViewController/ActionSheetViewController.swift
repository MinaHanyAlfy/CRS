//
//  ActionSheetViewController.swift
//  CRS
//
//  Created by John Doe on 2023-04-20.
//  Copyright © 2023 ARK. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol ActionSheetDelegate {
    var dataSource: [SearchObject]? { get }
    func didSelectItem(at index: Int)
    func didSelectItem(with id: String)
}
class ActionSheetViewController: UIViewController, DZNEmptyDataSetSource {
    
    var delegate: ActionSheetDelegate?
    
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: CustomersTableViewCell.self)
        tableView.allowsSelection = true
        
        return tableView
    }()
    
    private let searchController : UISearchController = {
        let searchResultViewController = SearchResultViewController()
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "Search for Customer with zone"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    var viewTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        view.addSubview(tableView)
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupNavigation() {
        navigationItem.title = viewTitle ?? "Your Data"
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

//MARK: - UITableViewDataSource -
extension ActionSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomersTableViewCell", for: indexPath) as! CustomersTableViewCell
        cell.customerLabel.text = delegate?.dataSource?[indexPath.row].title
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate -
extension ActionSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true) {
            self.delegate?.didSelectItem(at: indexPath.row)
        }
    }
}

//MARK: - UISearchResultsUpdating
extension ActionSheetViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 1,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        resultsController.delegate = self
        resultsController.isStringSearch = true
        resultsController.objects = delegate?.dataSource?.filter{ $0.title.contains(query) } ?? []
    }
}

//MARK: -  -
extension ActionSheetViewController: SearchResultViewControllerDelegate {
     func getObject(searchObject: SearchObject) {
          self.delegate?.didSelectItem(with: searchObject.id)
     }
}
