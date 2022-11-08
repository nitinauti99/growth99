//
//  HomeViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 05/11/22.
//

import Foundation
import UIKit

class HomeViewContoller: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var dropDown: DropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        let BarButtonItem = UIBarButtonItem()
        BarButtonItem.customView = menuButton
        self.navigationItem.rightBarButtonItems = [BarButtonItem]
        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = ["Option 1", "Option 2", "Option 3", "Option 11", "Option 111", "Option 12", "Option 13"]
        // Its Id Values and its optional
        dropDown.optionIds = [1,23,54,22]
        dropDown.isSearchEnable = true

        // Image Array its optional
       // dropDown.ImageArray = [👩🏻‍🦳,🙊,🥞]

        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
          }
     
        
        //  UINavigationBar.appearance().backgroundColor = .green
        //  backgorund color with gradient
        //  or
        //  UINavigationBar.appearance().barTintColor = .green  // solid color
        //  UIBarButtonItem.appearance().tintColor = .magenta
        //  UINavigationBar.appearance().titleTextAttributes =        [NSAttributedString.Key.foregroundColor : UIColor.blue]
        //  UITabBar.appearance().barTintColor = .yellow
    }

//    @IBAction func menuPressed(){
//        appDel.drawerController.setDrawerState(.opened, animated: true)
//    }
    
    @objc func myTargetFunction(textField: UITextField) {
        print("touchDown for \(textField.tag)")
        dropDown?.showList()  // To show the Drop Down Menu

    }
    
    @objc func logoutUser(){
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
   @IBAction func openForgotPasswordView(){
        let forgotPasswordVC = UIStoryboard(name: "ForgotPasswordViewController", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
}

