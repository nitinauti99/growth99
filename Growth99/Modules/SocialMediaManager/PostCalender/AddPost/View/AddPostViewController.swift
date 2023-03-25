//
//  AddPostViewController.swift
//  Growth99
//
//  Created by Apple on 17/03/23.
//

import UIKit

protocol AddPostViewControllerProtocol: AnyObject {
    func postLabelListRecived()
    func postSocialProfilesListRecived()
    func errorReceived(error: String)
    func postSocialProfilesListDataRecived(responseMessage: String)
}

class AddPostViewController: UIViewController, AddPostViewControllerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private weak var hastagTextField: UITextField!
    @IBOutlet private weak var labelTextField: UITextField!
    @IBOutlet private weak var scheduledDateTextField: CustomTextField!
    @IBOutlet private weak var scheduledTimeTextField: CustomTextField!
    @IBOutlet private weak var socialProfileTextField: UITextField!
    @IBOutlet private weak var postTextView: UITextView!
    @IBOutlet private weak var postWarningView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var contentViewHeightConstant: NSLayoutConstraint!
    @IBOutlet private weak var postWarningViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var addPostImageView: UIImageView!
    @IBOutlet private weak var addPostImageViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var addImagePickerBtn: UIButton!
    @IBOutlet private weak var addImageLibraryBtn: UIButton!
    @IBOutlet private weak var deleteImageButton: UIButton!
    @IBOutlet private weak var deleteImageButtonHeight: NSLayoutConstraint!
    @IBOutlet private weak var addImagePickerBtnHeight: NSLayoutConstraint!
    @IBOutlet private weak var addImageLibraryBtnHeight: NSLayoutConstraint!
    @IBOutlet private weak var addImagePickerBtnTop: NSLayoutConstraint!
    @IBOutlet private weak var addImageLibraryBtnTop: NSLayoutConstraint!

    var addPostCalenderViewModel: AddPostViewModelProtocol?
    
    var selectedPostLabelData: [LabelListModel] = []
    var selectedPostSocialProfiles: [SocialProfilesListModel] = []
    var selectedPostLabelIds = [Int]()
    var selectedPostSocialProfilesIds = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        postTextView.layer.borderColor = UIColor.gray.cgColor
        postTextView.layer.borderWidth = 1.0
        scheduledDateTextField.tintColor = .clear
        scheduledTimeTextField.tintColor = .clear
        scheduledDateTextField.addInputViewDatePicker(target: self, selector: #selector(scheduledDateBtnPressed), mode: .date)
        scheduledTimeTextField.addInputViewDatePicker(target: self, selector: #selector(scheduledTimeBtnPressed), mode: .time)
        addPostCalenderViewModel = AddPostViewModel(delegate: self)
        getSocialProfileList()
    }
    
    // MARK: - Date from picker done method
    @objc func scheduledDateBtnPressed() {
        scheduledDateTextField.text = addPostCalenderViewModel?.dateFormatterString(textField: scheduledDateTextField)
    }
    
    // MARK: - Time to picker done method
    @objc func scheduledTimeBtnPressed() {
        scheduledTimeTextField.text = addPostCalenderViewModel?.timeFormatterString(textField: scheduledTimeTextField)
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = "Add Post"
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(closeEventClicked), imageName: "iconCircleCross")
    }
    
    func getSocialProfileList() {
        self.view.ShowSpinner()
        addPostCalenderViewModel?.getPostLabelList()
    }
    
    func postLabelListRecived() {
        addPostCalenderViewModel?.getPostSocialProfilesList()
    }
    
    func postSocialProfilesListDataRecived(responseMessage: String) {
        
    }
    
    func postSocialProfilesListRecived() {
        if addPostCalenderViewModel?.getPostSocialProfilesListData.count == 0 {
            postWarningViewHeight.constant = 100
            contentViewHeightConstant.constant = 900
        } else {
            showDeleteButton(btnHidden: true, btnHeight: 0)
            postWarningViewHeight.constant = 0
            contentViewHeightConstant.constant = 950
        }
        self.view.HideSpinner()
    }
    
    func errorReceived(error: String) {
        
    }
    
    @objc func closeEventClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectLabelBtn(sender: UIButton) {
        let postLabels = addPostCalenderViewModel?.getPostLabelData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: postLabels, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedPostLabelData) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.labelTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedPostLabelData  = selectedList
            self?.selectedPostLabelIds = selectedId
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(postLabels.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectSocialProfileBtn(sender: UIButton) {
        let postSocialProfile = addPostCalenderViewModel?.getPostSocialProfilesListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: postSocialProfile, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedPostSocialProfiles) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.socialProfileTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedPostSocialProfiles  = selectedList
            self?.selectedPostSocialProfilesIds = selectedId
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(postSocialProfile.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectImagePickerBtn(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imgData = NSData(data: (selectedImage).jpegData(compressionQuality: 1)!)
            let imageSize: Int = imgData.count
            print("size of image in MB: %f ", (Double(imageSize) / 1024.0 / 1024).rounded())
            addPostImageView.image  = selectedImage
            adjustUI(postImageViewHeight: 200, contentViewHeight: 1000, pickerBtnTop: 0, libraryBtnTop: 0, pickerBtnHeight: 0, libraryBtnHeight: 0)
            showDeleteButton(btnHidden: false, btnHeight: 30)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        deleteImagefromView()
        dismiss(animated: true, completion: nil)
    }
    
    func adjustUI(postImageViewHeight: CGFloat,contentViewHeight: CGFloat, pickerBtnTop: CGFloat, libraryBtnTop: CGFloat, pickerBtnHeight: CGFloat, libraryBtnHeight: CGFloat ) {
        addPostImageViewHeight.constant = postImageViewHeight
        contentViewHeightConstant.constant = contentViewHeight
        addImagePickerBtnTop.constant = pickerBtnTop
        addImageLibraryBtnTop.constant = libraryBtnTop
        addImagePickerBtnHeight.constant = pickerBtnHeight
        addImageLibraryBtnHeight.constant = libraryBtnHeight
    }
    
    func showDeleteButton(btnHidden: Bool, btnHeight: CGFloat) {
        deleteImageButton.isHidden = btnHidden
        deleteImageButtonHeight.constant = btnHeight
    }
    
    func deleteImagefromView() {
        adjustUI(postImageViewHeight: 0, contentViewHeight: 900, pickerBtnTop: 10, libraryBtnTop: 15, pickerBtnHeight: 40, libraryBtnHeight: 40)
        showDeleteButton(btnHidden: true, btnHeight: 0)
    }
    
    
    @IBAction func selectLibraryImagePickerBtn(sender: UIButton) {
       
    }
    
    @IBAction func deleteImagePickerBtn(sender: UIButton) {
        let alert = UIAlertController(title: "Growth99", message: "Are you sure you want to delete Image", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.deleteImagefromView()
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        addPostCalenderViewModel?.uploadSelectedPostImage(image: addPostImageView.image!)
    }
}
