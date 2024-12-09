//
//  TransactionDetailsViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 12/8/24.
//

import UIKit

class TransactionDetailsViewController: UIViewController {
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var selectedCategory: Category?
    var transactionStore: TransactionStore? // Add this property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }
    
    @IBAction func saveTransaction(_ sender: UIButton) {
        guard let amountText = amountTextField.text, let amount = Double(amountText),
              let dateText = dateTextField.text, let date = DateFormatter().date(from: dateText) else {
            // Handle invalid input
            return
        }
        
        // Save the transaction details
        if let category = selectedCategory {
            transactionStore?.createTransaction(date: date, cost: amount, category: category)
        }
        
        // Dismiss the view controller
        navigationController?.popViewController(animated: true)
    }
}
