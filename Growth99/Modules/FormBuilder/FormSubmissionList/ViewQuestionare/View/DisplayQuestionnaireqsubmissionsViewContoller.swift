//
//  DisplayQuestionnaireqsubmissionsViewContoller.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import Foundation
import UIKit

protocol DisplayQuestionnaireqsubmissionsViewContollerProtocol: AnyObject {
    func questionnaireDataRecived()
    func errorReceived(error: String)
}

class DisplayQuestionnaireqsubmissionsViewContoller: UIViewController, DisplayQuestionnaireqsubmissionsViewContollerProtocol {
    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var questionnaireTableView: UITableView!
    
    var viewModel: DisplayQuestionnaireqsubmissionsViewModelProtocol?
    var questionnaireId = Int()
    var pateintId = Int()
    var screenName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = DisplayQuestionnaireqsubmissionsViewModel(delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerTableView()
        self.title = Constant.Profile.questionnaireDetails
        self.view.ShowSpinner()
        viewModel?.getDisplayFormQuestionnaire(questionnaireId: questionnaireId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let userInfo = [ "selectedIndex" : 1 ]
            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
        }
    }
    
    func registerTableView() {
        self.questionnaireTableView.register(UINib(nibName: "DisplayQuestionnaireqsubmissionsTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayQuestionnaireqsubmissionsTableViewCell")
    }
    
    func questionnaireDataRecived() {
        self.view.HideSpinner()
        self.questionnaireTableView.reloadData()
        self.questionnaireName.text = viewModel?.getQuestionnaireName
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}


