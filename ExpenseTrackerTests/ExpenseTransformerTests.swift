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

    override func setUp() {
        super.setUp()

        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.error = nil
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.error = nil

        URLProtocol.unregisterClass(MockURLProtocol.self)

        super.tearDown()
    }

    // MARK: - Existing Transformation

    func testTransformValidExpenses() {

        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": "Flight to SF",
                "amount": 230.50,
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertEqual(transformed.count, 1)

        XCTAssertEqual(
            transformed[0]["id"] as? String,
            "1"
        )

        XCTAssertEqual(
            transformed[0]["title"] as? String,
            "Flight to SF"
        )

        XCTAssertEqual(
            (transformed[0]["amount"] as? NSNumber)?.doubleValue,
            230.50
        )

        XCTAssertEqual(
            transformed[0]["date"] as? String,
            "2021-07-03T01:50:00+01:00"
        )
    }

    func testTransformInvalidAmountSkipsExpense() {

        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": "Invalid",
                "amount": "230.50",
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertTrue(transformed.isEmpty)
    }

    func testTransformInvalidIDSkipsExpense() {

        let expenses: [[String: Any]] = [
            [
                "id": 1,
                "title": "Invalid ID",
                "amount": 100.0,
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertTrue(transformed.isEmpty)
    }

    func testTransformInvalidTitleSkipsExpense() {

        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": 123,
                "amount": 100.0,
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertTrue(transformed.isEmpty)
    }

    func testTransformInvalidDateSkipsExpense() {

        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": "Invalid Date",
                "amount": 100.0,
                "date": 123
            ]
        ]

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertTrue(transformed.isEmpty)
    }

    func testTransformEmptyExpensesReturnsEmptyArray() {

        let expenses: [[String: Any]] = []

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertTrue(transformed.isEmpty)
    }

    func testTransformMixedExpensesReturnsOnlyValidExpenses() {

        let expenses: [[String: Any]] = [
            [
                "id": "1",
                "title": "Valid Expense",
                "amount": 100.0,
                "date": "2021-07-03T01:50:00+01:00"
            ],
            [
                "id": "2",
                "title": "Invalid Expense",
                "amount": "invalid",
                "date": "2021-07-03T01:50:00+01:00"
            ]
        ]

        let transformed =
            ExpenseTransformer.transformExpenses(expenses)

        XCTAssertEqual(transformed.count, 1)

        XCTAssertEqual(
            transformed.first?["id"] as? String,
            "1"
        )
    }

    // MARK: - Objective-C Fetch + Transform

    func testFetchAndTransformExpensesReturnsTransformedExpenses() async throws {

        let json = """
        [
            {
                "id": "1",
                "title": "Flight to SF",
                "amount": 230.50,
                "date": "2021-07-03T01:50:00+01:00"
            },
            {
                "id": "2",
                "title": "Hotel",
                "amount": 550.00,
                "date": "2021-08-03T01:50:00+01:00"
            }
        ]
        """

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (
                response,
                Data(json.utf8)
            )
        }

        let expenses =
            try await ExpenseTransformer.fetchAndTransformExpenses(
                from: testURL()
            )

        XCTAssertEqual(expenses.count, 2)

        XCTAssertEqual(
            expenses[0]["id"] as? String,
            "1"
        )

        XCTAssertEqual(
            expenses[0]["title"] as? String,
            "Flight to SF"
        )

        XCTAssertEqual(
            expenses[1]["id"] as? String,
            "2"
        )

        XCTAssertEqual(
            expenses[1]["title"] as? String,
            "Hotel"
        )

        XCTAssertEqual(
            (expenses[0]["amount"] as? NSNumber)?.doubleValue,
            230.50
        )
    }

    func testFetchAndTransformExpensesReturnsNetworkError() async {

        MockURLProtocol.error = URLError(
            .notConnectedToInternet
        )

        do {

            _ = try await ExpenseTransformer.fetchAndTransformExpenses(
                from: testURL()
            )

            XCTFail("Expected network error")

        } catch {

            XCTAssertEqual(
                (error as? URLError)?.code,
                .notConnectedToInternet
            )
        }
    }

    func testFetchAndTransformExpensesReturnsHTTPError() async {

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!

            return (
                response,
                Data()
            )
        }

        do {

            _ = try await ExpenseTransformer.fetchAndTransformExpenses(
                from: testURL()
            )

            XCTFail("Expected HTTP error")

        } catch {

            let nsError = error as NSError

            XCTAssertEqual(
                nsError.domain,
                "ExpenseAPIError"
            )

            XCTAssertEqual(
                nsError.code,
                500
            )
        }
    }

    func testFetchAndTransformExpensesReturnsInvalidJSONError() async {

        let invalidJSON = """
        This is invalid JSON
        """

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (
                response,
                Data(invalidJSON.utf8)
            )
        }

        do {

            _ = try await ExpenseTransformer.fetchAndTransformExpenses(
                from: testURL()
            )

            XCTFail("Expected invalid JSON error")

        } catch {

            XCTAssertNotNil(error)
        }
    }

    func testFetchAndTransformExpensesReturnsErrorForInvalidJSONStructure() async {

        let json = """
        {
            "id": "1",
            "title": "Invalid response"
        }
        """

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (
                response,
                Data(json.utf8)
            )
        }

        do {

            _ = try await ExpenseTransformer.fetchAndTransformExpenses(
                from: testURL()
            )

            XCTFail("Expected invalid structure error")

        } catch {

            let nsError = error as NSError

            XCTAssertEqual(
                nsError.domain,
                "ExpenseAPIError"
            )

            XCTAssertEqual(
                nsError.code,
                1003
            )
        }
    }

    // MARK: - Helpers

    private func testURL() -> URL {

        URL(
            string: "https://example.com/expenses"
        )!
    }
}
