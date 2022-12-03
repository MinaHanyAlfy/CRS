//
//  UITableView+Extensions.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import UIKit

extension UITableView {
    
    public func dequeue<cell: UITableViewCell>(tableViewCell: cell.Type) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: String(describing: tableViewCell.self)) as! cell
      }

      public func dequeue<cell: UITableViewCell>(tableViewCell: cell.Type, forIndexPath indexPath: IndexPath) -> cell {
    
          return self.dequeueReusableCell(withIdentifier: String(describing: tableViewCell.self), for: indexPath) as! cell
      }
    func registerCell<cell: UITableViewCell>(tableViewCell: cell.Type) {
        self.register(UINib(nibName: String(describing: tableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: tableViewCell.self))
    }
    
}
