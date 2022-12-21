//
//  leadDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import UIKit

protocol leadDetailViewControllerProtocol: AnyObject {
    func LoaginDataRecived()
    func errorReceived(error: String)
}

class leadDetailViewController: UIViewController {

    @IBOutlet private weak var symptoms: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var sourceURL: UILabel!
    @IBOutlet private weak var landingPage: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    
    private var viewModel: leadViewModelProtocol?
    var LeadData: leadModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(updateLeadInfo))
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpUI()
    }
    
    @objc func updateLeadInfo() {
        let editLeadVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editLeadVC.LeadData = LeadData
        self.present(editLeadVC, animated: true)
    }
    
    @objc func updateUI(){
        self.navigationController?.popViewController(animated: true)
    }

    func setUpUI(){
        self.symptoms.text = LeadData?.Symptoms
        self.gender.text = LeadData?.Gender
        self.message.text = LeadData?.Message
        self.phoneNumber.text = LeadData?.PhoneNumber
        self.email.text = LeadData?.Email
        self.lastName.text = LeadData?.lastName
        self.firstName.text = LeadData?.firstName
        self.source.text = LeadData?.leadSource
        self.sourceURL.text = LeadData?.sourceUrl
        self.landingPage.text = LeadData?.landingPage
        self.createdAt.text = LeadData?.createdAt
    }
 
    func updateEdit() {
         
    }
    
}
