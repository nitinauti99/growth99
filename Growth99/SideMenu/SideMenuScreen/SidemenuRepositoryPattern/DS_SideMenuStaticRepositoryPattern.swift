//
//  DS_SideMenuStaticRepositoryPattern.swift
//  Dentsply Sirona
//
//  Created by sravangoud on 17/08/20.
//  Copyright © 2020 techouts. All rights reserved.
//

import Foundation
var userRolesPractices =
[
    SideMenuDropdownList.init(userRole: "Manager At", userdesignation: "Alexa"),
    SideMenuDropdownList.init(userRole: "Manager At", userdesignation: "Danial")

]
protocol SideMenuRepository {
    func getuserRolesPractices(completion:@escaping(UserPractices?, Error?, URLResponse?) -> Void)
}

class DS_SideMenuStaticRepositoryPattern {
    // GET
    class func getuserRolesPractices(completion:@escaping(UserPractices?, Error?) -> Void) {
        completion(nil, nil)
    }

}
