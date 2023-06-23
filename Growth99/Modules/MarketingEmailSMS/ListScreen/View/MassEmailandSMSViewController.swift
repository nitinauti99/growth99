//
//  MassEmailandSMSViewController.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol MassEmailandSMSViewContollerProtocol: AnyObject {
    func massEmailandSMSDataRecived()
    func errorReceived(error: String)
    func mailSMSDeletedSuccefully(message: String)
}

class MassEmailandSMSViewController: UIViewController, MassEmailandSMSViewContollerProtocol {
    
    @IBOutlet weak var massEmailandSMSTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var massEmailSMSSegmentControl: UISegmentedControl!
    
    var viewModel: MassEmailandSMSViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [MassEmailandSMSModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        getMassEmailandSMS()
        registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MassEmailandSMSViewModel(delegate: self)
        setUpNavigationBar()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }

    @objc func getMassEmailandSMS() {
        self.view.ShowSpinner()
        viewModel?.getMassEmailandSMS()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.massEmailSMS
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.massEmailandSMSDetailVC, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.massEmailandSMSDetailVC) as! MassEmailandSMSDetailViewController
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @IBAction func massEmailSMSSegmentSelection(_ sender: Any) {
        self.massEmailandSMSTableView.setContentOffset(.zero, animated: true)
        clearSearchBar()
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        massEmailandSMSTableView.reloadData()
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Constant.Profile.searchList
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.massEmailandSMSTableView.delegate = self
        self.massEmailandSMSTableView.dataSource = self
        massEmailandSMSTableView.register(UINib(nibName: "MassEmailandSMSTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSTableViewCell")
    }
    
    func massEmailandSMSDataRecived() {
        self.view.HideSpinner()
        self.massEmailandSMSTableView.setContentOffset(.zero, animated: true)
        clearSearchBar()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension MassEmailandSMSViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getMassEmailandSMSFilterData(searchText: searchText)
        isSearch = true
        massEmailandSMSTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        massEmailandSMSTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MassEmailandSMSViewController: MassEmailandSMSDelegate {
    func auditButtonClicked(cell: MassEmailandSMSTableViewCell, index: IndexPath) {
        let selectedIndex = self.massEmailSMSSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            let auditVC = UIStoryboard(name: "AuditListViewController", bundle: nil).instantiateViewController(withIdentifier: "AuditListViewController") as! AuditListViewController
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.emailFlag == true})
                auditVC.auditIdInfo  = filteredArray?[index.row].id ?? 0
                let triggerType = filteredArray?[index.row].emailFlag ?? false
                if triggerType {
                    auditVC.communicationTypeStr = "MASS_EMAIL"
                } else {
                    auditVC.communicationTypeStr = "MASS_SMS"
                }
                auditVC.triggerModuleStr = filteredArray?[index.row].moduleName ?? ""
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.emailFlag == true})
                auditVC.auditIdInfo  = filteredArray?[index.row].id ?? 0
                let triggerType = filteredArray?[index.row].emailFlag ?? false
                if triggerType {
                    auditVC.communicationTypeStr = "MASS_EMAIL"
                } else {
                    auditVC.communicationTypeStr = "MASS_SMS"
                }
                auditVC.triggerModuleStr = filteredArray?[index.row].moduleName ?? ""
                navigationController?.pushViewController(auditVC, animated: true)
            }
        case 1:
            let auditVC = UIStoryboard(name: "AuditListViewController", bundle: nil).instantiateViewController(withIdentifier: "AuditListViewController") as! AuditListViewController
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.smsFlag == true})
                auditVC.auditIdInfo  = filteredArray?[index.row].id ?? 0
                let triggerType = filteredArray?[index.row].emailFlag ?? false
                if triggerType {
                    auditVC.communicationTypeStr = "MASS_EMAIL"
                } else {
                    auditVC.communicationTypeStr = "MASS_SMS"
                }
                auditVC.triggerModuleStr = filteredArray?[index.row].moduleName ?? ""
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.smsFlag == true})
                auditVC.auditIdInfo  = filteredArray?[index.row].id ?? 0
                let triggerType = filteredArray?[index.row].emailFlag ?? false
                if triggerType {
                    auditVC.communicationTypeStr = "MASS_EMAIL"
                } else {
                    auditVC.communicationTypeStr = "MASS_SMS"
                }
                auditVC.triggerModuleStr = filteredArray?[index.row].moduleName ?? ""
                navigationController?.pushViewController(auditVC, animated: true)
            }
        default:
            break
        }
    }
    
    func deleteButtonClicked(cell: MassEmailandSMSTableViewCell, index: IndexPath) {
        let selectedIndex = self.massEmailSMSSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            var selectedTriggerId = Int()
            if isSearch {
                selectedTriggerId = viewModel?.getMassEmailandSMSFilterData[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Mass Email and SMS", message: "Are you sure you want to delete \(viewModel?.getMassEmailandSMSFilterDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedMassEmail(massEmailId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                selectedTriggerId = viewModel?.getMassEmailandSMSData[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Mass Email and SMS", message: "Are you sure you want to delete \(viewModel?.getMassEmailandSMSDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedMassEmail(massEmailId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case 1:
            var selectedTriggerId = Int()
            if isSearch {
                selectedTriggerId = viewModel?.getMassEmailandSMSFilterData[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Mass Email and SMS", message: "Are you sure you want to delete \(viewModel?.getMassEmailandSMSFilterDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedMassEmail(massEmailId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                selectedTriggerId = viewModel?.getMassEmailandSMSData[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Mass Email and SMS", message: "Are you sure you want to delete \(viewModel?.getMassEmailandSMSDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedMassEmail(massEmailId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func mailSMSDeletedSuccefully(message: String) {
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.getMassEmailandSMS()
    }
    
    func editEmailandSMS(cell: MassEmailandSMSTableViewCell, index: IndexPath) {
        let massSMSEditvc = UIStoryboard(name: "MassEmailandSMSEditDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "MassEmailandSMSEditDetailViewController") as! MassEmailandSMSEditDetailViewController
        let selectedIndex = self.massEmailSMSSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.emailFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[index.row].id
                let triggerType = viewModel?.getMassEmailandSMSFilterData[index.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.emailFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[index.row].id
                let triggerType = viewModel?.getMassEmailandSMSData[index.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.smsFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[index.row].id
                let triggerType = viewModel?.getMassEmailandSMSFilterData[index.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.smsFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[index.row].id
                let triggerType = viewModel?.getMassEmailandSMSData[index.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            }
        default:
            break
        }
        self.navigationController?.pushViewController(massSMSEditvc, animated: true)
    }
    
    func didTapSwitchButton(massEmailandSMSId: String, massEmailandSMSStatus: String) {
        self.view.ShowSpinner()
        viewModel?.getSwitchOnButton(massEmailandSMSId: massEmailandSMSId, massEmailandSMStatus: massEmailandSMSStatus)
    }
}
