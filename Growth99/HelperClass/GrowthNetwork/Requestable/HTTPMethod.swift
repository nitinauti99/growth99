//
//  HTTPMethod.swift
//  FargoNetwork
//
//  Created by SopanSharma on 9/17/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

/**
    The request methods HTTP request are represented in the `HTTPMethod` enum
*/
/// - Tag: HTTPMethodTag
public enum HTTPMethod: String {

    /// The **CONNECT** method starts two-way communications with the requested resource.
    case CONNECT

    /// The **DELETE** method deletes the specified resource.
    case DELETE

    /// The **GET** method requests a representation of the specified resource. It should only retrieve data.
    case GET

    /// The **HEAD** method requests the headers that are returned if the specified resource would be requested with an HTTP GET method.
    case HEAD

    /// The **OPTIONS** method is used to describe the communication options for the target resource.
    case OPTIONS

    /// The **PATCH** method modifies the specified resource.
    case PATCH

    /// The **POST** method is used to submit an entity to the specified resource.
    case POST

    /// The **PUT** method replaces all current representations of the target resource with the request payload.
    case PUT

    /// THE ** TRACE** method performs a message loop-back test along the path to the target resource, providing a useful debugging mechanism.
    case TRACE

}
