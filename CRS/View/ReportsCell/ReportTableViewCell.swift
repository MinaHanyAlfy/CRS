//
//  ReportTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-11.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    let user = CoreDataManager.shared.getUserInfo()
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        stackView.frame = stackView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellConfig(report: ReportAM) {
        firstLabel.text = report.accountName
        secondLabel.text = report.fManagerDv
        if report.serial == "" {
            commentLabel.text = "Not Submitted Yet"
        } else {
            commentLabel.text = report.serial
        }
        
//        if report.fManagerDv == user.idDecoded || report.hManagerDv == user.idDecoded || report.mManagerDv == user.idDecoded {
        if report.dvReport != "" {
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 8
            stackView.layer.borderColor = UIColor.red.cgColor
//        }  else if  {}
        } else if report.serial != "" {
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 8
            stackView.layer.borderColor = UIColor.green.cgColor
        }
        else if report.serial == "" {
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 8
            stackView.layer.borderColor = UIColor.yellow.cgColor
        }
        
    }
    
    func cellConfig(report: ReportPM) {
        firstLabel.text = report.customerName
        secondLabel.text = report.fManagerDv
        if report.serial == "" {
            commentLabel.text = "Not Submitted Yet"
        } else {
            commentLabel.text = report.serial
        }
//        if report.fManagerDv == user.idDecoded || report.hManagerDv == user.idDecoded || report.mManagerDv == user.idDecoded {
        if report.dvReport != "" {
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 8
            stackView.layer.borderColor = UIColor.red.cgColor
//        }  else if  {}
        } else if report.serial != "" {
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 8
            stackView.layer.borderColor = UIColor.green.cgColor
        } else if report.serial == ""{
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 8
            stackView.layer.borderColor = UIColor.yellow.cgColor
        }
        
    }
}
