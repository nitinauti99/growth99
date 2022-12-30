//
//  leadDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import UIKit

protocol leadDetailViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedQuestionnaireList()
}

class leadDetailViewController: UIViewController,leadDetailViewControllerProtocol {
   
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
    @IBOutlet private weak var scrollViewHight: NSLayoutConstraint!
    @IBOutlet private weak var anslistTableView: UITableView!

    var patientQuestionList = [QuestionAnswers]()
    private var viewModel: leadDetailViewProtocol?
    var LeadData: leadModel?

    var tableViewHeight: CGFloat {
        anslistTableView.layoutIfNeeded()
        return anslistTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(updateLeadInfo))
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        self.view.ShowSpinner()
        self.viewModel = leadDetailViewModel(delegate: self)
        viewModel?.getQuestionnaireList(questionnaireId: LeadData?.id ?? 0)
        anslistTableView.register(UINib(nibName: "questionAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "questionAnswersTableViewCell")
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func updateLeadInfo() {
        let editLeadVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editLeadVC.LeadData = LeadData
        self.present(editLeadVC, animated: true)
    }
    
    @objc func updateUI(){
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.title = "Lead Detail"
    }

    @objc private func editButtonPressed(_ sender: UIButton) {
        let editLeadVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editLeadVC.LeadData = LeadData
        self.present(editLeadVC, animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func recivedQuestionnaireList() {
        self.view.HideSpinner()
        patientQuestionList = viewModel?.questionnaireDetailListData ?? []
        anslistTableView.reloadData()
        scrollViewHight.constant = tableViewHeight
        view.setNeedsLayout()
    }
    
//    "Source URL" : LeadData?.sourceUrl ?? "",
//    "Landing Page" : LeadData?.landingPage ?? "",
//    "Created Date" : LeadData?.createdAt ?? "",

}

extension leadDetailViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return patientQuestionList.count
        }else{
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let item = patientQuestionList[indexPath.row]
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "questionAnswersTableViewCell") as? questionAnswersTableViewCell else { return UITableViewCell() }
            
            cell.qutionNameLbi.text = item.questionName
            cell.ansLbi.text = item.answerText
            cell.editButton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
            cell.editButton.isHidden = true
            
            if item.questionName == "First Name" || item.questionName == "Last Name" || item.questionName == "Email" || item.questionName == "Phone Number" {
                cell.editButton.isHidden = false
            }

            return cell
        } else{
            cell.contentView.backgroundColor = .red
            return cell
       }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension leadDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight
    }
}



//    func setUpUI(){
//        self.symptoms.text = LeadData?.Symptoms ?? "-"
//        self.gender.text = LeadData?.Gender ?? "-"
//        self.message.text = LeadData?.Message ?? "-"
//        self.phoneNumber.text = LeadData?.PhoneNumber ?? "-"
//        self.email.text = LeadData?.Email ?? "-"
//        self.lastName.text = LeadData?.lastName ?? "-"
//        self.firstName.text = LeadData?.firstName ?? "-"
//        self.source.text = LeadData?.leadSource ?? "-"
//        self.sourceURL.text = LeadData?.sourceUrl ?? "-"
//        self.landingPage.text = LeadData?.landingPage ?? "-"
//        self.createdAt.text = LeadData?.createdAt ?? "-"
//    }
    
