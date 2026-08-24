//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import Foundation

struct Expense: Identifiable {
    let id: String
    let title: String
    let amount: Double
    let date: Date
}
