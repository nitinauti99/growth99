//
//  AppDelegate.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import UIKit
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isUserLoged: Bool = false
    let user = UserRepository.shared
    let mycontext: LAContext = LAContext()

    var drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 0.8 * (UIScreen.main.bounds.width))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setUpTabBarProperty()
        self.window = UIWindow()
        if user.isUserLoged == true {
            openHomeView()
        } else {
            setUpHomeVC()
        }
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
    
    func setUpTabBarProperty(){
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.white
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        //        UINavigationBar.appearance().tintColor = UIColor.init(hexString: "009EDE")
        //        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        UINavigationBar.appearance().titleTextAttributes = textAttributes
    }
    
    func authenticateWithBioMetrics(completion: @escaping (Bool) -> Void) {
        let authContext = LAContext()
        let localizedReasonString = "Identify yourself!"
        var authError: NSError?

        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) { // use & in front of authError to pass the error data back to authError variable
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReasonString) { (success, evalError) in
                if success {
                    DispatchQueue.main.async {
                        self.openHomeView()
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        guard let evalErrorString = evalError?.localizedDescription else { return }
                        self.alertUser(withMessage: evalErrorString)
                        completion(false)
                    }
                }
            }
        } else {
            guard let authErrorString = authError?.localizedDescription else { return }
            alertUser(withMessage: authErrorString)
            completion(false)
        }
    }
    
    func alertUser(withMessage message: String) {
        let alert = UIAlertController(title: "Authentication failed!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

