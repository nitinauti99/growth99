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

protocol CalenderViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsReceived()
    func serviceListDataRecived()
    func providerListDataRecived()
    func appointmentListDataRecived()
}

class CalenderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, EKEventEditViewDelegate, UITableViewDelegate, UITableViewDataSource, CalenderViewContollerProtocol{

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventListView: UITableView!
    @IBOutlet var calenderscrollview: UIScrollView!
    @IBOutlet var calenderScrollViewHight: NSLayoutConstraint!

    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var providersTextField: CustomTextField!
    @IBOutlet private weak var addAppointmnetView: UIView!

    @IBOutlet private weak var upcomingEvent: UIButton!
    @IBOutlet private weak var pastEvent: UIButton!
    @IBOutlet private weak var allEvent: UIButton!

    let eventStore : EKEventStore = EKEventStore()
    var time = Date()
    var eventForDates: [EKEvent] = []
    var titles: [String] = []
    var startDates: [Date] = []
    var endDates: [Date] = []
    var filteredEvents: [EKEvent] = []
    var defaultCalender: String = Constant.Profile.calenderDefault
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    
    var allServices = [ServiceList]()
    var selectedServices = [ServiceList]()
    var selectedServicesIds = [Int]()
    
    var allProviders = [UserDTOList]()
    var selectedProviders = [UserDTOList]()
    var selectedProvidersIds = [Int]()
    
    var appoinmentListData = [AppointmentDTOList]()
    var calenderViewModel: CalenderViewModelProtocol?

    var tableViewHeight: CGFloat {
        eventListView.layoutIfNeeded()
        return eventListView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        self.calendar.select(Date())
        calenderViewModel = CalenderViewModel(delegate: self)

        let formatingDate = getFormattedDate(date: Date(), format: "EEEE - MMM d")
//        eventListHeaderLabel.text = formatingDate
        
        self.view.addGestureRecognizer(self.scopeGesture)
//        self.eventListView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        if defaultCalender == Constant.Profile.calenderDefault {
            self.calendar.scope = .month
        } else {
            self.calendar.scope = .week
        }
        
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.eventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.eventsTableViewCell)
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.emptyEventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell)
        addAppointmnetView.layer.cornerRadius = 10
        fetchEventsFromCalendar()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClinicsData()
    }
    
    func getClinicsData() {
        self.view.ShowSpinner()
        calenderViewModel?.getallClinics()
    }

    func setUpNavigationBar() {
        self.title = Constant.Profile.calender
    }
    
    func fetchEventsFromCalendar() -> Void {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
        case .notDetermined: requestAccessToCalendar(Constant.Profile.calender)
        case .authorized: fetchEventsFromCalendar(Constant.Profile.calender)
        case .denied: print(Constant.Profile.calenderAccessDenied)
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
    
    @objc func plusTapped(_ sender: UIButton) {
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.startDate = self.time
                    event.endDate = self.time
                    let eventController = EKEventEditViewController()
                    eventController.event = event
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
//        eventListHeaderLabel.text = formatingDate
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as! AddEventViewController
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
    
    func scrollViewHeight() {
        calenderScrollViewHight.constant = tableViewHeight + 800
    }
    
    func clinicsReceived() {
        selectedClincs = calenderViewModel?.getAllClinicsData ?? []
        allClinics = calenderViewModel?.getAllClinicsData ?? []
        self.calenderViewModel?.getServiceList()
    }
    
    func serviceListDataRecived() {
        selectedServices = calenderViewModel?.serviceData ?? []
        allServices = calenderViewModel?.serviceData ?? []
        self.view.HideSpinner()
    }
    
    func providerListDataRecived() {
        selectedProviders = calenderViewModel?.providerData ?? []
        allProviders = calenderViewModel?.providerData ?? []
        self.view.HideSpinner()
        eventListView.reloadData()
    }
    
    func appointmentListDataRecived() {
        self.view.HideSpinner()
        appoinmentListData = calenderViewModel?.appointmentInfoListData ?? []
        eventListView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    @IBAction func calenderButtonAction(sender: UIButton) {
        if sender.tag == 0 {
            upcomingEvent.backgroundColor = UIColor(hexString: "009EDE")
            upcomingEvent.titleLabel?.textColor = UIColor.white
            
            pastEvent.backgroundColor = UIColor.white
            pastEvent.titleLabel?.textColor = UIColor.black
            
            allEvent.backgroundColor = UIColor.white
            allEvent.titleLabel?.textColor = UIColor.black
            
        } else if sender.tag == 1 {
            
            upcomingEvent.backgroundColor = UIColor.white
            upcomingEvent.titleLabel?.textColor = UIColor.black
            
            pastEvent.backgroundColor = UIColor(hexString: "009EDE")
            pastEvent.titleLabel?.textColor = UIColor.white
            
            allEvent.backgroundColor = UIColor.white
            allEvent.titleLabel?.textColor = UIColor.black
        } else {
            
            upcomingEvent.backgroundColor = UIColor.white
            upcomingEvent.titleLabel?.textColor = UIColor.black
            
            pastEvent.backgroundColor = UIColor.white
            pastEvent.titleLabel?.textColor = UIColor.black
            
            allEvent.backgroundColor = UIColor(hexString: "009EDE")
            allEvent.titleLabel?.textColor = UIColor.white
            
        }
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincs  = selectedList
            self?.selectedClincIds = selectedId
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectServicesButtonAction(sender: UIButton) {
        if selectedServices.count == 0 {
            self.servicesTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allServices, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedServices) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.servicesTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServices  = selectedList
            self?.selectedServicesIds = selectedId
            self?.providersTextField.text = "Select Provider"
            self?.view.ShowSpinner()
            self?.calenderViewModel?.sendProviderList(providerParams: self?.selectedServicesIds.first ?? 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServices.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectProvidersButtonAction(sender: UIButton) {
        if selectedProviders.count == 0 {
            self.providersTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allProviders, cellType: .subTitle) { (cell, allProviders, indexPath) in
            cell.textLabel?.text = allProviders.firstName?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedProviders) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.providersTextField.text = selectedList.map({$0.firstName ?? ""}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedProviders  = selectedList
            self?.selectedProvidersIds = selectedId
            self?.view.ShowSpinner()
            self?.calenderViewModel?.getCalenderInfoList(clinicId: self?.selectedClincIds.first ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceId: self?.selectedServicesIds.first ?? 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allProviders.count * 44))), arrowDirection: .up), from: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.calenderViewModel?.appointmentInfoListData.count ?? 0) == 0 {
            return 1
        } else {
            return self.calenderViewModel?.appointmentInfoListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.calenderViewModel?.appointmentInfoListData.count ?? 0) == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
//            cell.eventsTitle.text = "\(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientFirstName ?? String.blank) \(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientLastName ?? String.blank)"
//            cell.eventsDate.setTitle(getFormattedDate(date: self.calenderViewModel?.appointmentInfoListData[indexPath.row].appointmentStartDate ?? Date(), format: "dd"), for: .normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    @IBAction func addAppointmentButtonAction(sender: UIButton) {
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as! AddEventViewController
        let navController = UINavigationController(rootViewController: addEventVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navController, animated:true, completion: nil)
    }
}


extension CalenderViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
}
