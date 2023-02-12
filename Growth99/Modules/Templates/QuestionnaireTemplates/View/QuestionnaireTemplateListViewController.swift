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
    func questionnaireRemovedSuccefully(mrssage: String)
}

class QuestionnaireTemplateListViewController: UIViewController, QuestionnaireTemplateListViewControllerProtocol,QuestionnaireTemplateListTableViewCellDelegate {
    
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
        self.view.ShowSpinner()
        viewModel?.getQuestionnaireTemplateList()
        tableView.register(UINib(nibName: "QuestionnaireTemplateListTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionnaireTemplateListTableViewCell")
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
    
    func removePatieint(cell: QuestionnaireTemplateListTableViewCell, index: IndexPath) {
        var consentsName : String = ""
        var questionnaireId = Int()
            consentsName = viewModel?.getqQuestionnaireTemplateDataAtIndex(index: index.row)?.name ?? ""
            questionnaireId = viewModel?.getqQuestionnaireTemplateDataAtIndex(index: index.row)?.id ?? 0
        if isSearch {
            consentsName = viewModel?.getQuestionnaireTemplateFilterDataAtIndex(index: index.row)?.name ?? ""
            questionnaireId =  viewModel?.getQuestionnaireTemplateFilterDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: Constant.Profile.deleteConcents , message: "Are you sure you want to delete \n\(consentsName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeQuestionnaire(questionnaireId: questionnaireId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func questionnaireTemplatesDataRecived(){
        self.view.HideSpinner()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func questionnaireRemovedSuccefully(mrssage: String){
        self.view.showToast(message: mrssage, color: .black)
        viewModel?.getQuestionnaireTemplateList()
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}
