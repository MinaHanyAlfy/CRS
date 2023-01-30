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
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(named: "bluePrimary")
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

