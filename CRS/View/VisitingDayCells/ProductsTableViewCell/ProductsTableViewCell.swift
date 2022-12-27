//
//  ProductsTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var fourthProductTextField: UITextField!
    @IBOutlet weak var thirdProductTextField: UITextField!
    @IBOutlet weak var secondProductTextField: UITextField!
    @IBOutlet weak var firstProductTextField: UITextField!
    
    
    private var products: Products = []
    private var firstPickerView = UIPickerView()
    private var secondPickerView = UIPickerView()
    private var thirdPickerView = UIPickerView()
    private var fourthPickerView = UIPickerView()
    override func awakeFromNib() {
        super.awakeFromNib()
        products = CoreDataManager.shared.getProducts()
        handlePickerView()
    }
    
    private func handlePickerView() {
        firstProductTextField.inputView = firstPickerView
        secondProductTextField.inputView = secondPickerView
        thirdProductTextField.inputView = thirdPickerView
        fourthProductTextField.inputView = fourthPickerView
        
        firstPickerView.delegate = self
        firstPickerView.dataSource = self
        
        secondPickerView.delegate = self
        secondPickerView.dataSource = self
        
        thirdPickerView.delegate = self
        thirdPickerView.dataSource = self
        
        fourthPickerView.delegate = self
        fourthPickerView.dataSource = self
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

    
//MARK: - UIPickerViewDelegate
extension ProductsTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case firstPickerView:
            firstProductTextField.text = products[row].productName ?? "Unknown"
        case secondPickerView:
            secondProductTextField.text = products[row].productName ?? "Unknown"
        case thirdPickerView:
            thirdProductTextField.text = products[row].productName ?? "Unknown"
        case fourthPickerView:
            fourthProductTextField.text = products[row].productName ?? "Unknown"
        default:
            print("No Products added correct.")
        }
    }
}

//MARK: - UIPickerViewDataSource
extension ProductsTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return products.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return products[row].productName ?? "Unknown"
    }
    
    
}
