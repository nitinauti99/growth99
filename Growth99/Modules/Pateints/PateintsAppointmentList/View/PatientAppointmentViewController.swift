//
//  PatientAppointmentViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation
import UIKit

protocol PatientAppointmentViewControllerProtocol: AnyObject {
    func errorReceivedBookingHistory(error: String)
    func clinicsReceivedBookingHistory()
    func serviceListDataRecivedBookingHistory()
    func providerListDataRecivedBookingHistory()
    func appointmentListDataRecivedBookingHistory()
}

class PatientAppointmentViewController: UIViewController, PatientAppointmentViewControllerProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: PatientAppointmentViewModelProtocol?
    var isSearch : Bool = false
    var bookingHistoryFilterData = [AppointmentDTOList]()
    var bookingHistoryListData = [AppointmentDTOList]()
    var pateintId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PatientAppointmentViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        self.title = Constant.Profile.appointmentDetail
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        viewModel?.getPatientAppointmentList(pateintId: pateintId)
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "PatientAppointmentViewController", bundle: nil), forCellReuseIdentifier: "PatientAppointmentViewController")
    }
    
    @objc func updateUI() {
        self.getBookingHistory()
        self.view.ShowSpinner()
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func clinicsReceivedBookingHistory() {
        
    }
    
    func serviceListDataRecivedBookingHistory() {
        
    }
    
    func providerListDataRecivedBookingHistory() {
        
    }

    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getBookingHistory()
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
     func getBookingHistory() {
        self.view.ShowSpinner()
        viewModel?.getPatientAppointmentList(pateintId: pateintId)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func appointmentListDataRecivedBookingHistory() {
        self.view.HideSpinner()
        bookingHistoryListData = viewModel?.appointmentInfoListDataBookingHistory ?? []
        bookingHistoryListData = bookingHistoryListData.sorted(by: { ($0.appointmentCreatedDate ?? "") > ($1.appointmentCreatedDate ?? "")})
        self.tableView.reloadData()
    }
    
    func errorReceivedBookingHistory(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension PatientAppointmentViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bookingHistoryFilterData = (bookingHistoryListData.filter { $0.patientFirstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        isSearch = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
