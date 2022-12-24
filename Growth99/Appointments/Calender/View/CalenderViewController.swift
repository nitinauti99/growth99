//
//  CalenderViewController.swift
//  Growth99
//
//  Created by admin on 24/12/22.
//

import UIKit
import FSCalendar
import EventKit
import EventKitUI

class CalenderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, EKEventEditViewDelegate {

    
    @IBOutlet private weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!

    let eventStore : EKEventStore = EKEventStore()
    var time = Date()

    private var menuVC = DrawerViewContoller()
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        setUpNavigationBar()
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.calendar.scope = .month
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    func setUpNavigationBar() {
        self.navigationItem.titleView = UIImageView.navigationBarLogo()
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(plusTapped), imageName: "sidemenu")

    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    @objc func plusTapped(_ sender: UIButton) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    
    // MARK:- UIGestureRecognizerDelegate
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        calendarViewHeightConstraint.constant = bounds.height + 40
        self.view.layoutIfNeeded()
    }
    
    internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.startDate = self.time
                    event.endDate = self.time
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.navigationItem.title = "Add Appointment"
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}
