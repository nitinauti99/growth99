//
//  MassSMSViewController.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import Foundation
import UIKit

protocol MassSMSViewContollerProtocol: AnyObject {
    func errorReceivedMassSMS(error: String)
    func clinicsReceivedMassSMS()
    func serviceListDataRecivedMassSMS()
    func providerListDataRecivedMassSMS()
    func appointmentListDataRecivedMassSMS()
    func appointmentRemovedSuccefully()
}

class MassSMSViewController: UIViewController, MassSMSViewContollerProtocol, MassSMSListTableViewCellDelegate {
    func removeMassSMS(cell: MassSMSTableViewCell, index: IndexPath) {
    
    }
    
    func paymentMassSMS(cell: MassSMSTableViewCell, index: IndexPath) {
        
    }
    
    func clinicsReceivedMassSMS() {
        
    }
    
    func serviceListDataRecivedMassSMS() {
        
    }
    
    func providerListDataRecivedMassSMS() {
        
    }
    
    @IBOutlet weak var massSMSTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: MassSMSViewModelProtocol?
    var isSearch : Bool = false
    var massSMSFilterData = [AppointmentDTOList]()
    var massSMSListData = [AppointmentDTOList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MassSMSViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.emailSMSAudit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getMassSMS()
        self.registerTableView()
    }
    
    func registerTableView() {
        self.massSMSTableView.delegate = self
        self.massSMSTableView.dataSource = self
        massSMSTableView.register(UINib(nibName: "MassSMSTableViewCell", bundle: nil), forCellReuseIdentifier: "MassSMSTableViewCell")
    }
    
    @objc func updateUI() {
        self.getMassSMS()
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
        self.getMassSMS()
    }
    
    @objc func getMassSMS() {
        self.view.ShowSpinner()
        viewModel?.getCalenderInfoListMassSMS(clinicId: 0, providerId: 0, serviceId: 0)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func appointmentListDataRecivedMassSMS() {
        self.view.HideSpinner()
        self.massSMSTableView.setContentOffset(.zero, animated: true)
        self.massSMSTableView.reloadData()
    }
    
    func errorReceivedMassSMS(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func editAppointment(cell: MassSMSTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getMassSMSFilterDataAtIndex(index: index.row)?.id
//            editVC.editMassSMSData = viewModel?.getMassSMSFilterDataAtIndex(index: index.row)
        } else {
            editVC.appointmentId = viewModel?.getMassSMSDataAtIndex(index: index.row)?.id
//            editVC.editMassSMSData = viewModel?.getMassSMSDataAtIndex(index: index.row)
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func removeAppointment(cell: MassSMSTableViewCell, index: IndexPath) {
        
        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getMassSMSDataAtIndex(index: index.row)?.patientFirstName ?? String.blank) \(viewModel?.getMassSMSDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
//            self?.view.ShowSpinner()
//            let selectedMassSMSId = self?.viewModel?.getMassSMSDataAtIndex(index: index.row)?.id ?? 0
//            self?.viewModel?.removeSelectedMassSMS(MassSMSId: selectedMassSMSId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func appointmentRemovedSuccefully() {
        self.getMassSMS()
    }
}

extension MassSMSViewController:  UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getMassSMSFilterData(searchText: searchText)
        isSearch = true
        massSMSTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        massSMSTableView.reloadData()
    }
}
