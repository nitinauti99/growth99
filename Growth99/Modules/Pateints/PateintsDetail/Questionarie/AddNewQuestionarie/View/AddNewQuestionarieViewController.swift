//
//  AddNewQuestionarieViewController.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation
import UIKit

protocol AddNewQuestionarieViewControllerProtocol: AnyObject {
    func questionarieListRecived()
    func errorReceived(error: String)
    func questionarieSendToPateints()
}

class AddNewQuestionarieViewController: UIViewController,AddNewQuestionarieViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: AddNewQuestionarieViewModelProtocol?
    var filteredTableData = [AddNewQuestionarieModel]()
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel = AddNewQuestionarieViewModel(delegate: self)
        viewModel?.getQuestionarieList()
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "AddNewQuestionarieTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewQuestionarieTableViewCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let userInfo = [ "selectedIndex" : 1 ]
            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Questionnarie
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func questionarieListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func questionarieSendToPateints(){
        self.view.HideSpinner()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelPatientButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SendtoPatientButtonTapped(_ sender: UIButton) {
        /// api is accepting wrong formate data
        var questionnaireIdArray = [AddNewQuestionarieModel]()
        
        let patientQuestionList = viewModel?.getQuestionarieDataList ?? []
        
        for index in 0..<(patientQuestionList.count ) {
            let cellIndexPath = IndexPath(item: index, section: 0)
            let item = patientQuestionList[cellIndexPath.row]
            if let InputTypeCell = tableView.cellForRow(at: cellIndexPath) as? AddNewQuestionarieTableViewCell {
                if InputTypeCell.questionnaireSelection.isSelected == true {
                    questionnaireIdArray.append(item)
                }
            }
        }
        self.view.ShowSpinner()
        viewModel?.sendQuestionarieListToPateint(patient: pateintId, questionnaireIds: questionnaireIdArray)
    }
}
