//
//  ProspectionTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-09.
//

import UIKit

class ProspectionTableViewCell: UITableViewCell {
    var answers = [
        ["0-1 Patients","2-4 Patients","5 or more Patients"],
        ["By the begining or middle os the physisian's working day","By the end of the physisian's working day"],
        ["0-1 Patients","2-4 Patients","5 or more Patients"],
        ["By the begining or middle os the physisian's working day","By the end of the physisian's working day"],
        ["Not Potential" , "Potential","Very Potential"],
        ["Spesialist","Consultant","Professor"],
        ["Least likely will prescribes your product class","May shift to your products class","Already prescribing your product class"],
        ["Negative","Possitive"],
        ["EX-Customer","Exhibition or Medical Directories","Cold Canvassing or New Clinic","Peer or Colleague Referral","Center of influence (KOL)"]]

    
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if self.isSelected{
//            radioImageView.image = UIImage(systemName: "circle.inset.filled")
//        } else {
//            radioImageView.image = UIImage(systemName: "circle")
//        }
    
        // Configure the view for the selected state
    }
    
    func cellConfig(indexPath: IndexPath,isSelect: Bool) {
        answerLabel.text = answers[indexPath.section][indexPath.row]
      
        radioImageView.image = isSelect ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle") ?? UIImage()
    
    }
    
}
