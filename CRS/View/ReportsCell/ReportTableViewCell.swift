//
//  ReportTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-11.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellConfig(report: Report) {
        firstLabel.text = report.serial
        secondLabel.text = report.accountName
    }
}
