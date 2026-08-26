//
//  ObjectiveCExpenseAPIClient.swift
//  ExpenseTracker
//
//  Created by Apple on 25/08/26.
//

import Foundation

protocol ExpenseAPIClientProtocol {
    func fetchExpenses(
        from url: URL
    ) async throws -> [[String: Any]]
}


final class ObjectiveCExpenseAPIClient: ExpenseAPIClientProtocol {

    func fetchExpenses(
        from url: URL
    ) async throws -> [[String: Any]] {

        try await withCheckedThrowingContinuation { continuation in

            ExpenseTransformer.fetchAndTransformExpenses(
                from: url
            ) { expenses, error in

                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let expenses else {
                    continuation.resume(returning: [])
                    return
                }

                let swiftExpenses: [[String: Any]] = expenses.compactMap { expense in
                    Dictionary(
                        uniqueKeysWithValues: expense.compactMap { key, value in
                            guard let stringKey = key as? String else {
                                return nil
                            }

                            return (stringKey, value)
                        }
                    )
                }

                continuation.resume(returning: swiftExpenses)
            }
        }
    }
}
