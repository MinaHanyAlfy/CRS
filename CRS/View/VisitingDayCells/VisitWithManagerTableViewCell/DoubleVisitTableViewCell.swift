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
    var isOPenToUpdate: Bool = false
    @IBOutlet weak var managersTextField: UITextField!
    public weak var delegate: DoubleVisitTableViewDelegate?
    private var pickerView = UIPickerView()
    private var updateManager: Manager? {
        didSet {
            DispatchQueue.main.async {
                self.updateDoubleVisitView()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        managersTextField.inputView = pickerView
        managers = CoreDataManager.shared.getManagers()
    }
    
    private var viewController: UIViewController?
    private var managers: Managers = []
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfigToUpdate(isOpenToUpdate: Bool,isPm: Bool = false) {
        if isOpenToUpdate && managers.count != 0 {
            
            let hId = UserDefaults.standard.value(forKey: "hManagerDv") as? String
            let mId = UserDefaults.standard.value(forKey: "mManagerDv") as? String
            let fId = UserDefaults.standard.value(forKey: "fManagerDv") as? String
            print("managers : ",managers)
            if hId != nil && hId != "" && hId != "0" {
                updateManager = managers.filter { $0.id == hId }[0]
            }
            
            if mId != nil && mId != "" && mId != "0" {
                updateManager = managers.filter { $0.id == mId }[0]
            }
            
            if fId != nil && fId != ""  && fId != "0" {
                updateManager = managers.filter { $0.id == fId }[0]
            }
        }
    }
    
    private func updateDoubleVisitView () {
        guard let updateManager = updateManager else { return }
        managersTextField.text = updateManager.name
        delegate?.getManagerDoubleVisit(manager: updateManager)
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
