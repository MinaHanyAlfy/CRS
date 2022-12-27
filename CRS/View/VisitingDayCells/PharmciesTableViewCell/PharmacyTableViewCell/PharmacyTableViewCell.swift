//
//  PharmacyTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-27.
//

import UIKit


protocol PharmacyTableViewDelegate: AnyObject {
    func clearPharmacy(pharmacies: Pharmacies)
}
class PharmacyTableViewCell: UITableViewCell {

    @IBOutlet weak var clearPharmacyButton: UIButton!
    @IBOutlet weak var pharmacyNameLabel: UILabel!
    public weak var delegate: PharmacyTableViewDelegate?
    var index: Int?
    var pharmacies: Pharmacies = []
    override func awakeFromNib() {
        super.awakeFromNib()
        clearPharmacyButton.addTarget(self, action: #selector(clearPharmacyAction), for: .touchUpInside)
        
            
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(pharmacies: Pharmacies, index: Int) {
        self.pharmacies = pharmacies
        self.index = index
        let pharmacy = pharmacies[index]
        
        pharmacyNameLabel.text = pharmacy.pharmacyName
    }
    @objc private func clearPharmacyAction() {
        guard let index = index else {
            return
        }
        
        pharmacies.remove(at: index)
        delegate?.clearPharmacy(pharmacies: pharmacies)
    }
    
    
}
