//
//  FormDetailViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 15/02/23.
//

import Foundation
import UIKit
import SafariServices

protocol FormDetailViewControllerProtocol {
    func FormsDataRecived()
    func formsQuestionareDataRecived()
    func updatedFormDataSuccessfully()
    func questionRemovedSuccefully(mrssage: String)
    func recevedImageData()
    
    func errorReceived(error: String)

}
class FormDetailViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var preViewButton: UIButton!

    var viewModel: FormDetailViewModelProtocol?
    var questionId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FormDetailViewModel(delegate: self)
        self.registerCell()
        self.view.ShowSpinner()
        self.viewModel?.getFormQuestionnaireData(questionnaireId: questionId)
    }
    
    func registerCell(){
        self.tableView.register(UINib(nibName: "FormDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "FormDetailTableViewCell")
        self.tableView.register(UINib(nibName: "CreateQuestionnaireTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateQuestionnaireTableViewCell")
        self.tableView.register(UINib(nibName: "LeadQuestionnaireTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadQuestionnaireTableViewCell")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addQuestionButton.layer.borderWidth = 2
        self.addQuestionButton.roundCorners(corners: [.allCorners], radius: 5)
        self.addQuestionButton.layer.borderColor = UIColor(hexString: "#009EDE").cgColor
        self.preViewButton.layer.borderWidth = 2
        self.preViewButton.roundCorners(corners: [.allCorners], radius: 5)
        self.preViewButton.layer.borderColor = UIColor(hexString: "#009EDE").cgColor
    }
    
    @IBAction func showPreView(sender: UIButton){
        let user = UserRepository.shared
        let urlSting = "\(EndPoints.baseURL)/assets/static/form.html?bid=" + "\(user.bussinessId ?? 0)&fid=\(questionId)"
        if let url = URL(string: urlSting), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func addQuestionAction(sender:UIButton) {
        let createdBy = CreatedBy(firstName: "", lastName: "", email: "", username: "")
        let updatedBy =  UpdatedBy(firstName: "", lastName: "", email: "", username: "")

        let formItem  = FormDetailModel(createdAt: "", updatedAt: "", createdBy: createdBy, updatedBy: updatedBy, deleted: false, tenantId: 0, id: 0, name: "", type: "", answer: "", required: false, questionOrder:0, allowMultipleSelection: false, allowLabelsDisplayWithImages: false, hidden: false, validate: false, regex: "", validationMessage: "", showDropDown: false, preSelectCheckbox: false, description: "", subHeading: "", questionChoices: [], questionImages: [])
        
        self.viewModel?.addFormDetailData(item: formItem)
        
        NotificationCenter.default.post(name: Notification.Name("notificationCreateQuestion"), object: nil)
        
        let indexPath = IndexPath(row: (viewModel?.getFormDetailData.count ?? 0) - 1 , section: 1)
        self.tableView.insertRows(at: [indexPath], with: .none)
        self.tableView.reloadData()
    }
    
    @IBAction func cancelAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteQuestion(name: String, id: Int){
        let alert = UIAlertController(title: Constant.Profile.deleteConcents , message: "Are you sure you want to delete \n\(name)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeQuestions(questionId: self?.questionId ?? 0, childQuestionId: id )

        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
      
}

extension FormDetailViewController: CreateQuestionnaireTableViewCellDelegate {
    
    func presnetImagePickerController(cell: CreateQuestionnaireTableViewCell, imagePicker: UIImagePickerController) {
        self.present(imagePicker, animated: true)
    }
    
    func dismissImagePickerController(cell: CreateQuestionnaireTableViewCell) {
        self.dismiss(animated: true)
    }
   
    func saveFoemData(data: [String : Any]) {
        self.view.ShowSpinner()
        self.viewModel?.updateFormData(questionnaireId: questionId,formData: data)
    }
    
    func popToView() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FormDetailViewController: FormDetailViewControllerProtocol {
    
    func FormsDataRecived() {
        self.view.HideSpinner()
        tableView.reloadData()
    }
    
    func FormsDataRecived(message: String){
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func formsQuestionareDataRecived(){
        self.tableView.reloadData()
        viewModel?.getFormDetail(questionId: questionId)
    }
    
    func updatedFormDataSuccessfully(){
        self.view.showToast(message: "Form Data Updated Successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.view.ShowSpinner()
            self.viewModel?.getFormQuestionnaireData(questionnaireId: self.questionId)
        })
    }

    func questionRemovedSuccefully(mrssage: String) {
        self.view.showToast(message: mrssage, color: .red)
        viewModel?.getFormQuestionnaireData(questionnaireId: questionId)
    }

    func recevedImageData(){
        self.view?.HideSpinner()
        //self.backroundImage.image =
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension FormDetailViewController: FormDetailTableViewCellDelegate {
   
    func reloadForm(cell: FormDetailTableViewCell, index: IndexPath){
        tableView.beginUpdates()
        self.tableView.reloadRows(at: [index], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
    }
    
    func showRegexList(cell: FormDetailTableViewCell, sender: UIButton, index: IndexPath){
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: RegexList().regexArray, cellType: .subTitle) { (cell, list, indexPath) in
            cell.textLabel?.text = list
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.regexTextfield.text = ""
            cell.regexTextfield.text = selectedItem
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(RegexList().regexArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func deleteNotSsavedQuestion(cell: FormDetailTableViewCell, index: IndexPath) {
        viewModel?.removeFormData(index: index)
        self.tableView.deleteRows(at: [index], with: .automatic)
        self.tableView?.performBatchUpdates(nil, completion: nil)
        self.tableView.reloadData()
    }
    
    func saveFormData(item: [String : Any]) {
        self.view.ShowSpinner()
        viewModel?.updateQuestionFormData(questionnaireId: self.questionId, formData: item)
    }
}

extension FormDetailViewController: LeadQuestionnaireTableViewCellDelegate{
   
    func reloadForm(cell: LeadQuestionnaireTableViewCell, index: IndexPath) {
        tableView.beginUpdates()
        self.tableView.reloadRows(at: [index], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
    }
    
    func showRegexList(cell: LeadQuestionnaireTableViewCell, sender: UIButton, index: IndexPath) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: RegexList().regexArray, cellType: .subTitle) { (cell, list, indexPath) in
            cell.textLabel?.text = list
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.regexTextfield.text = ""
            cell.regexTextfield.text = selectedItem
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(RegexList().regexArray.count * 44))), arrowDirection: .up), from: self)
    }
    
   
    func deleteNotSsavedQuestion(cell: LeadQuestionnaireTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        viewModel?.removeFormData(index: index)
        self.tableView.deleteRows(at: [index], with: .automatic)
        self.tableView?.performBatchUpdates(nil, completion: nil)
        self.tableView.reloadData()
    }
    
}
