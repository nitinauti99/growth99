//
//  CreatePateintViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation
import UIKit

class CreatePateintViewContoller: UIViewController {
   
    @IBOutlet private weak var pateintListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

//    var viewModel: PateintListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewModel = PateintListViewModel(delegate: self)
//        self.getUserList()
//        self.setBarButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.registerTableView()
    }
}
