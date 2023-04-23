//
//  BaseTabbarViewController.swift
//  Growth99
//
//  Created by admin on 16/11/22.
//

import UIKit

class BaseTabbarViewController: UITabBarController {

    var userNotifyString: [AnyHashable: Any] = [:]
    static private(set) var currentInstance: BaseTabbarViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        BaseTabbarViewController.currentInstance = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserRepository.shared.userVariableId = UserRepository.shared.userId ?? 0
        self.tabBar.items?[1].title = "Lead"
    }

}
