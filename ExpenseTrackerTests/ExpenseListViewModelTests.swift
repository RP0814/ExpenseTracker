//
//  ExpenseListViewModelTests.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 25/08/26.
//

import XCTest
@testable import ExpenseTracker

@MainActor
final class ExpenseListViewModelTests: XCTestCase {

    func testLoadExpensesSortsByDateDescending() async {
        let service = ExpenseService(
            apiClient: MockExpenseAPIClient()
        )

        let viewModel = ExpenseListViewModel(service: service)

        let url = URL(string: "https://example.com/expenses")!

        await viewModel.loadExpenses(from: url)

        XCTAssertEqual(viewModel.expenses.count, 2)
        XCTAssertEqual(viewModel.expenses[0].title, "Hotel")
        XCTAssertEqual(viewModel.expenses[1].title, "Flight to SF")
    }
}
