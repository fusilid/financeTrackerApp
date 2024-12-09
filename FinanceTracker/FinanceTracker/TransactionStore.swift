//
//  TransactionStore.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 11/28/24.
//

import UIKit

class TransactionStore {
    var transactions: [Transaction] = []
    
    private let transactionsKey = "transactions"
    
    init() {
        loadTransactions()
    }
    
    func createTransaction(date: Date, cost: Double, category: Category) -> Transaction {
        let transaction = Transaction(date: date, cost: cost, category: category)
        transactions.append(transaction)
        saveTransactions()
        return transaction
    }
    
    func loadTransactions() {
        let defaults = UserDefaults.standard
        if let savedTransactions = defaults.object(forKey: transactionsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedTransactions = try? decoder.decode([Transaction].self, from: savedTransactions) {
                transactions = loadedTransactions
            }
        }
    }
    
    func saveTransactions() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(transactions) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: transactionsKey)
        }
    }
    
    func transactions(for category: Category) -> [Transaction] {
        return transactions.filter { $0.category == category }
    }
    
    func totalCost(for category: Category? = nil) -> Double {
        if let category = category {
            return transactions(for: category).reduce(0) { $0 + $1.cost }
        } else {
            return transactions.reduce(0) { $0 + $1.cost }
        }
    }
}
