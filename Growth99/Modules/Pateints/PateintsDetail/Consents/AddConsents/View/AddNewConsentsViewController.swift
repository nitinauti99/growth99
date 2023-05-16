//
//  ConsentsViewController.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import Foundation
import UIKit

protocol AddNewConsentsViewControllerProtocol: AnyObject {
    func ConsentsListRecived()
    func errorReceived(error: String)
    func consnetSendToPateintSuccessfully()
}

class AddNewConsentsViewController: UIViewController, AddNewConsentsViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: AddNewConsentsViewModelProtocol?
    var filteredTableData = [AddNewConsentsModel]()
    var isSearch : Bool = false
    var pateintId = Int()
    var consentId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddNewConsentsViewModel(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let userInfo = [ "selectedIndex" : 3 ]
            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.view.ShowSpinner()
        viewModel?.getConsentsList()
        self.registerTableView()
        self.title = Constant.Profile.AssignConsent
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "ConsentsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ConsentsTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    func ConsentsListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func consnetSendToPateintSuccessfully(){
        self.view.HideSpinner()
        self.view.showToast(message: "Consents sent to patient", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SendtoPatientButtonTapped(_ sender: UIButton) {
        /// api is accepting wrong formate data
        var consentsIdArray = [AddNewConsentsModel]()
        
        let patientconentsList = viewModel?.getConsentsDataList ?? []
        
        for index in 0..<(patientconentsList.count ) {
            let cellIndexPath = IndexPath(item: index, section: 0)
            let item = patientconentsList[cellIndexPath.row]
            if let InputTypeCell = tableView.cellForRow(at: cellIndexPath) as? ConsentsTableViewCell {
                if InputTypeCell.questionnaireSelection.isSelected == true {
                    consentsIdArray.append(item)
                }
            }
        }
        if consentsIdArray.count > 0{
           self.view.ShowSpinner()
           viewModel?.sendConsentsListToPateint(patient: pateintId, consentsIds: consentsIdArray)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
