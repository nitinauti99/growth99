//
//  MassEmailandSMSDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

class MassEmailandSMSDetailViewController: UIViewController {

    @IBOutlet weak var emailAndSMSTableView: UITableView!
    
    var emailAndSMSDetailList = [MassEmailandSMSDetailModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Default", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createMassEmailSMS
    }
    
    func registerTableView() {
        self.emailAndSMSTableView.delegate = self
        self.emailAndSMSTableView.dataSource = self
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSDefaultTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSCreateTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSLeadActionTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSLeadActionTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSModuleTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSPatientActionTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSPatientActionTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSTimeTableViewCell")

    }
}
