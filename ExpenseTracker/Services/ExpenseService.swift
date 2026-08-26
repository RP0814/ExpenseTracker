//
//  ExpenseService.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import Foundation

final class ExpenseService {

    private let apiClient: ExpenseAPIClientProtocol
    private let transformsUsingObjectiveC: Bool

    init(
        apiClient: ExpenseAPIClientProtocol,
        transformsUsingObjectiveC: Bool = true
    ) {
        self.apiClient = apiClient
        self.transformsUsingObjectiveC = transformsUsingObjectiveC
    }

    convenience init() {

        self.init(
            apiClient: ObjectiveCExpenseAPIClient(),
            transformsUsingObjectiveC: false
        )
    }

    func fetchExpenses(from url: URL) async throws -> [Expense] {

        let expenses =
            try await apiClient.fetchExpenses(from: url)

        if transformsUsingObjectiveC {
            let transformedExpenses =
                ExpenseTransformer.transformExpenses(expenses)

            return ExpenseMapper.map(transformedExpenses)
        }

        return ExpenseMapper.map(expenses)
    }
}
