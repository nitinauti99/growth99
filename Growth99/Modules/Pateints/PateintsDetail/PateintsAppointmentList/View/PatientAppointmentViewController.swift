//
//  PatientAppointmentViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation
import UIKit

protocol PatientAppointmentViewControllerProtocol: AnyObject {
    func patientAppointmentListDataRecived()
    func patientAppointmentDataRecived()
    func errorReceivedBookingHistory(error: String)
}

class PatientAppointmentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: PatientAppointmentViewModelProtocol?
    var pateintId = Int()
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getPatientsAppointmentList.count ?? 0)
        self.viewModel = PatientAppointmentViewModel(delegate: self)
        self.title = Constant.Profile.appointmentDetail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getPatientAppointmentsForAppointment(pateintId: pateintId)
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PatientAppointmentListTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientAppointmentListTableViewCell")
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
}

extension PatientAppointmentViewController: PatientAppointmentViewControllerProtocol {
    
    func patientAppointmentDataRecived() {
        viewModel?.getPatientAppointmentList(pateintId: pateintId)
    }
    
    func patientAppointmentListDataRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getPatientsAppointmentList.count ?? 0)
    }
    
    func errorReceivedBookingHistory(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension PatientAppointmentViewController: PatientAppointmentListTableViewCellDelegate{
    
    func editPatientAppointment(cell: PatientAppointmentListTableViewCell, index: IndexPath){
        if isSearch {
            let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
            let patientAppointmentListVM = viewModel?.patientListFilterListAtIndex(index: index.row)
            editVC.editBookingHistoryData = viewModel?.getPatientsForAppointments
            editVC.appointmentId  = patientAppointmentListVM?.id
            navigationController?.pushViewController(editVC, animated: true)
        }else{
            let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
            let patientAppointmentListVM = viewModel?.patientListAtIndex(index: index.row)
            editVC.editBookingHistoryData = viewModel?.getPatientsForAppointments
            editVC.appointmentId  = patientAppointmentListVM?.id
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
}
