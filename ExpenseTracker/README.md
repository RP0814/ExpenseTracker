# ExpenseTracker

A small iOS expense viewer demonstrating a clean integration of Objective-C and Swift with SwiftUI.

## Requirements

- Fetch expense data from a remote JSON endpoint.
- Transform and validate raw expense data using Objective-C.
- Map transformed data into Swift models.
- Display expenses using SwiftUI.
- Sort expenses by date.
- Provide unit tests for the transformation and application flow.

## Architecture

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
    Expense
          |
          v
    ExpenseListViewModel
          |
          v
    Sort by date
          |
          v
    SwiftUI ContentView

## Project Structure

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

## Data Flow

The application follows this data flow:

1. ExpenseAPIClient
   - Performs the HTTP request.
   - Decodes the JSON response into Foundation dictionaries.

2. ExpenseService
   - Coordinates the expense data pipeline.
   - Passes the raw data to the Objective-C transformer.
   - Passes transformed data to the Swift mapper.

3. ExpenseTransformer
   - Implemented in Objective-C.
   - Validates and transforms the raw expense dictionaries.
   - Filters invalid expense data.

4. ExpenseMapper
   - Implemented in Swift.
   - Converts transformed dictionaries into the Swift Expense model.

5. ExpenseListViewModel
   - Loads expenses from the service.
   - Sorts expenses by date in descending order.
   - Publishes the resulting expenses to the SwiftUI view.

6. ContentView
   - Displays the expenses using SwiftUI.

## Testing

The project includes unit tests covering:

- Swift expense mapping.
- Objective-C expense transformation.
- Invalid expense data handling.
- Expense loading.
- Date-based sorting.
- Service and view-model data flow using a mock API client.

## API

The application consumes the provided JSON endpoint:

https://www.jsonkeeper.com/b/DYZJF
