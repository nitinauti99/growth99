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
        self.navigationItem.title = Constant.Profile.calender
    }
    
    @IBAction func dayViewAction(_ sender: Any) {
        remove_ViewController(childViewController: calenderViewController)
        add_DayViewController()
    }
    
    @IBAction func monthViewAction(_ sender: Any) {
        remove_ViewController(childViewController: dayViewController)
        add_WeekMonthViewController(calenderType: Constant.Profile.calenderDefault)
    }
    
    @IBAction func weekViewAction(_ sender: Any) {
        remove_ViewController(childViewController: calenderViewController)
        add_WeekMonthViewController(calenderType: Constant.Profile.calenderNotDefault)
    }
    
     func add_DayViewController() {
         let controller  = self.storyboard?.instantiateViewController(withIdentifier: Constant.ViewIdentifier.dailyViewController)as! DailyViewController
        controller.view.frame = self.view.bounds
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
        dayViewController = controller
    }
    
    func add_WeekMonthViewController(calenderType: String) {
        let controller  = self.storyboard?.instantiateViewController(withIdentifier: Constant.ViewIdentifier.calenderViewController)as! CalenderViewController
        controller.defaultCalender = calenderType
        controller.view.frame = self.view.bounds
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
        calenderViewController = controller
    }

    func remove_ViewController(childViewController: UIViewController?) {
        if childViewController != nil {
            if self.view.subviews.contains(childViewController!.view) {
                childViewController!.view.removeFromSuperview()
            }
        }
    }
}
