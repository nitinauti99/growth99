//
//  EmailTemplateViewController.swift
//  Growth99
//
//  Created by nitin auti on 08/02/23.
//

import Foundation
import UIKit

protocol EmailTemplateViewContollerProtocol {
    func emailTemplatesDataRecived()
    func errorReceived(error: String)
}

class EmailTemplateViewController: UIViewController, EmailTemplateViewContollerProtocol {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: EmailTemplateViewModelProtocol?
    
    var emailTemplateListData: [EmailTemplateListModel] = []
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.emailTemplatesList
        viewModel = EmailTemplateViewModel(delegate: self)
        setUpSegemtcontrol()
        self.view.ShowSpinner()
        self.addSerchBar()
        tableView.register(UINib(nibName: "EmailTemplatesListTableViewCell", bundle: nil), forCellReuseIdentifier: "EmailTemplatesListTableViewCell")
        viewModel?.getEmailTemplateList()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
            //            if viewModel?.getSelectedTemplate(selectedIndex: 0).count == 0 {
            //               self.emptyMessage(parentView: self.view, message: "There is no data")
            //            }
            navigationItem.rightBarButtonItem = nil
        case 1:
            tableView.reloadData()
            //            if viewModel?.getSelectedTemplate(selectedIndex: 1).count == 0 {
            //               self.emptyMessage(parentView: self.view, message: "There is no data")
            //            }
//            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        case 2:
            tableView.reloadData()
            //            if viewModel?.getSelectedTemplate(selectedIndex: 2).count == 0 {
            //               self.emptyMessage(parentView: self.view, message: "There is no data")
            //            }
//            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addTaskTapped), imageName: "add")
        default:
            break
        }
    }
    
    func addSerchBar(){
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
    
    @objc func getPateintList() {
        self.view.ShowSpinner()
        viewModel?.getEmailTemplateList()
    }
    
    func emailTemplatesDataRecived(){
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
}
