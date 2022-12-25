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
       // authenticationWithTouchID()

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
    
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    message = "Authentication could not start because the device does not support biometric authentication."
                
                case LAError.biometryLockout.rawValue:
                    message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
                case LAError.biometryNotEnrolled.rawValue:
                    message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
                default:
                    message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
                case LAError.touchIDLockout.rawValue:
                    message = "Too many failed attempts."
                
                case LAError.touchIDNotAvailable.rawValue:
                    message = "TouchID is not available on the device"
                
                case LAError.touchIDNotEnrolled.rawValue:
                    message = "TouchID is not enrolled on the device"
                
                default:
                    message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
    
}

