//
//  QuestionnaireTemplatesViewController.swift
//  Growth99
//
//  Created by nitin auti on 10/02/23.
//

import Foundation
import UIKit

protocol QuestionnaireTemplateListViewControllerProtocol {
    func questionnaireTemplatesDataRecived()
    func errorReceived(error: String)
}

class QuestionnaireTemplateListViewController: UIViewController, QuestionnaireTemplateListViewControllerProtocol {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: QuestionnaireTemplateListViewModelProtocol?
    
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.Questionnarie
        viewModel = QuestionnaireTemplateListViewModel(delegate: self)
        viewModel?.getQuestionnaireTemplateList()
        tableView.register(UINib(nibName: "QuestionnaireTemplateListTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionnaireTemplateListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        viewModel?.getQuestionnaireTemplateList()
    }
    
    func questionnaireTemplatesDataRecived(){
        self.view.HideSpinner()
        //QuestionnaireTemplateListData = viewModel?.getQuestionnaireTemplateData ?? []
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
}
