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
    func patientAppointmentListDataRecived()
    func patientAppointmentDataRecived()
}

class PatientAppointmentViewController: UIViewController, PatientAppointmentViewControllerProtocol,
                                        PatientAppointmentListTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: PatientAppointmentViewModelProtocol?
    var isSearch : Bool = false
    var patientsAppointmentListFilterData = [PatientsAppointmentListModel]()
    var patientsAppointmentList = [PatientsAppointmentListModel]()
    var pateintId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PatientAppointmentViewModel(delegate: self)
        self.title = Constant.Profile.appointmentDetail
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        viewModel?.getPatientAppointmentsForAppointment(pateintId: pateintId)
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "PatientAppointmentListTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientAppointmentListTableViewCell")
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    func editPatientAppointment(cell: PatientAppointmentListTableViewCell, index: IndexPath){
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        let patientAppointmentListVM = viewModel?.patientListAtIndex(index: index.row)
        editVC.editBookingHistoryData = viewModel?.getPatientsForAppointments
        editVC.appointmentId  = patientAppointmentListVM?.id
        navigationController?.pushViewController(editVC, animated: true)
    }

    func getBookingHistory() {
        self.view.ShowSpinner()
        viewModel?.getPatientAppointmentList(pateintId: pateintId)
    }
    
    func patientAppointmentDataRecived() {
        viewModel?.getPatientAppointmentList(pateintId: pateintId)
    }
    
    
    func patientAppointmentListDataRecived() {
        self.view.HideSpinner()
        patientsAppointmentList = viewModel?.getPatientsAppointmentList ?? []
        self.tableView.reloadData()
    }
    
    func errorReceivedBookingHistory(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension PatientAppointmentViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        patientsAppointmentListFilterData = (patientsAppointmentList.filter { $0.patientName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        isSearch = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
