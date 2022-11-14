//
//  EnvironmentManager.swift
//  Growth99
//
//  Created by nitin auti on 18/10/22.
//

import Foundation

/// BuildConfiguration handles the configuration taken from a Plist, that plist is loaded depending of the selected scheme
class EnvironmentManager: NSObject {
    // MARK: Variables
    
    /// Singleton instance
    static let sharedInstance = EnvironmentManager()
    
    /// Configuration taken from the plist
    var configs: NSDictionary!
    
    //MARK: Initializers
    /// Base initializer, loads the corresponding Plist to the configs var
    override init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config") as! String
        let path = Bundle.main.path(forResource: currentConfiguration, ofType: "plist")!
        configs = NSDictionary(contentsOfFile: path)
    }
}

// MARK: - EnvironmentManager Extension
extension EnvironmentManager {
    
    /// Returns the environment name
    ///
    /// - Returns: String environment name
    func environmentName() -> String {
        return configs.object(forKey: "environmentName") as! String
    }
    
    /// Returns the server runtime url
    ///
    /// - Returns: String runtime server url
    func baseUrl() -> String {
        return configs.object(forKey: "baseUrl") as! String
    }

}
