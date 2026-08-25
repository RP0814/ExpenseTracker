//
//  ExpenseMapperTests.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 24/08/26.
//

import XCTest
@testable import ExpenseTracker

@MainActor
final class ExpenseMapperTests: XCTestCase {

    func testMapValidDictionary() {
        let dictionaries: [[String: Any]] = [
            [
                "id": "1",
                "title": "Flight to SF",
                "amount": 230.50,
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let expenses = ExpenseMapper.map(dictionaries)

        XCTAssertEqual(expenses.count, 1)
        XCTAssertEqual(expenses[0].id, "1")
        XCTAssertEqual(expenses[0].title, "Flight to SF")
        XCTAssertEqual(expenses[0].amount, 230.50)
    }

    func testMapInvalidDictionarySkipsExpense() {
        let dictionaries: [[String: Any]] = [
            [
                "id": "1",
                "title": "Invalid Expense",
                "amount": "not-a-number",
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let expenses = ExpenseMapper.map(dictionaries)

        XCTAssertTrue(expenses.isEmpty)
    }
}
