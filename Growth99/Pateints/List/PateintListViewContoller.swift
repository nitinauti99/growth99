//
//  PateintListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation
import UIKit

protocol PateintListViewContollerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class PateintListViewContoller: UIViewController, PateintListViewContollerProtocol {
   
    @IBOutlet private weak var pateintListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: PateintListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintListViewModel(delegate: self)
        self.getUserList()
        self.setBarButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
    }
    
    func setBarButton(){
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action:  #selector(creatUser), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func updateUI(){
        self.getUserList()
        self.view.ShowSpinner()
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
        self.getUserList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
//
//    func loadMoreItemsForList(){
//        if (viewModel?.leadUserData.count ?? 0) ==  viewModel?.leadTotalCount {
//            return
//        }
//         currentPage += 1
//         getListFromServer(currentPage)
//     }
    
    func registerTableView() {
        self.pateintListTableView.delegate = self
        self.pateintListTableView.dataSource = self
        pateintListTableView.register(UINib(nibName: "PateintListTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintListTableViewCell")
    }

    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.pateintListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension PateintListViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
           return filteredTableData.count
        }else{
            return viewModel?.UserData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PateintListTableViewCell()
        cell = pateintListTableView.dequeueReusableCell(withIdentifier: "PateintListTableViewCell") as! PateintListTableViewCell
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PateintListViewContoller:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.UserData.filter { $0.firstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        pateintListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        pateintListTableView.reloadData()
    }
}

