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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.registerTableView()
    }
    
    func configureCell(triggerEditData: [TriggerEditData], index: IndexPath, moduleSelectionTypeTrigger: String, selectedNetworkType: String, parentViewModel: TriggerEditDetailViewModelProtocol?) {
        indexPath = index
        moduleSelectionEditTrigger = moduleSelectionTypeTrigger
        selectedNetworkEditTrigger = selectedNetworkType
        trigerData = triggerEditData
        viewModel = parentViewModel
    }
    
    func registerTableView() {
        self.parentTableView.delegate = self
        self.parentTableView.dataSource = self
        self.parentTableView.register(UINib(nibName: "TriggerSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerSMSCreateTableViewCell")
        self.parentTableView.register(UINib(nibName: "TriggerTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerTimeTableViewCell")
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerSMSCreateTableViewCell", for: indexPath) as? TriggerSMSCreateTableViewCell else { return UITableViewCell()}
            cell.configureCell(triggerEditData: trigerData, index: indexPath, moduleSelectionTypeTrigger: moduleSelectionTypeTrigger, selectedNetworkType: selectedNetworkEditTrigger, parentViewModel: viewModel)
            return cell
       
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerTimeTableViewCell", for: indexPath) as? TriggerTimeTableViewCell else { return UITableViewCell()}
           
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
   
}
