//
//  MockURLProtocol.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 25/08/26.
//

import Foundation

final class MockURLProtocol: URLProtocol, @unchecked Sendable {

    nonisolated(unsafe) static var requestHandler:
        ((URLRequest) throws -> (HTTPURLResponse, Data))?

    nonisolated(unsafe) static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(
        for request: URLRequest
    ) -> URLRequest {
        request
    }

    override func startLoading() {

        if let error = Self.error {
            client?.urlProtocol(
                self,
                didFailWithError: error
            )
            return
        }

        guard let handler = Self.requestHandler else {
            client?.urlProtocol(
                self,
                didFailWithError: TestURLProtocolError.handlerNotConfigured
            )
            return
        }

        do {
            let (response, data) = try handler(request)

            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )

            client?.urlProtocol(
                self,
                didLoad: data
            )

            client?.urlProtocolDidFinishLoading(self)

        } catch {
            client?.urlProtocol(
                self,
                didFailWithError: error
            )
        }
    }

    override func stopLoading() {
        // Nothing to clean up.
    }
}

enum TestURLProtocolError: Error {
    case handlerNotConfigured
}
