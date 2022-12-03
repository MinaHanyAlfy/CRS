//
//  UICollectionView+Extensions.swift
//  Beyond
//
//  Created by John Doe on 2022-11-25.
//

import UIKit

extension UICollectionView {
    func registerCell<cell: UICollectionViewCell>(collectionViewCell: cell.Type) {
        self.register(UINib(nibName: String(describing: collectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: collectionViewCell.self))
    }
    
    func deqeueReusableCell<cell: UICollectionViewCell>(collectionViewCell: cell.Type, indexPath: IndexPath) -> cell {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: collectionViewCell.self), for: indexPath) as! cell
    }
}

