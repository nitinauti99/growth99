//
//  SocialLoginManager.swift
//  Social Login
//

import FBSDKLoginKit
import FBSDKCoreKit

class SocialLoginManager {
    
    static let shared = SocialLoginManager()
    private init() { }
    
    weak var vc: SocialProfilesListViewController?
    let loginManager = LoginManager()

    func loginWithFacebook(vc: SocialProfilesListViewController, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        self.vc = vc
        loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { [weak self] (result, error) in
            guard let self else { return }
            if let error {
                completion(false, error)
                return
            }
            
            completion(result?.isCancelled == false, nil)
            self.vc = nil
        }
    }
    
    func fetchProfile(completion: @escaping (Profile?, Error?) -> Void) {
        Profile.loadCurrentProfile { [weak self] (profile, error) in
            guard let self else { return }
            if error == nil {
                completion(profile, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
