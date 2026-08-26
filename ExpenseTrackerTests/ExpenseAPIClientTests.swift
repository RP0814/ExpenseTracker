//
//  ExpenseAPIClientTests.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 25/08/26.
//

import XCTest
@testable import ExpenseTracker

final class ExpenseAPIClientTests: XCTestCase {

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

    // MARK: - Success

    @MainActor
    func testFetchExpensesReturnsExpensesForSuccessfulResponse() async throws {

        let sut = ObjectiveCExpenseAPIClient()

        let json = """
        [
            {
                "id": "1",
                "title": "Flight to SF",
                "amount": 230.50,
                "date": "2021-07-03T01:50:00+01:00"
            }
        ]
        """

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: [
                    "Content-Type": "application/json"
                ]
            )!

            return (
                response,
                Data(json.utf8)
            )
        }

        let expenses = try await sut.fetchExpenses(
            from: testURL()
        )

        XCTAssertEqual(
            expenses.count,
            1
        )

        XCTAssertEqual(
            expenses[0]["id"] as? String,
            "1"
        )

        XCTAssertEqual(
            expenses[0]["title"] as? String,
            "Flight to SF"
        )

        XCTAssertEqual(
            (expenses[0]["amount"] as? NSNumber)?.doubleValue,
            230.50
        )

        XCTAssertEqual(
            expenses[0]["date"] as? String,
            "2021-07-03T01:50:00+01:00"
        )
    }

    // MARK: - HTTP Error

    @MainActor
    func testFetchExpensesThrowsForNonSuccessfulHTTPResponse() async {

        let sut = ObjectiveCExpenseAPIClient()

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

            _ = try await sut.fetchExpenses(
                from: testURL()
            )

            XCTFail(
                "Expected invalidResponse error"
            )

        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - Invalid JSON

    @MainActor
    func testFetchExpensesThrowsForInvalidJSON() async {

        let sut = ObjectiveCExpenseAPIClient()

        let invalidJSON = """
        This is not valid JSON
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

            _ = try await sut.fetchExpenses(
                from: testURL()
            )

            XCTFail(
                "Expected JSON parsing error"
            )

        } catch {

            XCTAssertTrue(
                error is DecodingError ||
                (error as NSError).domain == NSCocoaErrorDomain
            )
        }
    }

    // MARK: - Invalid Expense Data

    @MainActor
    func testFetchExpensesThrowsForInvalidExpenseStructure() async {

        let sut = ObjectiveCExpenseAPIClient()

        let json = """
        {
            "id": "1",
            "title": "Flight to SF"
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

            _ = try await sut.fetchExpenses(
                from: testURL()
            )

            XCTFail(
                "Expected invalidExpenseData error"
            )

        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - Network Error

    @MainActor
    func testFetchExpensesThrowsNetworkError() async {

        let sut = ObjectiveCExpenseAPIClient()

        MockURLProtocol.error = URLError(
            .notConnectedToInternet
        )

        do {

            _ = try await sut.fetchExpenses(
                from: testURL()
            )

            XCTFail(
                "Expected network error"
            )

        } catch {

            XCTAssertEqual(
                (error as? URLError)?.code,
                .notConnectedToInternet
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
