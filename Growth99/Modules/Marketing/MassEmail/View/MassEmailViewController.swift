//
//  MassEmailViewController.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import Foundation
import UIKit

protocol MassEmailViewContollerProtocol: AnyObject {
    func errorReceivedMassEmail(error: String)
    func clinicsReceivedMassEmail()
    func serviceListDataRecivedMassEmail()
    func providerListDataRecivedMassEmail()
    func appointmentListDataRecivedMassEmail()
    func appointmentRemovedSuccefully()
}

class MassEmailViewController: UIViewController, MassEmailViewContollerProtocol, MassEmailListTableViewCellDelegate {
    
    func removeMassEmail(cell: MassEmailTableViewCell, index: IndexPath) {
    
    }
    
    func paymentMassEmail(cell: MassEmailTableViewCell, index: IndexPath) {
        
    }
    
    func clinicsReceivedMassEmail() {
        
    }
    
    func serviceListDataRecivedMassEmail() {
        
    }
    
    func providerListDataRecivedMassEmail() {
        
    }
    
    @IBOutlet weak var massEmailTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: MassEmailViewModelProtocol?
    var isSearch : Bool = false
    var massEmailFilterData = [AppointmentDTOList]()
    var massEmailListData = [AppointmentDTOList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MassEmailViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.emailSMSAudit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getMassEmail()
        self.registerTableView()
    }
    
    func registerTableView() {
        self.massEmailTableView.delegate = self
        self.massEmailTableView.dataSource = self
        massEmailTableView.register(UINib(nibName: "MassEmailTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailTableViewCell")
    }
    
    @objc func updateUI() {
        self.getMassEmail()
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
        self.getMassEmail()
    }
    
    @objc func getMassEmail() {
        self.view.ShowSpinner()
        viewModel?.getCalenderInfoListMassEmail(clinicId: 0, providerId: 0, serviceId: 0)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func appointmentListDataRecivedMassEmail() {
        self.view.HideSpinner()
        self.massEmailTableView.setContentOffset(.zero, animated: true)
        self.massEmailTableView.reloadData()
    }
    
    func errorReceivedMassEmail(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func editAppointment(cell: MassEmailTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getMassEmailFilterDataAtIndex(index: index.row)?.id
            //editVC.editMassEmailData = viewModel?.getMassEmailFilterDataAtIndex(index: index.row)
        } else {
            editVC.appointmentId = viewModel?.getMassEmailDataAtIndex(index: index.row)?.id
            //editVC.editMassEmailData = viewModel?.getMassEmailDataAtIndex(index: index.row)
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func removeAppointment(cell: MassEmailTableViewCell, index: IndexPath) {
        
        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getMassEmailDataAtIndex(index: index.row)?.patientFirstName ?? String.blank) \(viewModel?.getMassEmailDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
//            self?.view.ShowSpinner()
//            let selectedMassEmailId = self?.viewModel?.getMassEmailDataAtIndex(index: index.row)?.id ?? 0
//            self?.viewModel?.removeSelectedMassEmail(MassEmailId: selectedMassEmailId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func appointmentRemovedSuccefully() {
        self.getMassEmail()
    }
}

extension MassEmailViewController:  UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getMassEmailFilterData(searchText: searchText)
        isSearch = true
        massEmailTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        massEmailTableView.reloadData()
    }
}
