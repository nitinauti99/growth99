//
//  AppointmentsViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

protocol AppointmentsViewContollerProtocol: AnyObject {
    func profileAppoinmentsErrorReceived(error: String)
    func profileAppointmentsReceived()
    func profileAppoinmentsRemoved()
}

class AppointmentsViewController: UIViewController, AppointmentsViewContollerProtocol, ProfileAppointmentCellDelegate {
    func paymentProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath) {
        
    }
    
    @IBOutlet weak var appointmentsTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: AppointmentViewModelProtocol?
    var isSearch : Bool = false
    var appointmentsFilterData = [AppointmentListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AppointmentListViewModel(delegate: self)
        self.setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.appointmentTrigger
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        getProfileAppointments()
        registerTableView()
    }
    
    func registerTableView() {
        appointmentsTableView.delegate = self
        appointmentsTableView.dataSource = self
        appointmentsTableView.register(cellType: AppointmentTableViewCell.self)
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    @objc func getProfileAppointments() {
        
        self.view.ShowSpinner()
        viewModel?.getProfileApointmentsList()
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func profileAppointmentsReceived() {
        self.view.HideSpinner()
        DispatchQueue.main.async {
            self.appointmentsTableView.setContentOffset(.zero, animated: true)
            self.appointmentsTableView.reloadData()
        }
    }
    
    func profileAppoinmentsErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func profileAppoinmentsRemoved() {
        self.view.showToast(message: "Appointment Deleted Sucessfully", color: .black)
        viewModel?.getProfileApointmentsList()
    }
    
    func editProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath) {
        guard let editVC = UIViewController.loadStoryboard("AppointmentListDetailViewController", "AppointmentListDetailViewController") as? AppointmentListDetailViewController else {
            fatalError("Failed to load AppointmentListDetailViewController from storyboard.")
        }
        editVC.appointmentId = viewModel?.getProfileAppoinmentListData[index.row].id
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func removeProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath) {
        
        var appoinmentId = Int()
        appoinmentId = viewModel?.getProfileDataAtIndex(index: index.row)?.id ?? 0
        if isSearch {
            appoinmentId =  viewModel?.getProfileFilterDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getProfileDataAtIndex(index: index.row)?.patientFirstname ?? String.blank) \(viewModel?.getProfileDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeProfileAppoinment(appoinmentId: appoinmentId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func appointmentRemovedSuccefully(message: String) {
        self.getProfileAppointments()
    }
}

extension AppointmentsViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getProfileFilterData(searchText: searchText)
        isSearch = true
        appointmentsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        appointmentsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
