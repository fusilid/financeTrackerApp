//
//  CategorySelectionViewController.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 12/8/24.
//

import UIKit

class CategorySelectionViewController: UITableViewController {
    
    var categories: [Category] = [.food, .utilities, .transportation]
    var didSelectCategory: ((Category) -> Void)?
    var transactionStore: TransactionStore? // Add this property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        didSelectCategory?(selectedCategory)
        
        // Perform segue to TransactionDetailsViewController
        performSegue(withIdentifier: "showTransactionDetails", sender: selectedCategory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransactionDetails" {
            if segue.destination is TransactionDetailsViewController {
                // Pass any data to the destination view controller here
            }
        }
    }
}
