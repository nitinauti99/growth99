//
//  FormDetailTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 16/02/23.
//

import UIKit

protocol FormDetailTableViewCellDelegate: AnyObject {
    func reloadForm(cell: FormDetailTableViewCell, index: IndexPath)
    func showRegexList(cell: FormDetailTableViewCell, sender: UIButton, index: IndexPath)
    func saveFormData(item: [String: Any])
    func deleteQuestion(name: String, id: Int)
    func deleteNotSsavedQuestion(cell: FormDetailTableViewCell, index: IndexPath)
}

class FormDetailTableViewCell: UITableViewCell, FormQuestionTableViewCellDelegate {
    
    @IBOutlet weak var questionNameTextfield: CustomTextField!
    @IBOutlet weak var requiredButton: UIButton!
    @IBOutlet weak var hiddenButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBOutlet weak var regexTextfield: CustomTextField!
    @IBOutlet weak var validationMessageTextfield: CustomTextField!
    
    @IBOutlet weak var backroundImageSelctionLBI: UILabel!
    @IBOutlet weak var inputBoxButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var yesNoButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var multipleSelectionButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var validationView: UIView!
    @IBOutlet weak var multipleSelectionView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHight: NSLayoutConstraint!
    @IBOutlet weak var multipleSelectionViewHight: NSLayoutConstraint!
    @IBOutlet weak var validationViewHight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHight: NSLayoutConstraint!
    
    /// multiple selection View
    @IBOutlet weak var multipleChoiceButton: UIButton!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var multipleChoiceView: UIView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var addQuestionView: UIView!
    
    @IBOutlet weak var multipleChoiceViewHight: NSLayoutConstraint!
    @IBOutlet weak var dropDownViewHight: NSLayoutConstraint!
    @IBOutlet weak var checkBoxViewHight: NSLayoutConstraint!
    @IBOutlet weak var addQuestionViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var multipleChoiceYESButton: UIButton!
    @IBOutlet weak var multipleChoiceNOButton: UIButton!
    @IBOutlet weak var dropDownYESButton: UIButton!
    @IBOutlet weak var dropDownNOButton: UIButton!
    @IBOutlet weak var selctedCheckBoxYESButton: UIButton!
    @IBOutlet weak var selectedCheckBoxNOButton: UIButton!
    
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var questionTableViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var deletButton: UIButton!
    @IBOutlet weak var deletButtonWidth: NSLayoutConstraint!

    @IBOutlet weak var bottomDeletButton: UIButton!
    @IBOutlet weak var bottomDeletButtonSepraterWidth: NSLayoutConstraint!

    var tableView: UITableView?
    var indexPath = IndexPath()
    var buttons = [UIButton]()
    var questionArray = [QuestionChoices]()
    var formList : FormDetailModel?
    weak var delegate: FormDetailTableViewCellDelegate?
    var crateQuestion = false
    var regexListArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Register TablView
        questionTableView.register(UINib(nibName: "FormQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "FormQuestionTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationCreateQuestion), name: Notification.Name("notificationCreateQuestion"), object: nil)
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        self.dissableUserIntraction()
        self.scrollView.delegate = self
        self.setUPInitialConstantValue()
    }
    
    /// setting initail values
    func setUPInitialConstantValue() {
        self.setUPButtonAction()
        self.hideMultipleSelctionView()
        self.bottomView.isHidden = true
        self.bottomViewHight.constant = 0
        self.questionTableViewHight.constant = 0
        self.questionTableView.isHidden = true
        self.validationViewHight.constant = 0
        self.validationView.isHidden = true
        self.multipleSelectionView.isHidden = true
        self.multipleChoiceNOButton.isSelected = false
        self.dropDownNOButton.isSelected = false
        self.selectedCheckBoxNOButton.isSelected = false
        self.editButton.isHidden = true
        self.saveButton.isHidden = true
        self.deletButton.isHidden = true
        self.crateQuestion = false
        self.bottomDeletButton.isHidden = true
    }
    
    /// when we are creating new question notification get called
    @objc func NotificationCreateQuestion(){
        self.validationViewHight.constant = 0
        self.crateQuestion = true
    }
    
    func hideMultipleSelctionView(){
        self.hideMultipleChocesView()
        self.hideDropDownView()
        self.hideCheckBoxView()
        self.hideAddQuestionView()
    }
    
    /// configure cell
    func configureCell(tableView: UITableView?, FormList: FormDetailViewModelProtocol?, index: IndexPath) {
        self.setUPUI(FormList, index)
        self.questionNameTextfield.placeholder = "New Question"
        self.saveButton.roundCorners(corners: [.allCorners], radius: 25)
        self.cancelButton.roundCorners(corners: [.allCorners], radius: 25)
        self.tableView = tableView
        self.questionTableView.reloadData()
        buttons = [inputBoxButton, textButton,yesNoButton,dateButton,multipleSelectionButton,fileButton]
        
    }
    
    /// based below condition we shwo delete button on form
    private func showDeleteReloadButton() {
        if formList?.name == "First Name" || formList?.name == "Last Name" || formList?.name == "Email" || formList?.name == "Phone Number" {
            self.editButton.isHidden = false // shwoing edit button
            self.deletButton.isHidden = true
            self.deletButtonWidth.constant = 0
        }else {
            self.editButton.isHidden = false // shwoing edit button
            self.deletButton.isHidden = false
        }
    }
    
    func showDeletebuttonOnAddQuestion(){
        if formList?.name == "First Name" || formList?.name == "Last Name" || formList?.name == "Email" || formList?.name == "Phone Number" {
            self.saveButton.isHidden = false
            self.cancelButton.isHidden = false
            self.bottomDeletButton.isHidden = true
        }else{
            self.saveButton.isHidden = false
            self.cancelButton.isHidden = false
            self.bottomDeletButton.isHidden = false
            self.bottomDeletButtonSepraterWidth.constant = 100
        }
    }
    
    @IBAction func openDropDownRegexList(sender: UIButton){
        delegate?.showRegexList(cell: self, sender: sender, index: indexPath)
    }
    
    /// setUp Data for UI
    func setUPUI(_ FormList: FormDetailViewModelProtocol?, _ index: IndexPath) {
        self.indexPath = index
        self.bottomDeletButton.isHidden = false
        self.dissableUserIntraction()
        self.formList = FormList?.FormDataAtIndex(index: index.row)
        self.questionNameTextfield.text = formList?.name
        self.requiredButton.isSelected = formList?.required ?? false
        self.hiddenButton.isSelected = formList?.hidden ?? false
        self.validateButton.isSelected = formList?.validate ?? false
        self.regexTextfield.text = getRegexTypeFromRegex(regex: formList?.regex ?? "")
        self.validationMessageTextfield.text = formList?.validationMessage
        self.selctionType(selctionType:formList?.type ?? String.blank)
        self.setUPInitialMultiselectionView()
        self.questionArray = formList?.questionChoices ?? []
        self.cancelButton.addTarget(self,
                                    action: #selector(self.cancelButtonAction(sender:)),
                                    for: .touchUpInside)

       
        if self.crateQuestion == true {
            self.saveButton.isHidden = false
            self.bottomDeletButton.isHidden = false
            self.bottomDeletButtonSepraterWidth.constant = 30
            self.editButton.isHidden = true
            self.cancelButton.isHidden = true
            self.hideValidationView()
            self.bottomView.isHidden = false
            self.bottomViewHight.constant = 76
            self.enableUserIntraction()
        }else{
            self.showDeleteReloadButton()
            self.saveButton.isHidden = true
            self.bottomDeletButton.isHidden = true
            self.bottomView.isHidden = true
            self.bottomViewHight.constant = 0
            self.editButton.isHidden = false

        }
        
        // based on below condtion we are shwoing validated:
        if formList?.validate == true {
            self.showValiDationView()
            self.saveButton.isHidden = true
            self.bottomDeletButton.isHidden = true
            self.bottomViewHight.constant = 0
            self.editButton.isHidden = false
        }
        
    }
    
    func showValiDationView(){
        self.validationViewHight.constant = 180
        self.validationView.isHidden = false
    }
    
    func hideValidationView(){
        self.validationViewHight.constant = 0
        self.validationView.isHidden = true
    }
    
    /// setUpMultipleSelectionValues
    private func setUPInitialMultiselectionView() {
        if formList?.allowMultipleSelection == true {
            self.multipleChoiceYESButton.isSelected = true
            self.multipleChoiceNOButton.isSelected = false
            self.hideDropDownView()
            self.hideCheckBoxView()
        }else{
            self.multipleChoiceYESButton.isSelected = false
            self.multipleChoiceNOButton.isSelected = true
        }
        
        if formList?.showDropDown == true {
            self.dropDownYESButton.isSelected = true
            self.dropDownNOButton.isSelected = false
            self.hideCheckBoxView()
        }else{
            self.dropDownYESButton.isSelected = false
            self.dropDownNOButton.isSelected = true
        }
        
        if formList?.preSelectCheckbox == true {
            self.selctedCheckBoxYESButton.isSelected = true
            self.selectedCheckBoxNOButton.isSelected = false
        }else{
            self.selctedCheckBoxYESButton.isSelected = false
            self.selectedCheckBoxNOButton.isSelected = true
        }
    }
    
    /// Disable all filed user intraction
    func dissableUserIntraction() {
        self.questionNameTextfield.isUserInteractionEnabled = false
        self.requiredButton.isUserInteractionEnabled = false
        self.hiddenButton.isUserInteractionEnabled = false
        self.validateButton.isUserInteractionEnabled = false
        self.validationMessageTextfield.isUserInteractionEnabled = false
        self.questionNameTextfield.isUserInteractionEnabled = false
        self.inputBoxButton.isUserInteractionEnabled = false
        self.textButton.isUserInteractionEnabled = false
        self.yesNoButton.isUserInteractionEnabled = false
        self.dateButton.isUserInteractionEnabled = false
        self.multipleSelectionButton.isUserInteractionEnabled = false
        self.fileButton.isUserInteractionEnabled = false
        self.regexTextfield.isUserInteractionEnabled = false
    }
    
    /// enable allfiled user intraction
    func enableUserIntraction() {
        self.questionNameTextfield.isUserInteractionEnabled = true
        self.requiredButton.isUserInteractionEnabled = true
        self.hiddenButton.isUserInteractionEnabled = true
        self.validateButton.isUserInteractionEnabled = true
        self.validationMessageTextfield.isUserInteractionEnabled = true
        self.questionNameTextfield.isUserInteractionEnabled = true
        self.inputBoxButton.isUserInteractionEnabled = true
        self.textButton.isUserInteractionEnabled = true
        self.yesNoButton.isUserInteractionEnabled = true
        self.dateButton.isUserInteractionEnabled = true
        self.multipleSelectionButton.isUserInteractionEnabled = true
        self.fileButton.isUserInteractionEnabled = true
        self.regexTextfield.isUserInteractionEnabled = true
    }
    
    func selctionType(selctionType: String){
        switch selctionType {
        case  "Input":
            self.inputBoxButton.isSelected = true
        case "Text":
            self.textButton.isSelected = true
        case "Yes_No":
            self.yesNoButton.isSelected = true
        case  "Date":
            self.dateButton.isSelected = true
        case "Multiple_Selection_Text":
            self.multipleSelectionButton.isSelected = true
        case "File":
            self.fileButton.isSelected = true
        default:
            break
        }
    }
    
    func getSelctionType() -> String {
        if self.inputBoxButton.isSelected == true {
            return "Input"
        }
        if self.textButton.isSelected == true {
            return "Text"
        }
        if self.yesNoButton.isSelected == true {
            return "Yes_No"
        }
        if self.dateButton.isSelected == true {
            return "Date"
        }
        if self.multipleSelectionButton.isSelected == true {
            return "Multiple_Selection_Text"
        }
        if self.fileButton.isSelected == true {
            return "File"
        }
        return ""
    }
    
    func getRegexForSelctionType(selctionType: String) -> String {
        switch selctionType {
        case  "Email":
            return "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$"
        case "Phone":
            return "^[1-9][0-9]{9}$"
        case "Name including white space":
            return "^[a-zA-Z]([a-zA-Z ]*)?$"
        case  "Name without space":
            return "^[a-zA-Z]*$"
        case "User name contain special character without space":
            return "^[^\n ]*$"
        case "Date validation dd/MM/yyyy or dd-MM-yyyy":
            return "^(0?[1-9]|[12][0-9]|3[01])[-/](0?[1-9]|1[012])[-/]((?:19|20|21)[0-9][0-9])$"
        case "Date validation MM/dd/yyyy or MM-dd-yyyy":
            return "^(0?[1-9]|1[012])[-/](0?[1-9]|[12][0-9]|3[01])[-/]((?:19|20|21)[0-9][0-9])$"
        case "Date validation yyyy/MM/dd or yyyy-MM-dd":
            return "^((?:19|20|21)[0-9][0-9])[-/](0?[1-9]|1[012])[-/](0?[1-9]|[12][0-9]|3[01])$"
        default:
            return ""
        }
    }
    
    func getRegexTypeFromRegex(regex: String) -> String {
        if regex == "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$"{
            return "Email"
        }
        
        if regex == "^[1-9][0-9]{9}$" {
            return "Phone"
        }
        
        if regex == "^[a-zA-Z]([a-zA-Z ]*)?$"{
            return "Name including white space"
        }
        
        if regex == "^[a-zA-Z]*$"{
            return "Name without space"
        }
        
        if regex == "^[^\n ]*$"{
            return "User name contain special character without space"
        }
        
        if regex == "^(0?[1-9]|[12][0-9]|3[01])[-/](0?[1-9]|1[012])[-/]((?:19|20|21)[0-9][0-9])$" {
            return "Date validation dd/MM/yyyy or dd-MM-yyyy"
        }
        
        if regex == "^(0?[1-9]|1[012])[-/](0?[1-9]|[12][0-9]|3[01])[-/]((?:19|20|21)[0-9][0-9])$" {
            return "Date validation MM/dd/yyyy or MM-dd-yyyy"
        }
        
        if regex == "^((?:19|20|21)[0-9][0-9])[-/](0?[1-9]|1[012])[-/](0?[1-9]|[12][0-9]|3[01])$" {
            return "Date validation yyyy/MM/dd or yyyy-MM-dd"
        }
        
        return ""
    }
    
    func setUPButtonAction(){
        inputBoxButton.addTarget(self, action: #selector(self.buttonAction(_ :)), for:.touchUpInside)
        textButton.addTarget(self, action: #selector(self.buttonAction(_ :)), for:.touchUpInside)
        yesNoButton.addTarget(self, action: #selector(self.buttonAction(_ :)), for:.touchUpInside)
        dateButton.addTarget(self, action: #selector(self.buttonAction(_ :)), for:.touchUpInside)
        multipleSelectionButton.addTarget(self, action: #selector(self.buttonAction(_ :)), for:.touchUpInside)
        fileButton.addTarget(self, action: #selector(self.buttonAction(_ :)), for:.touchUpInside)
    }
    
    /// set selected button based server data
    @objc func buttonAction(_ sender: UIButton!){
        for button in buttons {
            button.isSelected = false
            self.hideMutipleSelctionView()
        }
        sender.isSelected = true
        if sender.tag == 100 {
            self.multipleSelectionView.isHidden = false
            self.showMultSelctionView()
            self.tableView?.performBatchUpdates(nil, completion: nil)
        }
    }
    
    /// show mupltiple selcetion view
    func showMultSelctionView(){
        self.showMultipleChocesView()
        self.showDropDownView()
        self.showCheckBoxView()
        self.showAddQuestionView()
    }
    
    func hideMutipleSelctionView(){
        self.multipleSelectionView.isHidden = true
        self.questionTableViewHight.constant = 0
        self.questionTableView.isHidden = true
        self.hideMultipleSelctionView()
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }

    @IBAction func requiredButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func hiddenButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func validateButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.validationViewHight.constant = 0
            self.validationView.isHidden = true
        } else {
            sender.isSelected = true
            self.validationViewHight.constant = 180
            self.validationView.isHidden = false
        }
    }
    
    fileprivate func editButtonPressed() {
        self.bottomView.isHidden = false
        self.bottomViewHight.constant = 76
        self.enableUserIntraction()
        self.showDeletebuttonOnAddQuestion()
       
        if multipleSelectionButton.isSelected == true {
            self.multipleSelectionView.isHidden = false
            self.showMultSelctionView()
            self.setUPInitialMultiselectionView()
            self.questionTableView.isHidden = false
            self.questionTableViewHight.constant = CGFloat(questionArray.count * 120)
            self.questionTableView.reloadData()
            self.questionTableView?.performBatchUpdates(nil, completion: nil)
        }
    }
    
    /// edit button pressed it allow user to edit filed
    @IBAction func editButtonAction(sender: UIButton) {
        self.editButtonPressed()
       /// self.showDeletButton()
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.bottomView.isHidden = true
        self.bottomViewHight.constant = 0
        self.bottomDeletButton.isHidden = true
        self.dissableUserIntraction()
        self.hideMutipleSelctionView()
        delegate?.reloadForm(cell: self, index: indexPath)
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    /// multiple selction view
    @IBAction func multipleChoiceButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            self.buttonAction(sender)
        }
    }
    
    func hideMultipleChocesView(){
        multipleChoiceView.isHidden = true
        multipleChoiceViewHight.constant = 0
    }
    
    func showMultipleChocesView(){
        multipleChoiceView.isHidden = false
        multipleChoiceViewHight.constant = 90
    }
    
    @IBAction func dropDownButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            self.buttonAction(sender)
        }
    }
    
    func hideDropDownView(){
        dropDownView.isHidden = true
        dropDownViewHight.constant = 0
    }
    
    func showDropDownView(){
        dropDownView.isHidden = false
        dropDownViewHight.constant = 80
    }
    
    @IBAction func checkBoxButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            self.buttonAction(sender)
        }
    }
    
    func hideCheckBoxView(){
        checkBoxView.isHidden = true
        checkBoxViewHight.constant = 0
    }
    
    func showCheckBoxView(){
        checkBoxView.isHidden = false
        checkBoxViewHight.constant = 90
    }
    
    /// Hide/ show QuestionView
    func hideAddQuestionView(){
        addQuestionView.isHidden = true
        addQuestionViewHight.constant = 0
    }
    
    func showAddQuestionView(){
        addQuestionView.isHidden = false
        addQuestionViewHight.constant = 40
    }
    
    /// multiselction YES / No type
    @IBAction func multipleChoiceYESButton(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
            multipleChoiceNOButton.isSelected = false
            self.hideDropDownView()
            self.hideCheckBoxView()
        }
    }
    
    @IBAction func multipleChoiceNOButton(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
            multipleChoiceYESButton.isSelected = false
            showMultSelctionView()
        }
    }
    
    /// drop down selection
    @IBAction func dropDownYESButton(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
            dropDownNOButton.isSelected = false
            self.hideCheckBoxView()
        }
    }
    
    @IBAction func dropDownNOButton(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
            dropDownYESButton.isSelected = false
            showMultSelctionView()
        }
    }
    
    /// pre selctection checkBox selction
    @IBAction func preSelectCheckboxYESButton(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
            selectedCheckBoxNOButton.isSelected = false
        }
    }
    
    @IBAction func preSelectCheckboxNOButton(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
            selctedCheckBoxYESButton.isSelected = false
            showMultSelctionView()
        }
    }
    
    @IBAction func addMutiSelectionQuestionButton(sender: UIButton) {
        /// Create Empty Object for tableView To add row
        let createdBy = CreatedBy(firstName: "", lastName: "", email: "", username: "")
        let updatedBy =  UpdatedBy(firstName: "", lastName: "", email: "", username: "")
        let item  = QuestionChoices(deleted: false, id: 0, tenantId: 0, updatedBy: updatedBy, updatedAt: "", createdAt: "", createdBy: createdBy, name: "")
        
        self.questionArray.append(item)
        self.questionTableView.isHidden = false
        self.questionTableViewHight.constant = CGFloat(questionArray.count * 120)
        self.tableView?.performBatchUpdates(nil, completion: nil)
        self.questionTableView.reloadData()
    }
    
    /// Remove row from table view
    func deletRowFormCell(cell: FormQuestionTableViewCell, index: IndexPath) {
        self.questionArray.remove(at: index.row)
        questionTableViewHight.constant = CGFloat(questionArray.count * 120)
        self.questionTableView.deleteRows(at: [index], with: .automatic)
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func deleteButtonAction(sender: UIButton) {
        delegate?.deleteQuestion(name: formList?.name ?? "", id: formList?.id ?? 0)
    }
    
    @IBAction func deleteBottomButtonAction(sender: UIButton) {
        delegate?.deleteNotSsavedQuestion(cell: self, index: indexPath)
    }
    
    func updateMultiSelectionFromData() -> [String: Any]{
        var questionListArray = [Any]()
        for indexValue in 0..<(questionArray.count) {
            let cellIndexPath = IndexPath(item: indexValue, section: 0)
            var questionDict: [String: Any] = [:]
           
            if let cell = self.questionTableView.cellForRow(at: cellIndexPath) as? FormQuestionTableViewCell {
                questionDict["name"] = cell.questionNameTextfield.text
            }
            questionListArray.append(questionDict)
        }
        
        let formData: [String: Any] = [
            "name": self.questionNameTextfield.text ?? "",
            "type": getSelctionType(),
            "required": requiredButton.isSelected,
            "validate": validateButton.isSelected,
            "hidden": hiddenButton.isSelected,
            "regex": self.getRegexForSelctionType(selctionType: self.regexTextfield.text ?? ""),
            "questionOrder": formList?.questionOrder ?? 0,
            "answer": "",
            "id": formList?.id ?? 0,
            "allowLabelsDisplayWithImages": formList?.allowLabelsDisplayWithImages ?? false,
            "allowMultipleSelection": formList?.allowMultipleSelection ?? false,
            "questionChoices": questionListArray,
            "showDropDown": self.dropDownYESButton.isSelected,
            "preSelectCheckbox": self.selctedCheckBoxYESButton.isSelected,
            "questionImages": [],
        ]
        return formData
    }
    
    // need to check validation meesage
    func updateOtherTypeFromData() -> [String: Any]{
        let formData: [String: Any] = [
            "name": self.questionNameTextfield.text ?? "",
            "type": getSelctionType(),
            "required": requiredButton.isSelected,
            "hidden": hiddenButton.isSelected,
            "validate": validateButton.isSelected,
            "regex": self.getRegexForSelctionType(selctionType: self.regexTextfield.text ?? ""),
            "questionOrder": formList?.questionOrder ?? 0,
            "answer": "",
            "id": formList?.id ?? 0,
            "allowLabelsDisplayWithImages": formList?.allowLabelsDisplayWithImages ?? false,
            "allowMultipleSelection": formList?.allowMultipleSelection ?? false,
            "questionChoices": [],
            "questionImages": [],
            "validationMessage": self.validationMessageTextfield.text ?? ""
        ]
        return formData
    }
    
    private func updateFromData() -> [String: Any]{
        if getSelctionType() == "Multiple_Selection_Text" {
            return updateMultiSelectionFromData()
        }else {
            return updateOtherTypeFromData()
        }
    }
    @IBAction func saveFormData(sender: UIButton){
        self.bottomView.isHidden = true
        self.bottomViewHight.constant = 0
        self.dissableUserIntraction()
//        self.bottomDeletButton.isHidden = true
        var formData: [String: Any] = [:]
        
        if formList?.id == 0 {
            formData = self.saveFromData()
        }else{
            formData = self.updateFromData()
        }
        delegate?.saveFormData(item: formData)
    }
    
    func saveFromData() -> [String: Any] {
        if getSelctionType() == "Multiple_Selection_Text" {
            return saveMultiSelectionFromData()
        }else {
            return saveOtherTypeFromData()
        }
    }
    
    func saveMultiSelectionFromData() -> [String: Any]{
        var questionListArray = [Any]()
        for indexValue in 0..<(questionArray.count) {
            let cellIndexPath = IndexPath(item: indexValue, section: 0)
            var questionDict: [String: Any] = [:]
           
            if let cell = self.questionTableView.cellForRow(at: cellIndexPath) as? FormQuestionTableViewCell {
                questionDict["name"] = cell.questionNameTextfield.text
            }
            questionListArray.append(questionDict)
        }
        
        let formData: [String: Any] = [
            "name": self.questionNameTextfield.text ?? "",
            "type": getSelctionType(),
            "required": requiredButton.isSelected,
            "hidden": hiddenButton.isSelected,
            "validate": validateButton.isSelected,
            "regex": self.getRegexForSelctionType(selctionType: self.regexTextfield.text ?? ""),
            "questionOrder": self.indexPath.row + 1,
            "answer": "",
            "id": NSNull(),
            "allowLabelsDisplayWithImages": formList?.allowLabelsDisplayWithImages ?? false,
            "allowMultipleSelection": formList?.allowMultipleSelection ?? false,
            "questionChoices": questionListArray,
            "showDropDown": self.dropDownYESButton.isSelected,
            "preSelectCheckbox": self.selctedCheckBoxYESButton.isSelected,
            "questionImages": [],
        ]
        return formData
    }
    
    // need to check validation meesage
    func saveOtherTypeFromData() -> [String: Any]{
        let formData: [String: Any] = [
            "name": self.questionNameTextfield.text ?? "",
            "type": getSelctionType(),
            "required": requiredButton.isSelected,
            "hidden": hiddenButton.isSelected,
            "validate": validateButton.isSelected,
            "regex": self.getRegexForSelctionType(selctionType: self.regexTextfield.text ?? ""),
            "questionOrder": self.indexPath.row + 1,
            "answer": "",
            "id": NSNull(),
            "allowLabelsDisplayWithImages": formList?.allowLabelsDisplayWithImages ?? false,
            "allowMultipleSelection": formList?.allowMultipleSelection ?? false,
            "questionChoices": [ ],
            "questionImages": [],
            "validationMessage": self.validationMessageTextfield.text ?? ""
        ]
        return formData
    }
}

extension FormDetailTableViewCell: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}


