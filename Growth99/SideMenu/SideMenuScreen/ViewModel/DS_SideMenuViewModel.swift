//
//  DS_SideMenuViewModel.swift
//  Dentsply Sirona
//
//  Created by sravangoud on 17/08/20.
//  Copyright © 2020 techouts. All rights reserved.
//

import Foundation

class DS_SideMenuViewModel: SideMenuRepository {

    var userPracticesList: UserPractices?

    func getuserRolesPractices(completion: @escaping (UserPractices?, Error?, URLResponse?) -> Void) {
        DS_SideMenuRemoteRepositoryPattern.getuserPractices { (response, error, status) in
            self.userPracticesList = response
            completion(response, error, status)
        }
    }

     func setuserRoleName(_ section: Int, row: Int) -> String {
    //        return categories![section].subCategories[row]
            return self.userPracticesList?.ecommerceAccounts?[row].name ?? ""
    }
        func numberofPractices(_ section: Int) -> Int {
    //        return categories![section].subCategories.count
            return self.userPracticesList?.ecommerceAccounts?.count ?? 0
        }
}
