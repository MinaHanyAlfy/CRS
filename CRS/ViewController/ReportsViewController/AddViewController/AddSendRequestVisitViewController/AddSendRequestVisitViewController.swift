//
//  AddSendRequestVisitViewController.swift
//  CRS
//
//  Created by John Doe on 2022-12-27.
//

import UIKit


protocol AddSendRequestVisitDelegate: AnyObject {
    func addDoubleVisitRequest(manager: Manager, message: String)
}
class AddSendRequestVisitViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var managerTextField: UITextField!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var recipentLabel: UILabel!
    @IBOutlet weak var majorView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var managers: Managers = []
    private var pickerView = UIPickerView()
    public weak var delegate: AddSendRequestVisitDelegate?
    
    private var manager: Manager?

    override func viewDidLoad() {
        super.viewDidLoad()

        majorView.clipsToBounds = true
        majorView.layer.cornerRadius = 18
        pickerViewHandle()
        buttonHandle()
        textViewHandle()
    }
    
    private func buttonHandle() {
        doneButton.addTarget(self, action: #selector(doneTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
    }
    private func pickerViewHandle() {
        pickerView.delegate = self
        pickerView.dataSource = self
        managerTextField.inputView = pickerView
        managers = CoreDataManager.shared.getManagers()
    }
    
    private func textViewHandle() {
        msgTextView.layer.borderWidth = 0.5
        msgTextView.layer.borderColor = UIColor(named: "bluePrimary")?.cgColor
        msgTextView.layer.cornerRadius = 8
        msgTextView.delegate = self
        if msgTextView.text.isEmpty {
            msgTextView.text = "Write your message."
            msgTextView.textColor = UIColor(named: "bluePrimary")
        }
    }
    

    @objc private func doneTap() {
        guard let manager = manager else {
            return
        }
        if msgTextView.text == "Write your message." {
            delegate?.addDoubleVisitRequest(manager: manager, message: "".toBase64())
        } else {
            let message = msgTextView.text ?? ""
            delegate?.addDoubleVisitRequest(manager: manager, message: message.toBase64())
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelTap() {
        self.dismiss(animated: true, completion: nil)
    }



}

//MARK: - UITextViewDelegate
extension AddSendRequestVisitViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        msgTextView.text = ""
        msgTextView.textColor = UIColor(named: "bluePrimary")
        }

    func textViewDidEndEditing(_ textView: UITextView) {
         if msgTextView.text.isEmpty {
             msgTextView.text = "Write your comment."
             msgTextView.textColor = UIColor(named: "bluePrimary")
         }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n"  // Recognizes enter key in keyboard
            {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}

//MARK: - UIPickerViewDelegate
extension AddSendRequestVisitViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        managerTextField.text = managers[row].name ?? "Unknown"
        self.manager = managers[row]
    }
}

//MARK: - UIPickerViewDataSource
extension AddSendRequestVisitViewController: UIPickerViewDataSource {
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

