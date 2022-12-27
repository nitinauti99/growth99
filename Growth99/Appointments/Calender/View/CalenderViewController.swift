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

class CalenderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, EKEventEditViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet private weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventListView: UITableView!
    @IBOutlet private weak var eventListHeaderLabel: UILabel!
    
    let eventStore : EKEventStore = EKEventStore()
    var time = Date()
    var eventForDates: [EKEvent] = []
    var titles: [String] = []
    var startDates: [Date] = []
    var endDates: [Date] = []
    var filteredEvents: [EKEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
   
        setUpNavigationBar()
        
        self.calendar.select(Date())
        
        let formatingDate = getFormattedDate(date: Date(), format: "EEEE - MMM d")
        eventListHeaderLabel.text = formatingDate
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.eventListView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.calendar.scope = .month
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        eventListView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        
        fetchEventsFromCalendar()
    }
    
    func fetchEventsFromCalendar() -> Void {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
        case .notDetermined: requestAccessToCalendar("Calendar")
        case .authorized: fetchEventsFromCalendar("Calendar")
        case .denied: print("Access denied")
        default: break
        }
    }
    
    func requestAccessToCalendar(_ calendarTitle: String) {
        eventStore.requestAccess(to: EKEntityType.event) { (_, _) in
            self.fetchEventsFromCalendar(calendarTitle)
        }
    }
    
    func fetchEventsFromCalendar(_ calendarTitle: String) -> Void {
        for calendar in eventStore.calendars(for: .event) {
            if calendar.title == calendarTitle {
                let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
                let oneMonthAfter = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
                let predicate = eventStore.predicateForEvents(
                    withStart: oneMonthAgo,
                    end: oneMonthAfter,
                    calendars: [calendar]
                )
                eventForDates = eventStore.events(matching: predicate)
                eventListView.reloadData()
            }
        }
        // Print the event titles so check if everything works correctly
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "Calendar" 
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(plusTapped), imageName: "navImage")
    }
    
    @objc func plusTapped(_ sender: UIButton) {
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
                    eventController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.present(eventController, animated: true, completion: nil)
                    
                }
            }
        })
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
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.eventListView.contentOffset.y <= -self.eventListView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default: break
                
            }
        }
        return shouldBegin
    }
    
    
    internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        let formatingDate = getFormattedDate(date: calendar.selectedDate ?? Date(), format: "EEEE - MMM d")
        eventListHeaderLabel.text = formatingDate
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        let addEventVC = UIStoryboard(name: "AddEventViewController", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        let navController = UINavigationController(rootViewController: addEventVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navController, animated:true, completion: nil)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        if action.rawValue == 1 {
            fetchEventsFromCalendar()
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventForDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as? EventsTableViewCell else { fatalError("Unexpected Error") }
        cell.eventsTitle.text = eventForDates[indexPath.row].title
        cell.eventsDate.setTitle(getFormattedDate(date: eventForDates[indexPath.row].startDate, format: "dd"), for: .normal)
        return cell
    }
}
