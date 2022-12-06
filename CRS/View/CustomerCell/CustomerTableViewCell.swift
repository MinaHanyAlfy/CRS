//
//  CustomerTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCell() {
        mapButton.clipsToBounds = true
        mapButton.layer.cornerRadius = 12
    }
    
    func cellConfig(index: Int, isAccount: Bool = false) {
        
        if isAccount {
            zoneLabel.isHidden = true
        }
    }
    
}
