//
//  PateintsTimeLineViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

protocol PateintsTimeLineViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedPateintsTimeLineData()
    func recivedPateintsTimeLineTemplateData()
}

class PateintsTimeLineViewController: UIViewController,
                                      PateintsTimeLineViewControllerProtocol {
    
    @IBOutlet weak var pateintsTimeLineTableView: UITableView!
    
    var viewModel: PateintsTimeLineViewModelProtocol?
    var pateintsId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PateintsTimeLineViewModel(delegate: self)
        pateintsTimeLineTableView.register(UINib(nibName: "PateintsTimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintsTimeLineTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Timeline
        self.view.ShowSpinner()
        viewModel?.getPateintsTimeLineData(pateintsId: pateintsId)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func recivedPateintsTimeLineData() {
        self.view.HideSpinner()
        self.pateintsTimeLineTableView.reloadData()
    }
}

extension PateintsTimeLineViewController: PateintsTimeLineTableViewCellProtocol {
   
    func viewTemplate(cell: PateintsTimeLineTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        viewModel?.getTimeLineTemplateData(pateintsId: 1233333)
    }
    
    func recivedPateintsTimeLineTemplateData(){
        self.view.HideSpinner()

    }
    
}
