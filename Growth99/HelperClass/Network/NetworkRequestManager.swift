//
//  NetworkRequestManager.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation
import Alamofire

class RequestManager: NetworkManager {

    override init(configuration: URLSessionConfiguration = .default, rootQueue: DispatchQueue? = nil, logger: Logger = OSLogger.shared, logSettings: LogSettings = .default, authenticator: Authenticator? = nil, pinningPolicy: PinningPolicy? = nil) {
        super.init(configuration: configuration, rootQueue: rootQueue, authenticator: authenticator, pinningPolicy: pinningPolicy)
    }

    convenience init() {
        self.init(configuration: .default)
    }
    
    func Headers()-> [HTTPHeader] {
        return [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .custom(key: "Content-Type", value: "application/json"),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? ""))]
     }
           
       /// sendding common header parameter from here
    func PublicHeaders()-> HTTPHeaders{
                  return ["Content-Type": "application/json"
           ] as HTTPHeaders
    }
}
