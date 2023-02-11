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

class SMSTemplateViewController: UIViewController, SMSTemplateViewContollerProtocol {
    
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
        viewModel = SMSTemplateViewModel(delegate: self)
        setUpSegemtcontrol()
        self.view.ShowSpinner()
        tableView.register(UINib(nibName: "SMSTemplatesListTableViewCell", bundle: nil), forCellReuseIdentifier: "SMSTemplatesListTableViewCell")
        viewModel?.getSMSTemplateList()
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "selectedIndex") , object: nil)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = segment
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
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        case 2:
            tableView.reloadData()
            //            if viewModel?.getSelectedTemplate(selectedIndex: 2).count == 0 {
            //               self.emptyMessage(parentView: self.view, message: "There is no data")
            //            }
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addTaskTapped), imageName: "add")
        case 3:
            tableView.reloadData()
            //            if viewModel?.getSelectedTemplate(selectedIndex: 3).count == 0 {
            //               self.emptyMessage(parentView: self.view, message: "There is no data")
            //            }
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(assignNewConsentButtonTapped), imageName: "add")
        default:
            break
        }
    }
    
    @objc func assignNewConsentButtonTapped(_ sender: UIButton){
        let addNewConsentsVC = UIStoryboard(name: "AddNewConsentsViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewConsentsViewController") as! AddNewConsentsViewController
        navigationController?.pushViewController(addNewConsentsVC, animated: true)
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let addNewQuestionarieVC = UIStoryboard(name: "AddNewQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestionarieViewController") as! AddNewQuestionarieViewController
        navigationController?.pushViewController(addNewQuestionarieVC, animated: true)
    }
    
    @objc func addTaskTapped(_ sender: UIButton) {
        let createTasksVC = UIStoryboard(name: "CreateTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateTasksViewController") as! CreateTasksViewController
        navigationController?.pushViewController(createTasksVC, animated: true)
    }
    
    static func viewController() -> EmailTemplateViewController {
        return UIStoryboard.init(name: "EmailTemplateViewController", bundle: nil).instantiateViewController(withIdentifier: "EmailTemplateViewController") as! EmailTemplateViewController
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getPateintList()
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    @objc func getPateintList() {
        self.view.ShowSpinner()
        viewModel?.getSMSTemplateList()
    }
    
    
    
    func SmsTemplatesDataRecived(){
        self.view.HideSpinner()
        //SmsTemplateeListData = viewModel?.getSmsTemplateeData ?? []
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
}
