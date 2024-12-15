//
//  FinanceTrackerViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 11/28/24.
//
import UIKit

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var transactions: [Transaction] = []
    var transactionStore: TransactionStore? // Add this property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadTransactions()
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
        cell.textLabel?.text = "\(transaction.cost) - \(transaction.date)"
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
        presentTransactionEntry(for: category)
    }
    
    func presentTransactionEntry(for category: Category) {
        // Present modals or popovers for amount and date entry
        // Save the transaction once both fields are entered
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
        let transaction = transactions.filter { $0.category == category }[indexPath.row]
        // Present modals or popovers to edit the transaction
    }
    
    func displayTotal() {
        let total = transactions.reduce(0) { $0 + $1.cost }
        // Update UI with the total
    }
}
