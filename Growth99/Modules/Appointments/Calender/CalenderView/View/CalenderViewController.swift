//
//  CalendarViewController.swift
//  Growth99
//
//  Created by admin on 24/12/22.
//

import UIKit
import FSCalendar

protocol CalendarViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsReceived()
    func serviceListDataRecived()
    func providerListDataRecived()
    func appointmentListDataRecived()
}

func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}

struct MonthSection {
    var month: Date
    var headlines: [AppointmentDTOList]
    static func group(headlines: [AppointmentDTOList]) -> [MonthSection] {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormat.timeZone = TimeZone(identifier: UserRepository.shared.timeZone ?? "")
        let groups = Dictionary(grouping: headlines) { headline in
            firstDayOfMonth(date: dateFormat.date(from: headline.appointmentStartDate ?? String.blank) ?? Date())
        }
        return groups.map(MonthSection.init(month: headlines:))
    }
}

class CalendarViewController: UIViewController, CalendarViewContollerProtocol  {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventListView: UITableView!
    @IBOutlet var calendarscrollview: UIScrollView!
    @IBOutlet var calendarScrollViewHight: NSLayoutConstraint!
    
    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var providersTextField: CustomTextField!
    @IBOutlet private weak var addAppointmnetView: UIView!
    @IBOutlet private weak var calendarSegmentControl: UISegmentedControl!
    
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
    var calendarViewModel: CalendarViewModelProtocol?
    
    var eventTypeSelected: String = Constant.EventTypeSelected.upcoming.rawValue
    var sections = [MonthSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.select(Date())
        calendarViewModel = CalendarViewModel(delegate: self)
        self.calendar.scope = .month
        tableViewCellRegister()
        segementControlUI()
        addAppointmnetView.layer.cornerRadius = 10
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name("EventCreated"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        calendarSegmentControl.selectedSegmentIndex = 0
        eventTypeSelected = Constant.EventTypeSelected.upcoming.rawValue
        clincsTextField.text = ""
        providersTextField.text = ""
        servicesTextField.text = ""
        self.sections.removeAll()
        getClinicsData()
        scrollToTop(of: calendarscrollview, animated: true)
        eventListView.reloadData()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.Calendar
    }
    
    func scrollToTop(of scrollView: UIScrollView, animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -100)
        scrollView.setContentOffset(topOffset, animated: animated)
    }
    
    func getClinicsData() {
        self.view.ShowSpinner()
        calendarViewModel?.getallClinics()
    }
    
    var tableViewHeight: CGFloat {
        eventListView.layoutIfNeeded()
        return eventListView.contentSize.height
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        self.view.showToast(message: "Appoinment created successfully", color: UIColor().successMessageColor())
        guard let selectedClincIds = notification.userInfo?["clinicId"] as? String else { return }
        guard let selectedProvidersIds = notification.userInfo?["providerId"] as? String else { return }
        guard let selectedServicesIds = notification.userInfo?["serviceId"] as? String else { return }
        self.calendarViewModel?.getCalendarInfoList(clinicId: Int(selectedClincIds) ?? 0, providerId: Int(selectedProvidersIds) ?? 0, serviceId: Int(selectedServicesIds) ?? 0)
        eventListView.reloadData()
    }
    
    func tableViewCellRegister() {
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.eventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.eventsTableViewCell)
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.emptyEventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell)
    }
    
    func segementControlUI() {
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        return formatter
    }()
    
    func scrollViewHeight() {
        calendarScrollViewHight.constant = tableViewHeight + 800
    }
    
    func clinicsReceived() {
        selectedClincs = calendarViewModel?.getAllClinicsData ?? []
        allClinics = calendarViewModel?.getAllClinicsData ?? []
        self.calendarViewModel?.getServiceList()
    }
    
    func serviceListDataRecived() {
        selectedServices = calendarViewModel?.serviceData ?? []
        allServices = calendarViewModel?.serviceData ?? []
        let defaultService = ServiceList(createdAt: nil, updatedBy: nil, createdBy: nil, name: "All Services", id: nil, position: nil, serviceId: nil, serviceName: nil, categoryName: nil, categoryId: nil, updatedAt: nil)
        allServices.insert(defaultService, at: 0)
        self.view.HideSpinner()
    }
    
    func providerListDataRecived() {
        selectedProviders = calendarViewModel?.providerData ?? []
        allProviders = calendarViewModel?.providerData ?? []
        let defaultService = UserDTOList(id: nil, firstName: "All Providers", lastName: nil, gender: nil, profileImageUrl: nil, email: nil, phone: nil, designation: nil, description: nil, provider: nil)
        allProviders.insert(defaultService, at: 0)
        self.view.HideSpinner()
        eventListView.reloadData()
    }
    
    func appointmentListDataRecived() {
        self.view.HideSpinner()
        appoinmentListData = calendarViewModel?.appointmentInfoListData ?? []
        self.sections = MonthSection.group(headlines: self.appoinmentListData)
        self.sections.sort { lhs, rhs in lhs.month > rhs.month }
        self.eventListView.setContentOffset(.zero, animated: true)
        eventListView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func addAppointmentButtonAction(sender: UIButton) {
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as! AddEventViewController
        addEventVC.userSelectedDate = "Manual"
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @IBAction func CalendarSegmentSelection(_ sender: Any) {
        switch calendarSegmentControl.selectedSegmentIndex {
        case 0:
            eventTypeSelected = Constant.EventTypeSelected.upcoming.rawValue
            eventListView.reloadData()
        case 1:
            eventTypeSelected = Constant.EventTypeSelected.past.rawValue
            eventListView.reloadData()
        case 2:
            eventTypeSelected = Constant.EventTypeSelected.all.rawValue
            eventListView.reloadData()
        default:
            break;
        }
    }
}

extension CalendarViewController {
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({ $0.name ?? String.blank }).joined(separator: ", ")
            let selectedId = selectedList.map({ $0.id ?? 0 })
            self?.selectedClincs = selectedList
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
            cell.textLabel?.text = allServices.name
        }
        
        selectionMenu.setSelectedItems(items: selectedServices) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.servicesTextField.text = selectedList.map({ $0.name ?? String.blank }).joined(separator: ", ")
            let selectedId = selectedList.map({ $0.id ?? 0 })
            self?.selectedServices = selectedList
            self?.selectedServicesIds = selectedId
            self?.providersTextField.text = "Select Provider"
            self?.view.ShowSpinner()
            self?.calendarViewModel?.sendProviderList(providerParams: self?.selectedServicesIds.first ?? 0)
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
            cell.textLabel?.text = "\(allProviders.firstName ?? String.blank) \(allProviders.lastName ?? String.blank)"
        }
        
        selectionMenu.setSelectedItems(items: selectedProviders) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.providersTextField.text = "\(selectedItem?.firstName ?? String.blank) \(selectedItem?.lastName ?? String.blank)"
            let selectedId = selectedList.map({ $0.id ?? 0 })
            self?.selectedProviders = selectedList
            self?.selectedProvidersIds = selectedId
            self?.view.ShowSpinner()
            self?.calendarViewModel?.getCalendarInfoList(clinicId: self?.selectedClincIds.first ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceId: self?.selectedServicesIds.first ?? 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allProviders.count * 44))), arrowDirection: .up), from: self)
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        let storyboard = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil)
        guard let addEventVC = storyboard.instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as? AddEventViewController else {
            return
        }
        addEventVC.userSelectedDate = selectedDates.first ?? String.blank
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
}

extension CalendarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
}
