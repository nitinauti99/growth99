//
//  CreateQuestionViewContoller.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation
protocol CreateQuestionViewContollerProtocol: AnyObject {
    func chatQuestionCreated(message: String)
    func chatQuestionUpdated(message: String)
    func errorReceived(error: String)
}

class CreateQuestionViewContoller: UIViewController, CreateQuestionViewContollerProtocol {
   
    @IBOutlet weak var questionTextField: CustomTextField!
    @IBOutlet weak var answerTextField: CustomTextView!
    @IBOutlet weak var answerTextFieldLBI: UILabel!
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
    
    func chatQuestionCreated(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func chatQuestionUpdated(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(sender: UIButton){
        
        if let textField = questionTextField.text,  textField == "" {
            questionTextField.showError(message: "Question is required")
            return
        }
        
        if let textField = answerTextField.text,  textField == "" {
            answerTextFieldLBI.isHidden = false
            return
        }
        answerTextFieldLBI.isHidden = true

        self.view.ShowSpinner()
        if screenName == "Edit Screen" {
            viewModel?.updateQuestion(question: questionTextField.text ?? "", answer: answerTextField.text ?? "", referenceLink: referenceLinkTextField.text ?? "", chatQuestionId: chatQuestionareId, questionareId: chatQuestionData?.id ?? 0)
        }else{
            viewModel?.createQuestion(question: questionTextField.text ?? "", answer: answerTextField.text ?? "", referenceLink: referenceLinkTextField.text ?? "", chatQuestionId: chatQuestionareId)
          }
      }
    
}

extension CreateQuestionViewContoller: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if textField == questionTextField {
            guard let textField = questionTextField.text, !textField.isEmpty else {
                questionTextField.showError(message: "Question is required.")
                return
            }
        }
    }
}

extension CreateQuestionViewContoller: UITextViewDelegate  {
    
    func textViewDidChange(_ textField: UITextView) {
        if textField == answerTextField {
            guard let textField  = answerTextField.text, !textField.isEmpty else {
                answerTextFieldLBI.isHidden = false
                return
            }
            answerTextFieldLBI.isHidden = true
        }
    }
}
