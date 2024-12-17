//
//  FinanceTrackerViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 11/28/24.
//

import UIKit

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TransactionEntryDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var transactions: [Transaction] = []
    var transactionStore: TransactionStore?
    var currentCategory: Category?
    var currentAmount: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        loadTransactions()
        
        // Initialize and set images for buttons
        setupButtons()
    }

    func setupButtons() {
        let utilitiesButton = UIButton()
        utilitiesButton.setImage(UIImage(named: "utilitiesIcon"), for: .normal)

        let foodButton = UIButton()
        foodButton.setImage(UIImage(named: "foodIcon"), for: .normal)

        let transportationButton = UIButton()
        transportationButton.setImage(UIImage(named: "transportationIcon"), for: .normal)

        // Add buttons to the view or a stack view if needed
        // Example: self.view.addSubview(utilitiesButton)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        return transactions.filter { $0.category == category }.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let category = Category.allCases[indexPath.section]
        let transaction = transactions.filter { $0.category == category }[indexPath.row]
        
        let formattedAmount = formatAmount(transaction.cost)
        let formattedDate = formatDate(transaction.date)
        
        cell.textLabel?.text = "\(formattedAmount) - \(formattedDate)"
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Category.allCases[section].rawValue.capitalized
    }

    @IBAction func addTransaction(_ sender: UIButton) {
        let category: Category
        switch sender.tag {
        case 0:
            category = .food
        case 1:
            category = .utilities
        case 2:
            category = .transportation
        default:
            return
        }
        currentCategory = category
        presentAmountEntry(from: sender)
    }

    func presentAmountEntry(from sourceView: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let amountVC = storyboard.instantiateViewController(withIdentifier: "AmountEntryViewController") as! AmountEntryViewController
        amountVC.delegate = self
        amountVC.modalPresentationStyle = .popover
        
        if let popoverController = amountVC.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        present(amountVC, animated: true, completion: nil)
    }

    func presentDateEntry(from sourceView: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dateVC = storyboard.instantiateViewController(withIdentifier: "DateEntryViewController") as! DateEntryViewController
        dateVC.delegate = self
        dateVC.modalPresentationStyle = .popover
        
        if let popoverController = dateVC.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        // Dismiss the current view controller before presenting the new one
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.present(dateVC, animated: true, completion: nil)
            }
        } else {
            present(dateVC, animated: true, completion: nil)
        }
    }

    func didEnterAmount(_ amount: Double) {
        currentAmount = amount
        presentDateEntry(from: self.view)
    }

    func didEnterDate(_ date: Date) {
        if let category = currentCategory, let amount = currentAmount {
            let transaction = Transaction(date: date, cost: amount, category: category)
            transactions.append(transaction)
            saveTransactions()
            tableView.reloadData()
        }
    }

    func saveTransactions() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "transactions")
        }
    }

    func loadTransactions() {
        if let savedTransactions = UserDefaults.standard.object(forKey: "transactions") as? Data {
            let decoder = JSONDecoder()
            if let loadedTransactions = try? decoder.decode([Transaction].self, from: savedTransactions) {
                transactions = loadedTransactions
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = Category.allCases[indexPath.section]
        _ = transactions.filter { $0.category == category }[indexPath.row]
        // Present modals or popovers to edit the transaction
    }

    func displayTotal() {
        _ = transactions.reduce(0) { $0 + $1.cost }
        // Update UI with the total
    }

    // Helper methods to format amount and date
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    // Set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // Adjust the height as needed
    }
}

// Define the TransactionEntryDelegate protocol
protocol TransactionEntryDelegate: AnyObject {
    func didEnterAmount(_ amount: Double)
    func didEnterDate(_ date: Date)
}

