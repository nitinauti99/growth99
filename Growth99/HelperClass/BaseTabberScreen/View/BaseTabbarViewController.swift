//
//  BaseTabbarViewController.swift
//  Growth99
//
//  Created by admin on 16/11/22.
//

import UIKit

class BaseTabbarViewController: UITabBarController, UITabBarControllerDelegate {

    var userNotifyString: [AnyHashable: Any] = [:]
    static private(set) var currentInstance: BaseTabbarViewController?

    var totalUnreadLead: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        BaseTabbarViewController.currentInstance = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadge), name: Notification.Name("updateBadge"), object: nil)

    }
    
    @objc func updateBadge(_ notification: Notification) {
        guard let segment = notification.userInfo?["totalUnreadLead"] as? Int else { return }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserRepository.shared.userVariableId = UserRepository.shared.userId ?? 0
        self.tabBar.items?[1].title = "Lead"
    }
  
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UserRepository.shared.userVariableId = UserRepository.shared.userId ?? 0

        if tabBarController.tabBar.selectedItem?.title == "Lead" {
            if let tabItems = tabBarController.tabBar.items {
                let tabItem = tabItems[1]
                tabItem.badgeValue = totalUnreadLead
            }
        }
     }
    
}
