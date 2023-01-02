//
//  KeyPersonTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-29.
//

import UIKit


protocol KeyPersonTableViewDelegate: AnyObject {
    func clearKeyPerson(keyPersons: Keys)
}
class KeyPersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clearKeyPersonButton: UIButton!
    @IBOutlet weak var keyPersonNameLabel: UILabel!
    
    public weak var delegate: KeyPersonTableViewDelegate?
    var index: Int?
    var keyPersons: Keys = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clearKeyPersonButton.addTarget(self, action: #selector(clearKeyPersonAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(keyPersons: Keys, index: Int) {
        self.keyPersons = keyPersons
        self.index = index
        let keyPerson = keyPersons[index]
        
        keyPersonNameLabel.text = keyPerson.keyPersonName
    }
    @objc private func clearKeyPersonAction() {
        guard let index = index else {
            return
        }
        
        keyPersons.remove(at: index)
        delegate?.clearKeyPerson(keyPersons: keyPersons)
    }
}


