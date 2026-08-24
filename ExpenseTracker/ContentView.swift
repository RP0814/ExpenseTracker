//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

import SwiftUI

struct ContentView: View {

    @State private var viewModel = ExpenseListViewModel()

    private let expensesURL = URL(
        string: "https://www.jsonkeeper.com/b/DYZJF"
    )!

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Expenses")
        }
        .task {
            await viewModel.loadExpenses(from: expensesURL)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading expenses...")
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                "Unable to Load Expenses",
                systemImage: "exclamationmark.triangle",
                description: Text(errorMessage)
            )
        } else {
            expenseList
        }
    }

    private var expenseList: some View {
        List(viewModel.expenses) { expense in
            VStack(alignment: .leading, spacing: 6) {
                Text(expense.title)
                    .font(.headline)

                HStack {
                    Text(expense.amount, format: .currency(code: "USD"))

                    Spacer()

                    Text(expense.date, format: .dateTime)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    ContentView()
}
