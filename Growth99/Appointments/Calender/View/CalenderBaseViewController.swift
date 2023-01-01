//
//  CalenderBaseViewController.swift
//  Growth99
//
//  Created by admin on 01/01/23.
//

import UIKit

class CalenderBaseViewController: UIViewController {

    var dayViewController: DailyViewController?
    var calenderViewController: CalenderViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "Calendar"
//        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(plusTapped), imageName: "navImage")
    }
    
    
    @IBAction func dayViewAction(_ sender: Any) {
        remove_ViewController(dayViewController: calenderViewController)
        add_ViewController()
    }
    
    @IBAction func monthViewAction(_ sender: Any) {
        remove_ViewController(dayViewController: dayViewController)
        add_ViewControllerMonth()
    }
    
    @IBAction func weekViewAction(_ sender: Any) {
        remove_ViewController(dayViewController: calenderViewController)
        let controller  = self.storyboard?.instantiateViewController(withIdentifier: "CalenderViewController")as! CalenderViewController
        controller.defaultCalender = "Notdefault"
        controller.view.frame = self.view.bounds
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
        calenderViewController = controller
    }
    
     func add_ViewController() {
        let controller  = self.storyboard?.instantiateViewController(withIdentifier: "DailyViewController")as! DailyViewController
        controller.view.frame = self.view.bounds
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
        dayViewController = controller
    }
    
    func add_ViewControllerMonth() {
       let controller  = self.storyboard?.instantiateViewController(withIdentifier: "CalenderViewController")as! CalenderViewController
       controller.view.frame = self.view.bounds
       view.addSubview(controller.view)
       addChild(controller)
       controller.didMove(toParent: self)
       calenderViewController = controller
   }
    

    func remove_ViewController(dayViewController: UIViewController?) {
        if dayViewController != nil {
            if self.view.subviews.contains(dayViewController!.view) {
                dayViewController!.view.removeFromSuperview()
            }
        }
    }

}
