//
//  Transaction.swift
//  FinanceTracker
//
//  Created by D James Fusilier on 11/28/24.
//

import Foundation

struct Transaction: Codable {
    var date: Date
    var cost: Double
    var category: Category
}

enum Category: String, Codable, CaseIterable {
    case food
    case utilities
    case transportation
}
