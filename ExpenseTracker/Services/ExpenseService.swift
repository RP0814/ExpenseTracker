//
//  ExpenseService.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import Foundation

final class ExpenseService {

    private let apiClient: ExpenseAPIClientProtocol

    init(apiClient: ExpenseAPIClientProtocol) {
        self.apiClient = apiClient
    }

    convenience init() {
        self.init(apiClient: ExpenseAPIClient())
    }

    func fetchExpenses(from url: URL) async throws -> [Expense] {
        let rawExpenses = try await apiClient.fetchExpenses(from: url)

        let transformedExpenses =
            ExpenseTransformer.transformExpenses(rawExpenses)

        return ExpenseMapper.map(transformedExpenses)
    }
}
