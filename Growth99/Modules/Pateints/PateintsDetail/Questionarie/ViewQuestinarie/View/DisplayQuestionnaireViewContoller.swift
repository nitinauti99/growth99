//
//  DisplayQuestionnaireViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import Foundation
import UIKit

protocol DisplayQuestionnaireViewContollerProtocol: AnyObject {
    func questionnaireDataRecived()
    func errorReceived(error: String)
}

class DisplayQuestionnaireViewContoller: UIViewController, DisplayQuestionnaireViewContollerProtocol {
    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var questionnaireTableView: UITableView!
    
    var viewModel: DisplayQuestionnaireViewModelProtocol?
    var questionnaireId = Int()
    var pateintId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = DisplayQuestionnaireViewModel(delegate: self)
        self.view.ShowSpinner()
        viewModel?.getDisplayQuestionnaire(patientId: pateintId, questionnaireId: questionnaireId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerTableView()
        self.title = Constant.Profile.questionnaireDetails
    }
    
    func registerTableView() {
        self.questionnaireTableView.register(UINib(nibName: "DisplayQuestionnaireTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayQuestionnaireTableViewCell")
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


