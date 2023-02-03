//
//  BookingHistoryViewController.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import Foundation
import UIKit

protocol BookingHistoryViewContollerProtocol: AnyObject {
    func errorReceivedBookingHistory(error: String)
    func clinicsReceivedBookingHistory()
    func serviceListDataRecivedBookingHistory()
    func providerListDataRecivedBookingHistory()
    func appointmentListDataRecivedBookingHistory()
}

class BookingHistoryViewContoller: UIViewController, BookingHistoryViewContollerProtocol {
    func clinicsReceivedBookingHistory() {
        
    }
    
    func serviceListDataRecivedBookingHistory() {
        
    }
    
    func providerListDataRecivedBookingHistory() {
        
    }
    
    @IBOutlet weak var bookingHistoryTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: BookingHistoryViewModelProtocol?
    var isSearch : Bool = false
    var bookingHistoryFilterData = [AppointmentDTOList]()
    var bookingHistoryListData = [AppointmentDTOList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BookingHistoryViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.bookingHistory
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getBookingHistory()
        self.registerTableView()
    }
    
    func registerTableView() {
        self.bookingHistoryTableView.delegate = self
        self.bookingHistoryTableView.dataSource = self
        bookingHistoryTableView.register(UINib(nibName: "BookingHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingHistoryTableViewCell")
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

    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getBookingHistory()
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    @objc func getBookingHistory() {
        self.view.ShowSpinner()
        viewModel?.getCalenderInfoListBookingHistory(clinicId: 0, providerId: 0, serviceId: 0)
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
        self.bookingHistoryTableView.setContentOffset(.zero, animated: true)
        self.bookingHistoryTableView.reloadData()
    }
    
    func errorReceivedBookingHistory(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension BookingHistoryViewContoller:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bookingHistoryFilterData = (bookingHistoryListData.filter { $0.patientFirstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        isSearch = true
        bookingHistoryTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        bookingHistoryTableView.reloadData()
    }
}
