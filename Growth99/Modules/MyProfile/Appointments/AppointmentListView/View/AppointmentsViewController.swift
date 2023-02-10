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
        setUpNavigationBar()
    }

    func setUpNavigationBar() {
        self.title = Constant.Profile.appointmentTrigger
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        getProfileAppointments()
        registerTableView()
    }

    func registerTableView() {
        appointmentsTableView.delegate = self
        appointmentsTableView.dataSource = self
        appointmentsTableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointmentTableViewCell")
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
        appointmentsTableView.setContentOffset(.zero, animated: true)
        appointmentsTableView.reloadData()
    }

    func profileAppoinmentsErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }

    func editProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
//        editVC.editAppointmentsData = appointmentsListData[index.row]
        navigationController?.pushViewController(editVC, animated: true)
    }

    func removeProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath) {
        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getProfileAppoinmentDataAtIndex(index: index.row)?.patientFirstname ?? String.blank) \(viewModel?.getProfileAppoinmentDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.view.ShowSpinner()
            let pateintId = self?.viewModel?.getProfileAppoinmentDataAtIndex(index: index.row)?.id ?? 0
            //self?.viewModel?.removePateints(pateintId: pateintId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func appointmentRemovedSuccefully(message: String) {
        self.getProfileAppointments()
    }
}

extension AppointmentsViewController:  UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        appointmentsFilterData = (viewModel?.getProfileAppoinmentListData.filter { $0.patientFirstname?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        appointmentsTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        appointmentsTableView.reloadData()
    }
}
