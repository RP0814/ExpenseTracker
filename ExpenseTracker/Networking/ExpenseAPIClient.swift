//
//  ExpenseAPIClient.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import Foundation

protocol ExpenseAPIClientProtocol {
    func fetchExpenses(
        from url: URL
    ) async throws -> [[String: Any]]
}

final class ExpenseAPIClient: ExpenseAPIClientProtocol {

    enum APIError: Error {
        case invalidResponse
        case invalidExpenseData
    }

    func fetchExpenses(
        from url: URL
    ) async throws -> [[String: Any]] {

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        let json = try JSONSerialization.jsonObject(with: data)

        guard let expenses = json as? [[String: Any]] else {
            throw APIError.invalidExpenseData
        }

        return expenses
    }
}
