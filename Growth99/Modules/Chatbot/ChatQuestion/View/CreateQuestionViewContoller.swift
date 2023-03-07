//
//  CreateQuestionViewContoller.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation
protocol CreateQuestionViewContollerProtocol: AnyObject {
    func chatQuestionCreated()
    func errorReceived(error: String)
}

class CreateQuestionViewContoller: UIViewController, CreateQuestionViewContollerProtocol {
   
    @IBOutlet weak var questionTextField: CustomTextField!
    @IBOutlet weak var answerTextField: CustomTextView!
    @IBOutlet weak var referenceLinkTextField: CustomTextField!

    var viewModel: CreateQuestionViewModelProtocol?
   
    var chatQuestionareId = Int()
    var screenName = String()
    var chatQuestionData: ChatQuestionareListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateQuestionViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screenName == "Edit Screen" {
            self.questionTextField.text = chatQuestionData?.question
            self.answerTextField.text = chatQuestionData?.answer
            self.referenceLinkTextField.text = chatQuestionData?.referenceLink
        }
        
        self.referenceLinkTextField.addTarget(self, action: #selector(linkValidation), for: .editingChanged)
    }
    
    @objc func linkValidation() {
        if viewModel?.isValidUrl(url: self.referenceLinkTextField.text ?? "") == false {
            referenceLinkTextField.showError(message: Constant.ErrorMessage.chatQuestionnaireURLInvalidError)
        }
    }
    
    func chatQuestionCreated() {
        self.view.HideSpinner()
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(sender: UIButton){
        
        if let textField = questionTextField.text,  textField == "" {
            questionTextField.showError(message: Constant.ErrorMessage.chatQuestionnaireNameEmptyError)
        }
        
        if let textField = answerTextField.text,  textField == "" {
            return
        }
        
        self.view.ShowSpinner()
        viewModel?.createQuestion(question: questionTextField.text ?? "", answer: answerTextField.text ?? "", referenceLink: referenceLinkTextField.text ?? "", chatQuestionId: chatQuestionareId)

      }
}
