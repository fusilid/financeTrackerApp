//
//  AmountEntryViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 12/15/24.
//

import UIKit

class AmountEntryViewController: UIViewController {
    @IBOutlet weak var amountTextField: UITextField!
    weak var delegate: TransactionEntryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.becomeFirstResponder()
    }

    @IBAction func enterAmount(_ sender: UIButton) {
        if let amountText = amountTextField.text, let amount = Double(amountText) {
            delegate?.didEnterAmount(amount)
            dismiss(animated: true, completion: nil)
        }
    }
}
