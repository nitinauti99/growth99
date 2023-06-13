//
//  FormListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

import Foundation
import UIKit

protocol FormListViewControllerProtocol {
    func FormsDataRecived()
    func errorReceived(error: String)
    func consentsRemovedSuccefully(message: String)
}

class FormListViewController: UIViewController {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: FormListViewModelProtocol?
    var isSearch: Bool = false
    
    let user = UserRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user.FormBulderTitle == "Questionnaires" {
            self.title = "Questionnaires"

        }else{
            self.title = "Forms"
        }
        viewModel = FormListViewModel(delegate: self)
        self.addSerchBar()
        self.setBarButton()
        tableView.register(UINib(nibName: "FormListTableViewCell", bundle: nil), forCellReuseIdentifier: "FormListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getFormList()
    }
    
    func setBarButton(){
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action:  #selector(creatForm), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func creatForm() {
        let FormListVC = UIStoryboard(name: "CreateFormViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateFormViewController") as! CreateFormViewController
        self.navigationController?.pushViewController(FormListVC, animated: true)
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
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
        self.viewModel?.getFormList()
    }
    
   
    
}

extension FormListViewController: FormListViewControllerProtocol {
   
    func consentsRemovedSuccefully(message: String) {
        self.view.showToast(message: message,color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.viewModel?.getFormList()
        })
    }
    
    func FormsDataRecived(){
        self.view.HideSpinner()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension FormListViewController: FormListTableViewCellDelegate {
   
    func removeFromItem(cell: FormListTableViewCell, index: IndexPath) {
        var consentsName : String = ""
        var consentsId = Int()
        consentsName = viewModel?.FormDataAtIndex(index: index.row)?.name ?? String.blank
        consentsId = viewModel?.FormDataAtIndex(index: index.row)?.id ?? 0
        if isSearch {
            consentsName = viewModel?.formFilterDataAtIndex(index: index.row)?.name ?? String.blank
            consentsId =  viewModel?.formFilterDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: "Delete Questionnaire" , message: "Are you sure you want to delete \n\(consentsName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeConsents(consentsId: consentsId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    func editFormItem(cell: FormListTableViewCell, index: IndexPath){
        let formDetailContainerView = FormDetailContainerView.viewController()
        if isSearch {
            formDetailContainerView.workflowFormId = viewModel?.formFilterDataAtIndex(index: index.row)?.id ?? 0
        }else{
            formDetailContainerView.workflowFormId = viewModel?.FormDataAtIndex(index: index.row)?.id ?? 0
        }
        self.navigationController?.pushViewController(formDetailContainerView, animated: true)
    }

}
