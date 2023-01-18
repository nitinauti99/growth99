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

class CalenderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalenderViewContollerProtocol{
    
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
    
    var tableViewHeight: CGFloat {
        eventListView.layoutIfNeeded()
        return eventListView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        calenderViewModel = CalenderViewModel(delegate: self)
        self.calendar.scope = .month
        let formatingDate = getFormattedDate(date: Date(), format: "EEEE - MMM d")
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.eventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.eventsTableViewCell)
        eventListView.register(UINib(nibName: Constant.ViewIdentifier.emptyEventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell)
        addAppointmnetView.layer.cornerRadius = 10
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        setupUI()
        getClinicsData()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.calender
    }
    
    func setupUI() {
        clincsTextField.text = String.blank
        servicesTextField.text = String.blank
        providersTextField.text = String.blank
        calenderSegmentControl.isEnabled = false
        calenderscrollview.setContentOffset(.zero, animated: true)
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
        calenderSegmentControl.isEnabled = true
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
        //        if eventTypeSelected == "past" && eventTypeSelected == "all" {
        //            return
        //        } else {
        return 1
        //        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventTypeSelected == "upcoming" {
            if (self.calenderViewModel?.appointmentListCountGreaterthan() ?? 0) == 0 {
                return 1
            } else {
                return self.calenderViewModel?.appointmentListCountGreaterthan() ?? 1
            }
        } else if eventTypeSelected == "past" {
            if (self.calenderViewModel?.appointmentListCountLessthan() ?? 0) == 0 {
                return 1
            } else {
                return self.calenderViewModel?.appointmentListCountLessthan() ?? 1
            }
        } else {
            if (self.calenderViewModel?.appointmentInfoListData.count ?? 0) == 0 {
                return 1
            } else {
                return self.calenderViewModel?.appointmentInfoListData.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if eventTypeSelected == "upcoming" {
            if (self.calenderViewModel?.appointmentListCountGreaterthan() ?? 0) == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
                cell.eventsTitle.text = "\(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientFirstName ?? String.blank) \(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientLastName ?? String.blank)"
                cell.eventsDate.setTitle(self.calenderViewModel?.appointmentInfoListData[indexPath.row].appointmentStartDate?.toDate()?.toString(), for: .normal)
                return cell
            }
        } else if eventTypeSelected == "past" {
            if (self.calenderViewModel?.appointmentListCountLessthan() ?? 0) == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
                cell.eventsTitle.text = "\(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientFirstName ?? String.blank) \(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientLastName ?? String.blank)"
                cell.eventsDate.setTitle(self.calenderViewModel?.appointmentInfoListData[indexPath.row].appointmentStartDate?.toDate()?.toString(), for: .normal)
                return cell
            }
        } else {
            if (self.calenderViewModel?.appointmentInfoListData.count ?? 0) == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {  return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
                cell.eventsTitle.text = "\(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientFirstName ?? String.blank) \(self.calenderViewModel?.appointmentInfoListData[indexPath.row].patientLastName ?? String.blank)"
                cell.eventsDate.setTitle(self.calenderViewModel?.appointmentInfoListData[indexPath.row].appointmentStartDate?.toDate()?.toString(), for: .normal)
                return cell
            }
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
