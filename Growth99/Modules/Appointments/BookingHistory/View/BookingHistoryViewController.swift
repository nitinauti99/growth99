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
    func appointmentListDataRecivedBookingHistory()
    func appointmentRemovedSuccefully(message: String, status: Int)
}

class BookingHistoryViewContoller: UIViewController, BookingHistoryViewContollerProtocol {
    
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
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getBookingHistory()
    }
    
    @objc func getBookingHistory() {
        self.view.ShowSpinner()
        viewModel?.getCalendarInfoListBookingHistory(clinicId: 0, providerId: 0, serviceId: 0)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func appointmentListDataRecivedBookingHistory() {
        self.view.HideSpinner()
        self.bookingHistoryTableView.reloadData()
    }
    
    func errorReceivedBookingHistory(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension BookingHistoryViewContoller:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getBookingHistoryFilterData(searchText: searchText)
        isSearch = true
        bookingHistoryTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        bookingHistoryTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
