//
//  DateEntryViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 12/15/24.
//

import UIKit

class DateEntryViewController: UIViewController {
    @IBOutlet weak var dateTextField: UITextField!
    weak var delegate: TransactionEntryDelegate?

    private var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
        dateTextField.becomeFirstResponder()
    }

    @objc func dateChanged() {
        if let datePicker = datePicker {
            dateTextField.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .medium, timeStyle: .none)
        }
    }

    @IBAction func enterDate(_ sender: UIButton) {
        if let datePicker = datePicker {
            delegate?.didEnterDate(datePicker.date)
            dismiss(animated: true, completion: nil)
        }
    }
}
