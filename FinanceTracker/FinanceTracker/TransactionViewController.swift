//
//  FinanceTrackerViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 11/28/24.
//

import UIKit

class TransactionViewController: UITableViewController {
    
    var transactionStore = TransactionStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionStore.loadTransactions()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category(rawValue: sectionTitle(for: section))!
        return transactionStore.transactions(for: category).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let category = Category(rawValue: sectionTitle(for: indexPath.section))!
        let transaction = transactionStore.transactions(for: category)[indexPath.row]
        
        cell.textLabel?.text = "\(transaction.date): \(transaction.cost)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle(for: section)
    }
    
    private func sectionTitle(for section: Int) -> String {
        switch section {
        case 0: return Category.food.rawValue
        case 1: return Category.utilities.rawValue
        case 2: return Category.transportation.rawValue
        default: return ""
        }
    }
    
    @IBAction func addNewTransaction(_ sender: UIButton) {
        let categorySelectionVC = CategorySelectionViewController()
        categorySelectionVC.transactionStore = transactionStore // Pass the transactionStore
        categorySelectionVC.didSelectCategory = { [weak self] selectedCategory in
            self?.presentTransactionDetails(for: selectedCategory)
        }
        let navController = UINavigationController(rootViewController: categorySelectionVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func presentTransactionDetails(for category: Category) {
        let alertController = UIAlertController(title: "New Transaction", message: "Enter transaction details", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Cost"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let costText = alertController.textFields?.first?.text, let cost = Double(costText) {
                let date = Date()
                _ = self?.transactionStore.createTransaction(date: date, cost: cost, category: category)
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
