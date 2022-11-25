//
//  AppDelegate.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isUserLoged: Bool = false
    let user = UserRepository.shared

    var drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 0.8 * (UIScreen.main.bounds.width))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if user.isUserLoged == true {
            openHomeView()
        } else {
            setUpHomeVC()
        }
//        UINavigationBar.appearance().tintColor = UIColor.init(hexString: "009EDE")
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().titleTextAttributes = textAttributes
        return true
    }

    func setUpHomeVC() {
        let LogInVC = UIStoryboard(name: "LogInViewController", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController")
        let mainVcIntial = UINavigationController(rootViewController:  LogInVC)
        mainVcIntial.isNavigationBarHidden = true
        self.window?.rootViewController = mainVcIntial
    }
    
    func openHomeView(){
        guard let tabbarController = UIViewController.loadStoryboard("BaseTabbar", "tabbarScreen") as? BaseTabbarViewController else {
            fatalError("Failed to load BaseTabbarViewController from storyboard.")
        }
        self.window?.rootViewController = tabbarController
    }
    
}

