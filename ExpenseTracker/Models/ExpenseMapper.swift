//
//  ExpenseMapper.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import Foundation

enum ExpenseMapper {

    private static let dateFormatter = ISO8601DateFormatter()

    static func map(_ dictionaries: [[String: Any]]) -> [Expense] {
        dictionaries.compactMap { dictionary in
            guard
                let id = dictionary["id"] as? String,
                let title = dictionary["title"] as? String,
                let amount = dictionary["amount"] as? NSNumber,
                let dateString = dictionary["date"] as? String
            else {
                return nil
            }

            guard let date = dateFormatter.date(from: dateString) else {
                return nil
            }

            return Expense(
                id: id,
                title: title,
                amount: amount.doubleValue,
                date: date
            )
        }
    }
}
