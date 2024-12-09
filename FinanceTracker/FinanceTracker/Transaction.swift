//
//  Transaction.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 11/28/24.
//

import UIKit

enum Category: String, Codable {
    case food = "Food"
    case utilities = "Utilities"
    case transportation = "Transportation"
}

class Transaction: Codable {
    var date: Date
    var cost: Double
    var category: Category
    
    init(date: Date, cost: Double, category: Category) {
        self.date = date
        self.cost = cost
        self.category = category
    }
}
