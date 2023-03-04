//
//  MultiSelectionViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

protocol BussinessSelectionViewContollerProtocol: AnyObject {
    func bussinessSelectionDataRecived(data: BussinessSelectionModel)
}

class BussinessSelectionViewController: UIViewController {
    
    @IBOutlet weak var BussinessSelectionTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearch : Bool = false
    var bussinessSelectionData = [BussinessSelectionModel]()
    var bussinessDelegate: BussinessSelectionViewContollerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.users
        self.BussinessSelectionTableView.reloadData()
    }
    
    func registerTableView() {
        self.BussinessSelectionTableView.delegate = self
        self.BussinessSelectionTableView.dataSource = self
        BussinessSelectionTableView.register(UINib(nibName: "BussinessSelectionListTableViewCell", bundle: nil), forCellReuseIdentifier: "BussinessSelectionListTableViewCell")
    }

    func loginbuttonPressed(selectedIndex: IndexPath){
        let item = bussinessSelectionData[selectedIndex.row]
        print(item)
        self.bussinessDelegate?.bussinessSelectionDataRecived(data: item)
        self.dismiss(animated: true)
    }
    
    func bussinessDataRecived() {
        self.view.HideSpinner()
        self.BussinessSelectionTableView.setContentOffset(.zero, animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
