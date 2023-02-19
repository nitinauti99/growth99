//
//  PateintsTagsListViewController.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation
import UIKit

protocol PateintsTagsListViewControllerProtocol: AnyObject {
    func pateintsTagListRecived()
    func errorReceived(error: String)
    func pateintTagRemovedSuccefully(mrssage: String)
}

class PateintsTagsListViewController: UIViewController, PateintsTagsListViewControllerProtocol,PateintsTagListTableViewCellDelegate {
   
    @IBOutlet private weak var PateintsTagsListTableview: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: PateintsTagsListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintsTagListModel]()
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintsTagsListViewModel(delegate: self)
        self.setBarButton()
    }
        
    func registerTableView() {
        PateintsTagsListTableview.register(UINib(nibName: "PateintsTagListTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintsTagListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList()
        self.title = Constant.Profile.patientTags
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func creatUser() {
        let PateintsTagsAddVC = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
        PateintsTagsAddVC.PateintsTagsCreate = true
        self.navigationController?.pushViewController(PateintsTagsAddVC, animated: true)
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func pateintsTagListRecived() {
        self.view.HideSpinner()
        self.PateintsTagsListTableview.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func removePatieintTag(cell: PateintsTagListTableViewCell, index: IndexPath) {
        let alert = UIAlertController(title: "Delete Patient", message: "Are you sure you want to delete \n\(viewModel?.QuestionarieDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            let tagid = self?.viewModel?.QuestionarieDataAtIndex(index: index.row)?.id ?? 0
            self?.viewModel?.removePateintsTag(pateintsTagid: tagid)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func pateintTagRemovedSuccefully(mrssage: String){
        self.view.showToast(message: mrssage, color: .red)
        viewModel?.getQuestionarieList()
    }

    func editPatieintTag(cell: PateintsTagListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
        detailController.PatientTagId = viewModel?.QuestionarieDataAtIndex(index: index.row)?.id ?? 0
        detailController.PateintsTagsCreate = false
        navigationController?.pushViewController(detailController, animated: true)
    }

}

extension PateintsTagsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        } else {
            return viewModel?.QuestionarieDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.PateintsTagsListTableview.dequeueReusableCell(withIdentifier: "PateintsTagListTableViewCell", for: indexPath) as? PateintsTagListTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        if isSearch {
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
        
        detailController.PatientTagId = viewModel?.QuestionarieDataAtIndex(index: indexPath.row)?.id ?? 0
        detailController.PateintsTagsCreate = false
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension PateintsTagsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.QuestionarieDataList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        PateintsTagsListTableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        PateintsTagsListTableview.reloadData()
    }
}
