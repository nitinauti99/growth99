//
//  Authenticator.swift
//  FargoNetwork
//
//  Created by Arun on 10/8/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

/**
 Different states of an **Auth Token**
*/
/// - Tag: AuthTokenStateTag
public enum AuthTokenState {

    /**
     The auth token in valid.

     Ideally set, when the authenticator has successfully completed an auth request.
    */
    case tokenValid

    /**
     The auth token in being refreshed.

     Ideally set, when the authenticator is in the middle of performing a token [refresh](x-source-tag://TokenRefreshFunctionTag).
    */
    case tokenRefreshing

    /**
     The auth token has expired.

     Ideally set, when the authenticator has failed to complete an auth request or when a request has failed due to an expired auth token.
    */
    case tokenExpired

}

/// Protocol to provide APIs to reauth in an event of auth token expiry
/// - Tag: Authenticator
public protocol Authenticator {

    /**
     The [state](x-source-tag://AuthTokenStateTag) of the _Auth token_.
    
    */
    var authTokenState: AuthTokenState { get }

    /**
     Updates the token.
    
     - parameters:
         - completion: A closure which consists of a `Bool` indicating if the token refresh was successful and `[HTTPHeader]` which contains a list of updated [HTTPHeader](x-source-tag://HTTPHeaderTag).
    */
    /// - Tag: TokenRefreshFunctionTag
    func performTokenRefresh(completion: @escaping (Bool, [HTTPHeader]) -> Void)

}
