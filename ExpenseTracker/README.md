# ExpenseTracker

A small iOS expense viewer demonstrating a clean integration of Objective-C and Swift with SwiftUI.

## Requirements

- Fetch expense data from a remote JSON endpoint.
- Transform/validate the raw expense data using Objective-C.
- Map the transformed data into Swift models.
- Display expenses using SwiftUI.
- Sort expenses by date.
- Provide unit tests for the transformation and application flow.

## Architecture

```text
Remote JSON API
      |
      v
ExpenseAPIClient
      |
      v
ExpenseService
      |
      v
Objective-C ExpenseTransformer
      |
      v
ExpenseMapper
      |
      v
[Expense]
      |
      v
ExpenseListViewModel
      |
      v
Sort by date
      |
      v
SwiftUI ContentView

Project Structure

ExpenseTracker/
├── Models/
│   ├── Expense.swift
│   └── ExpenseMapper.swift
├── Networking/
│   └── ExpenseAPIClient.swift
├── ObjectiveC/
│   ├── ExpenseTransformer.h
│   ├── ExpenseTransformer.m
│   └── ExpenseTracker-Bridging-Header.h
├── Services/
│   └── ExpenseService.swift
├── ViewModels/
│   └── ExpenseListViewModel.swift
├── ContentView.swift
└── ExpenseTrackerApp.swift

ExpenseTrackerTests/
├── ExpenseMapperTests.swift
├── ExpenseTransformerTests.swift
├── ExpenseListViewModelTests.swift
└── Mocks/
    └── MockExpenseAPIClient.swift

Data Flow
ExpenseAPIClient performs the HTTP request and decodes the JSON response into Foundation dictionaries.
ExpenseService coordinates the data pipeline.
ExpenseTransformer validates and transforms the raw dictionaries using Objective-C.
ExpenseMapper converts the transformed dictionaries into the Swift Expense model.
ExpenseListViewModel loads the expenses and sorts them by date.
ContentView displays the resulting expenses using SwiftUI.
Testing

The project includes tests for:

Swift expense mapping.
Objective-C expense transformation.
Invalid expense data handling.
Expense loading.
Date-based sorting.
The service/view-model data flow using a mock API client.
API

The application consumes the provided JSON endpoint:

https://www.jsonkeeper.com/b/DYZJF


