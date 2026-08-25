//
//  ExpenseTransformerTests.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 25/08/26.
//

import XCTest
@testable import ExpenseTracker

@MainActor
final class ExpenseTransformerTests: XCTestCase {

    func testTransformValidExpenses() {
        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": "Flight to SF",
                "amount": 230.50,
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed = ExpenseTransformer.transformExpenses(expenses)

        XCTAssertEqual(transformed.count, 1)
        XCTAssertEqual(transformed[0]["id"] as? String, "1")
        XCTAssertEqual(transformed[0]["title"] as? String, "Flight to SF")
        XCTAssertEqual((transformed[0]["amount"] as? NSNumber)?.doubleValue, 230.50)
        XCTAssertEqual(transformed[0]["date"] as? String, "2021-07-03T01:50:00+01:00")
    }

    func testTransformInvalidExpenseSkipsExpense() {
        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": "Invalid",
                "amount": "230.50",
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed = ExpenseTransformer.transformExpenses(expenses)

        XCTAssertTrue(transformed.isEmpty)
    }
}
