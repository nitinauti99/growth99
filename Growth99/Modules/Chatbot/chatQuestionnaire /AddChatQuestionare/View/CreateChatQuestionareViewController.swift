//
//  CreateChatQuestionareViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation
import UIKit

protocol CreateChatQuestionareViewControllerProtocol: AnyObject {
    func chatQuestionnaireQuestionListRecived()
    func chatquestionnaireDataRecived()
    func errorReceived(error: String)
    func saveChatQuestionaire(message:String)
    func removedChatquestionnaireQuestionsuccessfully()
}

class CreateChatQuestionareViewController: UIViewController {
    
    @IBOutlet weak var chatQuestionnaireName: CustomTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatQuestionareLBI: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var viewModel: CreateChatQuestionareViewModelProtocol?
    var chatQuestionareId = Int()
    var screenName = String()
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateChatQuestionareViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.register(UINib(nibName: "ChatQuestionnaireQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatQuestionnaireQuestionTableViewCell")
        if self.screenName == "Edit Screen" {
            self.chatQuestionareLBI.text =  "Edit Chat Questionnaire"
            self.view.ShowSpinner()
            self.viewModel?.getChatquestionnaire(questionnaireId: chatQuestionareId)
        }else{
            self.chatQuestionareLBI.text = "Add Chat Questionnaire"
        }
    }

    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createQuestion(sender: UIButton){
        let detailController = UIStoryboard(name: "CreateQuestionViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreateQuestionViewContoller") as! CreateQuestionViewContoller
        detailController.chatQuestionareId = chatQuestionareId
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = chatQuestionnaireName.text,  textField == "" {
            self.chatQuestionnaireName.showError(message: Constant.ErrorMessage.chatQuestionnaireNameEmptyError)
            return
        }
        
        if  screenName == "Edit Screen" {
            self.view.ShowSpinner()
            self.viewModel?.updateChatQuestionnaire(chatquestionnaireId: self.chatQuestionareId, name: chatQuestionnaireName.text ?? String.blank)
        }else{
            self.view.ShowSpinner()
            self.viewModel?.createchatQuestionnaire(name: chatQuestionnaireName.text ?? String.blank)
        }
    }
}

extension CreateChatQuestionareViewController: CreateChatQuestionareViewControllerProtocol {
   
    func chatQuestionnaireQuestionListRecived(){
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func saveChatQuestionaire(message: String) {
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
    
    func removedChatquestionnaireQuestionsuccessfully(){
        self.view.showToast(message: "Question deleted successfully.", color: UIColor().successMessageColor())

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.viewModel?.getChatQuestionnaireQuestionList(QuestionId: self.chatQuestionareId)
        })
    }
    
    func chatquestionnaireDataRecived(){
        if self.screenName == "Edit Screen" {
            self.chatQuestionnaireName.text = self.viewModel?.getChatquestionnaireData?.name ?? ""
        }
        self.viewModel?.getChatQuestionnaireQuestionList(QuestionId: chatQuestionareId)
    }
}

extension CreateChatQuestionareViewController: ChatQuestionnaireQuestionTableViewCellDelegate {
   
    func removeChatQuestionnaireQuestion(cell: ChatQuestionnaireQuestionTableViewCell, index: IndexPath) {
        var chatQuestionnaireName : String = ""
        var chatQuestionnaireId = Int()
        chatQuestionnaireName = viewModel?.chatQuestionnaireQuestionDataAtIndex(index: index.row)?.question ?? String.blank
        chatQuestionnaireId = viewModel?.chatQuestionnaireQuestionDataAtIndex(index: index.row)?.id ?? 0
        
        if self.isSearch {
            chatQuestionnaireName = viewModel?.chatQuestionnaireQuestionFilterDataAtIndex(index: index.row)?.question ?? String.blank
            chatQuestionnaireId =  viewModel?.chatQuestionnaireQuestionFilterDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: "Delete Question" , message: "Are you sure you want to delete \n\(chatQuestionnaireName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeChatQuestionnaireQuestionList(questionnaireId: self?.chatQuestionareId ?? 0, questionId: chatQuestionnaireId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    func editChatQuestionnaireQuestion(cell: ChatQuestionnaireQuestionTableViewCell, index: IndexPath){
        let detailController = UIStoryboard(name: "CreateQuestionViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreateQuestionViewContoller") as! CreateQuestionViewContoller
        detailController.screenName = "Edit Screen"
        detailController.chatQuestionareId = chatQuestionareId

        if isSearch {
            detailController.chatQuestionData = viewModel?.chatQuestionnaireQuestionFilterDataAtIndex(index: index.row)
        }else{
            detailController.chatQuestionData = viewModel?.chatQuestionnaireQuestionDataAtIndex(index: index.row)
        }
         navigationController?.pushViewController(detailController, animated: true)
      }
}

