//
//  Stub.swift
//  FargoNetwork
//
//  Created by SopanSharma on 2/9/21.
//

import Foundation

/// Controls how stub responses are returned.
public enum StubBehavior {

    /// Do not stub.
    case never

    /// Return a response immediately.
    case immediate

    /// Return a response after a delay.
    case delayed(seconds: TimeInterval)

    /// Return a response after a random delay b/w 1...5 sec.
    /// to mimic slow network
    case randomDelay
}

/// Used for stubbing responses.
public enum StubResponse {

    /// No stub response
    case none

    /**
     The network returned a response, including status code and data.

     Example:

         let testResponse = """
         {
             "name": "Johnny Appleseed"
         }
         """
         let behavior: StubBehavior = .immediate
         let jsonData = Data(testResponse.utf8)
         let response: StubResponse = .networkResponse(200, jsonData)

     OR

         let testResponse = ["name": "Johnny Appleseed"]
         let behavior: StubBehavior = .immediate
         let jsonData = try JSONSerialization.data(withJSONObject: testResponse, options: .fragmentsAllowed)
         let response: StubResponse = .networkResponse(200, jsonData)
     */
    case networkResponse(Int, Data)

    /**
     The network returned a response, including status code and json string.
     
     Example:

         let testResponse = """
         {
             "name": "Johnny Appleseed"
         }
         """
         let behavior: StubBehavior = .immediate
         let response: StubResponse = .networkJSONResponse(200, testResponse)
     */
    case networkJSONResponse(Int, String)

    /// The network returned response which can be fully customized.
    case response(HTTPURLResponse, Data)

    /// The network returned a response from an associated file with the given status code.
    /// The file should contain a json string
    case fileResponse(Int, URL)

    /// The network failed to send the request, or failed to retrieve a response (eg a timeout).
    case networkError(FargoNetworkError)
}

/// - Tag: Stub
public struct Stub {

    /// Property to control stub return behavior
    public let behavior: StubBehavior

    /// To set stub response 
    public let response: StubResponse

    public init(behavior: StubBehavior = .never, response: StubResponse = .none) {
        self.behavior = behavior
        self.response = response
    }

}

extension StubBehavior: Equatable {

    public static func == (lhs: StubBehavior, rhs: StubBehavior) -> Bool {
        switch (lhs, rhs) {
        case (let .delayed(lhsTime), let .delayed(rhsTime)):
            return lhsTime == rhsTime
        case (.immediate, .immediate):
            return true
        default:
            return false
        }
    }

}

extension StubResponse: Equatable {

    public static func == (lhs: StubResponse, rhs: StubResponse) -> Bool {
        switch (lhs, rhs) {
        case (let .networkResponse(lhsStatus, lhsData), let .networkResponse(rhsStatus, rhsData)):
            return lhsStatus == rhsStatus && lhsData == rhsData
        case (let .networkJSONResponse(lhsStatus, lhsString), let .networkJSONResponse(rhsStatus, rhsString)):
            return lhsStatus == rhsStatus && lhsString == rhsString
        case (let .response(lhsResponse, lhsData), let .response(rhsResponse, rhsData)):
            return lhsResponse == rhsResponse && lhsData == rhsData
        default:
            return false
        }
    }

}
