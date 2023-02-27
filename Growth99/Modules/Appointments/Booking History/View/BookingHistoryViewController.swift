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
    func appointmentRemovedSuccefully()
}

class BookingHistoryViewContoller: UIViewController, BookingHistoryViewContollerProtocol, BookingHistoryListTableViewCellDelegate {
    func removeBookingHistory(cell: BookingHistoryTableViewCell, index: IndexPath) {
    
    }
    
    func paymentBookingHistory(cell: BookingHistoryTableViewCell, index: IndexPath) {
        
    }
    
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
        viewModel?.getCalenderInfoListBookingHistory(clinicId: 0, providerId: 0, serviceId: 0)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func appointmentListDataRecivedBookingHistory() {
        self.view.HideSpinner()
        self.bookingHistoryTableView.setContentOffset(.zero, animated: true)
        self.bookingHistoryTableView.reloadData()
    }
    
    func errorReceivedBookingHistory(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func editAppointment(cell: BookingHistoryTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getBookingHistoryFilterDataAtIndex(index: index.row)?.id
            editVC.editBookingHistoryData = viewModel?.getBookingHistoryFilterDataAtIndex(index: index.row)
        } else {
            editVC.appointmentId = viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.id
            editVC.editBookingHistoryData = viewModel?.getBookingHistoryDataAtIndex(index: index.row)
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func removeAppointment(cell: BookingHistoryTableViewCell, index: IndexPath) {
        
        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.patientFirstName ?? String.blank) \(viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
//            self?.view.ShowSpinner()
//            let selectedBookingHistoryId = self?.viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.id ?? 0
//            self?.viewModel?.removeSelectedBookingHistory(bookingHistoryId: selectedBookingHistoryId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func appointmentRemovedSuccefully() {
        self.getBookingHistory()
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
}
