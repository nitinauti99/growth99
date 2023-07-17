//
//  TriggerParentCreateTableViewCell.swift
//  Growth99
//
//  Created by Exaze Technologies on 01/04/23.
//

import UIKit

class TriggerParentCreateTableViewCell: UITableViewCell {
    @IBOutlet weak var parentTableView: UITableView!
    
    var trigerData: [TriggerEditData] = []
    var moduleSelectionTypeTrigger: String = ""
    var indexPath = IndexPath()
    var moduleSelectionEditTrigger: String = ""
    var selectedNetworkEditTrigger: String = ""
    var viewModel: TriggerEditDetailViewModelProtocol?
    var selctionType: String = ""
    var view: TriggerEditDetailViewController?
    @IBOutlet weak var parentTableViewHight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.registerTableView()
    }
    
    func configureCell(triggerEditData: [TriggerEditData], index: IndexPath, moduleSelectionTypeTrigger: String, selectedNetworkType: String, parentViewModel: TriggerEditDetailViewModelProtocol?, viewController: TriggerEditDetailViewController) {
        indexPath = index
        moduleSelectionEditTrigger = moduleSelectionTypeTrigger
        selectedNetworkEditTrigger = selectedNetworkType
        trigerData = triggerEditData
        viewModel = parentViewModel
        view = viewController
        parentTableViewHight.constant = CGFloat(trigerData.count * 600)
        parentTableView.layoutIfNeeded()
    }
    
    func getTableView()-> UITableView {
        return self.parentTableView
    }
    
    func registerTableView() {
        self.parentTableView.delegate = self
        self.parentTableView.dataSource = self
        self.parentTableView.register(UINib(nibName: "TriggerEditSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditSMSCreateTableViewCell")
        self.parentTableView.register(UINib(nibName: "TriggerEditTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditTimeTableViewCell")
    }
    
}

extension TriggerParentCreateTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trigerData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = trigerData[indexPath.row]
        if item.type == "Create" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditSMSCreateTableViewCell", for: indexPath) as? TriggerEditSMSCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = view
            cell.configureCell(triggerEditData: trigerData, index: indexPath, moduleSelectionTypeTrigger: moduleSelectionEditTrigger, selectedNetworkType: selectedNetworkEditTrigger, parentViewModel: viewModel)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditTimeTableViewCell", for: indexPath) as? TriggerEditTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = view
            cell.configureCell(triggerEditData: trigerData, index: indexPath, moduleSelectionTypeTrigger: moduleSelectionEditTrigger, selectedNetworkType: selectedNetworkEditTrigger, parentViewModel: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
