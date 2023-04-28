//
//  ProductsTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit


protocol ProductsTableViewDelegate: AnyObject {
    func getFirstProduct(product: Product)
    func getSecondProduct(product: Product)
    func getThirdProduct(product: Product)
    func getFourthProduct(product: Product)
}
class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var fourthProductTextField: UITextField!
    @IBOutlet weak var thirdProductTextField: UITextField!
    @IBOutlet weak var secondProductTextField: UITextField!
    @IBOutlet weak var firstProductTextField: UITextField!

    private var products: Products = []
    private var productsBack: Products = []
    private var firstPickerView = UIPickerView()
    private var secondPickerView = UIPickerView()
    private var thirdPickerView = UIPickerView()
    private var fourthPickerView = UIPickerView()
    private var firstProd: Product? {
        didSet {
            DispatchQueue.main.async {
                guard let prod = self.firstProd else { return }
                self.firstProductTextField.text = prod.productName
                self.delegate?.getFirstProduct(product: prod)
            }
        }
    }
    private var secondProd: Product? {
        didSet {
            DispatchQueue.main.async {
                guard let prod = self.secondProd else { return }
                self.secondProductTextField.text = prod.productName
                self.delegate?.getSecondProduct(product: prod)
            }
        }
    }
    private var thirdProd: Product? {
        didSet {
            DispatchQueue.main.async {
                guard let prod = self.thirdProd else { return }
                self.thirdProductTextField.text = prod.productName
                self.delegate?.getThirdProduct(product: prod)
            }
        }
    }
    private var fourthProd: Product? {
        didSet {
            DispatchQueue.main.async {
                guard let prod = self.fourthProd else { return }
                self.fourthProductTextField.text = prod.productName
                self.delegate?.getFourthProduct(product: prod)
            }
        }
    }
    public weak var delegate: ProductsTableViewDelegate?
    
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
        
        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let clearButton = UIBarButtonItem(title: "Clear Product 1", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.clearPicker))
        toolBar.setItems([clearButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        firstProductTextField.inputAccessoryView = toolBar
        secondProductTextField.inputAccessoryView = toolBar
        thirdProductTextField.inputAccessoryView = toolBar
        fourthProductTextField.inputAccessoryView = toolBar
    }
    

    
    func cellConfigToUpdate(isOpenToUpdate: Bool) {
        if isOpenToUpdate && products.count != 0 {
            let firstProd = UserDefaults.standard.value(forKey: "product1_ID") as? String
            let secondProd = UserDefaults.standard.value(forKey: "product2_ID") as? String
            let thirdProd = UserDefaults.standard.value(forKey: "product3_ID") as? String
            let fourthProd = UserDefaults.standard.value(forKey: "product4_ID") as? String
           
            if firstProd != nil && firstProd != "" && firstProd != "0" {
                self.firstProd = products.filter { $0.productID == firstProd }[0]
            }
            if secondProd != nil && secondProd != "" && secondProd != "0" {
                self.secondProd = products.filter { $0.productID == secondProd }[0]
            }
            
            if thirdProd != nil && thirdProd != "" && thirdProd != "0" {
                self.thirdProd = products.filter { $0.productID == thirdProd }[0]
            }
            if fourthProd != nil && fourthProd != "" && fourthProd != "0" {
                self.fourthProd = products.filter { $0.productID == fourthProd }[0]
            }
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clearPicker() {
        if firstProductTextField.isEditing {
            firstProductTextField.text = ""
            firstProductTextField.placeholder = "Product 1"
            delegate?.getFirstProduct(product: Product())
        } else if secondProductTextField.isEditing {
            secondProductTextField.text = ""
            secondProductTextField.placeholder = "Product 2"
            delegate?.getSecondProduct(product: Product())
        } else if thirdProductTextField.isEditing {
            thirdProductTextField.text = ""
            thirdProductTextField.placeholder = "Product 3"
            delegate?.getThirdProduct(product: Product())
        } else if fourthProductTextField.isEditing {
            fourthProductTextField.text = ""
            fourthProductTextField.placeholder = "Product 4"
            delegate?.getFourthProduct(product: Product())
        }
    }
}

    
//MARK: - UIPickerViewDelegate
extension ProductsTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case firstPickerView:
            firstProductTextField.text = products[row].productName ?? "Unknown"
            delegate?.getFirstProduct(product: products[row])
        case secondPickerView:
            secondProductTextField.text = products[row].productName ?? "Unknown"
            delegate?.getSecondProduct(product: products[row])
        case thirdPickerView:
            thirdProductTextField.text = products[row].productName ?? "Unknown"
            delegate?.getThirdProduct(product: products[row])
        case fourthPickerView:
            fourthProductTextField.text = products[row].productName ?? "Unknown"
            delegate?.getFourthProduct(product: products[row])
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
