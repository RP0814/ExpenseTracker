//
//  ExpenseListViewModel.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ExpenseListViewModel {

    private(set) var expenses: [Expense] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let service: ExpenseService

    init(service: ExpenseService) {
        self.service = service
    }

    convenience init() {
        self.init(service: ExpenseService())
    }

    func loadExpenses(from url: URL) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let fetchedExpenses = try await service.fetchExpenses(from: url)

            expenses = fetchedExpenses.sorted {
                $0.date > $1.date
            }
        } catch {
            errorMessage = "Unable to load expenses."
        }
    }
}
