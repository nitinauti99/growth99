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
    var leadViewModel: leadListViewModelProtocol?
    var appointmentViewModel: BookingHistoryViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        leadViewModel = leadListViewModel()
        leadViewModel?.getleadList(page: 0, size: 10, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
        appointmentViewModel = BookingHistoryViewModel()
        appointmentViewModel?.getCalendarInfoListBookingHistory(clinicId: 0, providerId: 0, serviceId: 0)
        BaseTabbarViewController.currentInstance = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadgeForLead), name: Notification.Name("updateBadgeForLead"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadgeForAppointMent), name: Notification.Name("updateBadgeForAppointment"), object: nil)
    }
    
    @objc func updateBadgeForLead(notification: Notification) {
        let segment = notification.userInfo?["totalUnreadCount"] as? Int
            if let tabItems = BaseTabbarViewController.currentInstance?.tabBar.items {
                let tabItem = tabItems[1]
                tabItem.badgeValue = String(segment ?? 0)
            }
    }
    
    @objc func updateBadgeForAppointMent(notification: Notification) {
        let segment = notification.userInfo?["totalUnreadCount"] as? Int
            if let tabItems = BaseTabbarViewController.currentInstance?.tabBar.items {
                let tabItem = tabItems[2]
                tabItem.badgeValue = String(segment ?? 0)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserRepository.shared.userVariableId = UserRepository.shared.userId ?? 0
        self.tabBar.items?[1].title = "Lead"
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           UserRepository.shared.userVariableId = UserRepository.shared.userId ?? 0
      }
}
