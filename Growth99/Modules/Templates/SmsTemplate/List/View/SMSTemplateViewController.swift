//
//  SMSTemplateViewController.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import Foundation
import UIKit

protocol SMSTemplateViewContollerProtocol {
    func SmsTemplatesDataRecived()
    func errorReceived(error: String)
}

class SMSTemplateViewController: UIViewController {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: SMSTemplateViewModelProtocol?
    
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.smsTemplateList
        self.viewModel = SMSTemplateViewModel(delegate: self)
        self.addSerchBar()
        self.setUpSegemtcontrol()
        self.tableView.register(UINib(nibName: "SMSTemplatesListTableViewCell", bundle: nil), forCellReuseIdentifier: "SMSTemplatesListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getSMSTemplateList()
    }
    
    fileprivate func setUpSegemtcontrol() {
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: Constant.Profile.leadTemplates, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.appointmentTemplates, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.massEmailTemplates, at: 2)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 3
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        segmentedControl.selectedSegmentIndex = selectedindex
    }

    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        case 1:
            tableView.reloadData()
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        case 2:
            tableView.reloadData()
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
       default:
            break
        }
    }

    @objc func addUserButtonTapped(_ sender: UIButton) {
        let createSMSTemplateVC = UIStoryboard(name: "CreateSMSTemplateViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateSMSTemplateViewController") as! CreateSMSTemplateViewController
        createSMSTemplateVC.selectedIndex = segmentedControl.selectedSegmentIndex
        navigationController?.pushViewController(createSMSTemplateVC, animated: true)
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
}

extension SMSTemplateViewController: SMSTemplateViewContollerProtocol {
   
    func SmsTemplatesDataRecived(){
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
