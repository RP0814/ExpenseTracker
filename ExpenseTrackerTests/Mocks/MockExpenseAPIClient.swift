//
//  MockExpenseAPIClient.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 25/08/26.
//

import Foundation
@testable import ExpenseTracker

@MainActor
final class MockExpenseAPIClient: ExpenseAPIClientProtocol {

    var expenses: [[String: Any]] = [
        [
            "id": "1",
            "title": "Flight to SF",
            "amount": 230.50,
            "date": "2021-07-03T01:50:00+01:00"
        ],
        [
            "id": "2",
            "title": "Hotel",
            "amount": 550.00,
            "date": "2021-08-03T01:50:00+01:00"
        ]
    ]

    func fetchExpenses(
        from url: URL
    ) async throws -> [[String: Any]] {
        expenses
    }
}
