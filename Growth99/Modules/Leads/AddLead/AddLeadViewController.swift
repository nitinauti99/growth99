//
//  AddLeadViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 14/07/23.
//

import UIKit
import WebKit

protocol AddLeadViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func QuestionnaireIdRecived()
    func QuestionnaireListRecived()
    func errorReceived(error: String)
}


class AddLeadViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var questionId = Int()
    var viewModel: CreateLeadViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.ShowSpinner()
        self.viewModel = CreateLeadViewModel(delegate: self)
        self.viewModel?.getQuestionnaireId()

    }

    @IBAction func closeView(sender: UIButton){
        self.dismiss(animated: true)
    }
}

extension AddLeadViewController: CreateLeadViewControllerProtocol {
    
    func LeadDataRecived() {
        
    }
    
    func QuestionnaireIdRecived() {
        let user = UserRepository.shared
        let urlSting = EndPoints.envUrl.appending("/assets/static/form.html?bid=") + "\(user.bussinessId ?? 0)&fid=\(viewModel?.id)"
        guard let url = URL(string: urlSting) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func QuestionnaireListRecived() {
        
    }
    
    func errorReceived(error: String) {
        
    }
}
