//
//  CustomersTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-26.
//

import UIKit

class CustomersTableViewCell: UITableViewCell {

    @IBOutlet weak var customerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func config(name: String) {
        customerLabel.text = name
    }
    
}
