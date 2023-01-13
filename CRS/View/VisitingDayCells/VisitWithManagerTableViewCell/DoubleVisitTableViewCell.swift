//
//  DoubleVisitTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit


protocol DoubleVisitTableViewDelegate: AnyObject {
   func getManagerDoubleVisit(manager: Manager)
}
class DoubleVisitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var managersTextField: UITextField!
    public weak var delegate: DoubleVisitTableViewDelegate?
    private var pickerView = UIPickerView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    private var viewController: UIViewController?
    private var managers: Managers = []
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        pickerView.delegate = self
        pickerView.dataSource = self
        managersTextField.inputView = pickerView
        managers = CoreDataManager.shared.getManagers()
        // Configure the view for the selected state
    }
}

//MARK: - UIPickerViewDelegate
extension DoubleVisitTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        managersTextField.text = managers[row].name ?? "Unknown"
        delegate?.getManagerDoubleVisit(manager: managers[row])
    }
}

//MARK: - UIPickerViewDataSource
extension DoubleVisitTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return managers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return managers[row].name ?? "Unknown"
    }
    
    
}
