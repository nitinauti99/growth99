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
        setUpHomeVC()
        return true
    }

    func setUpHomeVC() {
        
        if user.isUserLoged {
            let drawerViewController = UIStoryboard(name: "DrawerViewContoller", bundle: nil).instantiateViewController(withIdentifier: "Drawer")
            let mainViewController = UIStoryboard(name: "HomeViewContoller", bundle: nil).instantiateViewController(withIdentifier: "HomeViewContoller")
            
            let navController = UINavigationController(rootViewController: mainViewController)
            drawerController.mainViewController = navController
            drawerController.drawerViewController = drawerViewController
            self.window?.rootViewController = drawerController
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = drawerController
            window?.makeKeyAndVisible()
       
        }else{
            let LogInVC = UIStoryboard(name: "LogInViewController", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController")
            let mainVcIntial = UINavigationController(rootViewController:  LogInVC)
            mainVcIntial.isNavigationBarHidden = true
            self.window?.rootViewController = mainVcIntial
        }
        
    }
}

