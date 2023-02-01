//
//  CalenderViewController.swift
//  Growth99
//
//  Created by admin on 24/12/22.
//

import UIKit
import FSCalendar

protocol CalenderViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsReceived()
    func serviceListDataRecived()
    func providerListDataRecived()
    func appointmentListDataRecived()
}


func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month,.day], from: date)
    return calendar.date(from: components)!
}

struct MonthSection {

    var month : Date
    var headlines : [AppointmentDTOList]
    static func group(headlines : [AppointmentDTOList]) -> [MonthSection] {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let groups = Dictionary(grouping: headlines) { headline in
            firstDayOfMonth(date: dateFormat.date(from: headline.appointmentStartDate ?? String.blank) ?? Date())
        }
        return groups.map(MonthSection.init(month:headlines:))
    }
}


class CalenderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalenderViewContollerProtocol, FSCalendarDataSource, FSCalendarDelegate {
    
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
    
    @IBOutlet private weak var calenderSegmentControl: UISegmentedControl!
    
    var time = Date()
    var titles: [String] = []
    var startDates: [Date] = []
    var endDates: [Date] = []
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
    
    var eventTypeSelected: String = "upcoming"
    
    var sections = [MonthSection]()
    
    var tableViewHeight: CGFloat {
        eventListView.layoutIfNeeded()
        return eventListView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        calenderViewModel = CalenderViewModel(delegate: self)
        self.calendar.scope = .month
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.eventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.eventsTableViewCell)
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.emptyEventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell)
        addAppointmnetView.layer.cornerRadius = 10
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name("EventCreated"), object: nil)
        self.sections = MonthSection.group(headlines: self.appoinmentListData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        calenderSegmentControl.selectedSegmentIndex = 0
        eventTypeSelected = "upcoming"
        getClinicsData()
        eventListView.reloadData()
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        self.view.showToast(message: "Appoinment created sucessfully")
        guard let selectedClincIds = notification.userInfo?["clinicId"] as? String else { return }
        guard let selectedProvidersIds = notification.userInfo?["providerId"] as? String else { return }
        guard let selectedServicesIds = notification.userInfo?["serviceId"] as? String else { return }
        self.calenderViewModel?.getCalenderInfoList(clinicId: Int(selectedClincIds) ?? 0, providerId: Int(selectedProvidersIds) ?? 0, serviceId: Int(selectedServicesIds) ?? 0)
        eventListView.reloadData()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.calender
    }
    func getClinicsData() {
        self.view.ShowSpinner()
        calenderViewModel?.getallClinics()
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
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
        self.sections = MonthSection.group(headlines: self.appoinmentListData)
        self.sections.sort { lhs, rhs in lhs.month < rhs.month }
        eventListView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    @IBAction func calenderSegmentSelection(_ sender: Any) {
        switch calenderSegmentControl.selectedSegmentIndex {
        case 0:
            eventTypeSelected = "upcoming"
            eventListView.reloadData()
        case 1:
            eventTypeSelected = "past"
            eventListView.reloadData()
        case 2:
            eventTypeSelected = "all"
            eventListView.reloadData()
        default:
            break;
        }
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as! AddEventViewController
        addEventVC.userSelectedDate = selectedDates.first ?? String.blank
        let navController = UINavigationController(rootViewController: addEventVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navController, animated:true, completion: nil)
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
            cell.textLabel?.text = "\(allProviders.firstName ?? String.blank) \(allProviders.lastName ?? String.blank)"
        }
        
        selectionMenu.setSelectedItems(items: selectedProviders) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.providersTextField.text = "\(selectedItem?.firstName ?? String.blank) \(selectedItem?.lastName ?? String.blank)"
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
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let section = self.sections[section]
        let date = section.month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 5, y: 0, width: eventListView.frame.size.width, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = dateFormatter.string(from: date)
        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        if eventTypeSelected == "upcoming" {
            if (section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()}).count) == 0 {
                return 1
            } else {
                return section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()}).count
            }
        } else if eventTypeSelected == "past" {
            if (section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()}).count) == 0 {
                return 1
            } else {
                return section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()}).count
            }
        } else {
            if section.headlines.count == 0 {
                return 1
            } else {
                return section.headlines.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let headline = section.headlines[indexPath.row]
        if eventTypeSelected == "upcoming" {
            if (section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()}).count) == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
                cell.eventsTitle.text = "\(section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()})[indexPath.row].patientFirstName ?? String.blank) \(section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()})[indexPath.row].patientLastName ?? String.blank)"
                
                cell.eventsDateCreated.text = calenderViewModel?.serverToLocal(date: section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()})[indexPath.row].appointmentStartDate ?? String.blank)
                cell.eventsDate.setTitle(section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()})[indexPath.row].appointmentStartDate?.toDate()?.toString(), for: .normal)
                return cell
            }
        } else if eventTypeSelected == "past" {
            if (section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()}).count) == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
                cell.eventsTitle.text = "\(section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()})[indexPath.row].patientFirstName ?? String.blank) \(section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()})[indexPath.row].patientLastName ?? String.blank)"
                cell.eventsDateCreated.text = calenderViewModel?.serverToLocal(date: section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()})[indexPath.row].appointmentStartDate ?? String.blank)
                cell.eventsDate.setTitle(section.headlines.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()})[indexPath.row].appointmentStartDate?.toDate()?.toString(), for: .normal)
                return cell
            }
        } else {
            if section.headlines.count == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
                cell.eventsTitle.text = "\(headline.patientFirstName ?? String.blank) \(headline.patientLastName ?? String.blank)"
                cell.eventsDateCreated.text = calenderViewModel?.serverToLocal(date: headline.appointmentStartDate ?? String.blank)
                cell.eventsDate.setTitle(headline.appointmentStartDate?.toDate()?.toString(), for: .normal)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addAppointmentButtonAction(sender: UIButton) {
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as! AddEventViewController
        addEventVC.userSelectedDate = "Manual"
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
