//
//  CategorySelectionViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 12/8/24.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didDismissWithTransaction(amount: Double, date: Date, category: Category)
}

class CategorySelectionViewController: UIViewController, UITextFieldDelegate {
    
    var categories: [Category] = [.food, .utilities, .transportation]
    var transactionStore: TransactionStore?
    weak var delegate: CategorySelectionDelegate?
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure the text fields are connected
        guard amountTextField != nil, dateTextField != nil else {
            fatalError("Text fields are not connected")
        }
        
        // Set the delegate for amountTextField and dateTextField
        amountTextField.delegate = self
        amountTextField.keyboardType = .decimalPad
        dateTextField.delegate = self
        dateTextField.keyboardType = .numberPad
        dateTextField.placeholder = "DD-MM-YYYY"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let amountText = amountTextField.text, let amount = Double(amountText.replacingOccurrences(of: "$", with: "")),
              let dateText = dateTextField.text, let date = DateFormatter().date(from: dateText),
              let category = selectedCategory else {
            // Handle invalid input
            return
        }
        
        delegate?.didDismissWithTransaction(amount: amount, date: date, category: category)
    }
    
    // UITextFieldDelegate method to format the amountTextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            guard let text = textField.text else { return true }
            
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.currencySymbol = "$"
            
            if let number = numberFormatter.number(from: newText.replacingOccurrences(of: "$", with: "")) {
                let formattedText = numberFormatter.string(from: number)
                textField.text = formattedText
                return false
            }
            
            return true
        } else if textField == dateTextField {
            guard let text = textField.text else { return true }
            
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            if newText.count > 10 {
                return false
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if newText.count == 2 || newText.count == 5 {
                textField.text = newText + "-"
                return false
            }
            
            if newText.count == 10 {
                let components = newText.split(separator: "-")
                if components.count == 3,
                   let day = Int(components[0]), day >= 1 && day <= 31,
                   let month = Int(components[1]), month >= 1 && month <= 12,
                   let year = Int(components[2]), year > 0 {
                    return true
                } else {
                    textField.text = ""
                    let alert = UIAlertController(title: "Invalid Date", message: "Please enter a valid date:", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return false
                }
            }
            
            return true
        }
        
        return true
    }
}
