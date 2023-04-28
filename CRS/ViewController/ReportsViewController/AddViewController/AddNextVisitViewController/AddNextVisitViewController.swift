//
//  AddNextVisitViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-27.
//

import UIKit


protocol AddNextVisitDelegate: AnyObject {
    func nextVisitTime(date: String)
    func nextVisitWithDate(date: Date)
}
class AddNextVisitViewController: UIViewController {

    @IBOutlet weak var majorView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    public weak var delegate: AddNextVisitDelegate?
    var planNextVisitWithDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        majorView.clipsToBounds = true
        majorView.layer.cornerRadius = 16
        buttonHandle()
        if let date = UserDefaults.standard.value(forKey: "visitingDayDate") as? String {
            if date != "" {
                datePickerView.date = DateFormatter().date(from: date) ?? Date()
                delegate?.nextVisitTime(date: date)
            }
        }
        if planNextVisitWithDate != nil {
            datePickerView.date = planNextVisitWithDate ?? Date()
        }
    }
    
    private func buttonHandle() {
        doneButton.addTarget(self, action: #selector(doneTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
    }
    
    @objc private func doneTap() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date: String = dateFormatter.string(from: datePickerView.date)
        print("Next Visit ", date)
        delegate?.nextVisitTime(date: date)
        delegate?.nextVisitWithDate(date: datePickerView.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelTap() {
        self.dismiss(animated: true, completion: nil)
    }

}


