//
//  leadViewController.swift
//  Growth99
//
//  Created by nitin auti on 28/11/22.
//

import Foundation
import UIKit

class leadViewController: UIViewController {
    @IBOutlet private weak var leadListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leadListTableView.delegate = self
        self.leadListTableView.dataSource = self
        leadListTableView.register(UINib(nibName: "LeadHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadHeaderTableViewCell")
        leadListTableView.register(UINib(nibName: "LeadTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTableViewCell")
     }
}

extension leadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = LeadHeaderTableViewCell()
            cell = leadListTableView.dequeueReusableCell(withIdentifier: "LeadHeaderTableViewCell") as! LeadHeaderTableViewCell
            return cell
        } else {
            var cell = LeadTableViewCell()
            cell = leadListTableView.dequeueReusableCell(withIdentifier: "LeadTableViewCell") as! LeadTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
           return 150
        }
    }
    
}
