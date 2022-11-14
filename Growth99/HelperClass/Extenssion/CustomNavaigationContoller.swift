//
//  NavaigationContoller.swift
//  FlickrAPIDemo
//
//  Created by Nitin Auti on 11/08/21.
//

import Foundation
import UIKit

public class CustomNavaigationContoller: UINavigationController {
    static private var window: UIWindow?
    static var RootViewController = UINavigationController()
    var window: UIWindow?
    var isUserLoged: Bool = false
    var drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 0.6 * (UIScreen.main.bounds.width))
    
    static func setRootViewController(ViewController: UIViewController){
        window = UIWindow(frame: UIScreen.main.bounds)
        RootViewController = UINavigationController(rootViewController: ViewController)
        window?.rootViewController = RootViewController
        window?.makeKeyAndVisible()
    }
    
    static func PushViewController(ViewController: UIViewController){
        RootViewController.pushViewController(ViewController, animated: true)
    }
    
    func setUpHomeVC() {
        if isUserLoged {
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
