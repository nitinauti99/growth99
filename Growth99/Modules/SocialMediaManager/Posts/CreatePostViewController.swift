//
//  CreatePostViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation
import UIKit
import SDWebImage

protocol PostImageListViewControllerDelegateProtocol: AnyObject {
    func getSocialPostImageListDataAtIndex(content: Content)
}

protocol CreatePostViewControllerProtocol: AnyObject {
    func socialMediaPostLabelsListRecived()
    func socialProfilesListRecived()
    func socialPostRecived()
    func errorReceived(error: String)
    func taskUserCreatedSuccessfully(responseMessage: String)
}

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var hashtagTextField: CustomTextField!
    @IBOutlet weak var labelTextField: CustomTextField!
    @IBOutlet private weak var scheduleDateTextField: CustomTextField!
    @IBOutlet weak var scheduleTimeTextField: CustomTextField!
    @IBOutlet weak var socialChannelTextField: CustomTextField!
    @IBOutlet private weak var PostTextView: CustomTextView!
    @IBOutlet weak var upLoadImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectFromLibButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewButtonHight: NSLayoutConstraint!

    var viewModel: CreatePostViewModelProtocol?
    var dateFormater: DateFormaterProtocol?
    var postId = Int()
    var selectedPostLabels = [Int]()
    var selectedSocialProfiles = [Int]()
    var screenName = ""
    var isPosted = false

    var selectedPostLabel = [SocialMediaPostLabelsList]()
    var selectedProfile = [SocialProfilesList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreatePostViewModel(delegate: self)
        self.dateFormater = DateFormater()
        self.postImageView.isHidden = true
        self.postImageViewButtonHight.constant = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getSocialMediaPostLabelsList()
        scheduleDateTextField.tintColor = .clear
        scheduleTimeTextField.tintColor = .clear
        scheduleDateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        scheduleTimeTextField.addInputViewDatePicker(target: self, selector: #selector(timeFromButtonPressed), mode: .time)
        saveButton.isUserInteractionEnabled = true
        if isPosted == true {
            saveButton.isUserInteractionEnabled = false
        }
        if self.screenName == "Edit" {
            self.title = "Edit Post"
        } else {
            self.title = "Create Post"
        }
    }
    
    @objc func dateFromButtonPressed() {
        self.scheduleDateTextField.text = self.dateFormater?.dateFormatterString(textField: self.scheduleDateTextField)
    }
    
    @objc func timeFromButtonPressed() {
        self.scheduleTimeTextField.text = self.dateFormater?.timeFormatterString(textField: self.scheduleTimeTextField)
    }
    
    func setUpUI() {
        let item = viewModel?.getSocailPostData
        if item?.sent == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        self.hashtagTextField.text = item?.hashtag
        let list: [String] = (item?.postLabels ?? []).map({$0.socialMediaPostLabel?.name ?? ""})
        self.labelTextField.text = list.joined(separator: ",")
        
        let profileList: [String] = (item?.socialProfiles ?? []).map({$0.socialChannel ?? ""})
        self.socialChannelTextField.text = profileList.joined(separator: ",")
       
        self.selectedProfile = (item?.socialProfiles ?? []).map({$0})
        self.selectedPostLabel = (item?.postLabels ?? []).map({$0.socialMediaPostLabel!})

        self.selectedSocialProfiles = (item?.socialProfiles ?? []).map({$0.id ?? 0})
        self.selectedPostLabels = (item?.postLabels ?? []).map({$0.socialMediaPostLabel?.id ?? 0})

        let dateString = self.dateFormater?.serverToLocalDateConverter(date: (item?.scheduledDate) ?? "").components(separatedBy: " ")

        if dateString != nil {
            self.scheduleDateTextField.text = dateString?[0]
            self.scheduleTimeTextField.text = dateString?[1].appending(" " + (dateString?[2] ?? ""))
        }
        
        if (item?.socialMediaPostImages?.count ?? 0) >= 1 {
            self.postImageView.sd_setImage(with: URL(string: item?.socialMediaPostImages?[0].location ?? ""), placeholderImage: UIImage(named: "growthCircleIcon"), context: nil)
            self.postImageViewButtonHight.constant = 150
            self.postImageView.isHidden = false
            self.upLoadImageButton.setTitle("Remove", for: .normal)
            self.selectFromLibButton.isHidden = true
        }
        self.PostTextView.text = item?.post
    }
   
    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageFromLibButton(sender: UIButton) {
        let detailController = UIStoryboard(name: "PostImageListViewController", bundle: nil).instantiateViewController(withIdentifier: "PostImageListViewController") as! PostImageListViewController
        
        detailController.modalPresentationStyle = .overFullScreen
        detailController.delegate = self
        self.postImageView.image  = nil
        self.present(detailController, animated: true)
    }
    
    @IBAction func createTaskUser(sender: UIButton) {
        
        if let hashtagTextField = self.hashtagTextField.text,  hashtagTextField == "" {
            self.hashtagTextField.showError(message: Constant.ErrorMessage.hashTagEmptyError)
            return
        }
        
        if let isHashtagValid =  self.viewModel?.isValidHashTag(self.hashtagTextField.text ?? ""), isHashtagValid == false  {
            hashtagTextField.showError(message: Constant.ErrorMessage.hashTagInvalidError)
            return
        }
        
        if let labelTextField = self.labelTextField.text,  labelTextField == "" {
            self.labelTextField.showError(message: "Label is required")
            return
        }
        
        if let scheduleDateTextField = self.scheduleDateTextField.text, scheduleDateTextField == "" {
            self.scheduleDateTextField.showError(message: "Schedule date is required")
            return
        }
        
        if let scheduleTimeTextField = self.scheduleTimeTextField.text, scheduleTimeTextField == "" {
            self.scheduleTimeTextField.showError(message: "Schedule time is required")
            return
        }
        
        if let socialChannelTextField = self.socialChannelTextField.text, socialChannelTextField == "" {
            self.socialChannelTextField.showError(message: "Social channel is required")
            return
        }
        
        self.view.ShowSpinner()
        let image = self.postImageView.image ?? UIImage()
        
        let socialMediaPostLabelId = self.selectedPostLabels.map { String($0) }.joined(separator: ",")
        let socialProfileIds = self.selectedSocialProfiles.map { String($0) }.joined(separator: ",")
        
        let str: String = (self.scheduleDateTextField.text ?? "") + " " + (self.scheduleTimeTextField.text ?? "")
        
        let scheduledDate = (dateFormater?.serverToLocalDateConverter(date: str)) ?? ""
        
        var url = String()
        var methodType = String()
        
        if self.screenName == "Edit" {
            url = ApiUrl.socialMediaPost.appending("/\(postId)")
            methodType = "PUT"
        } else {
            url = ApiUrl.socialMediaPost
            methodType = "POST"
        }
        
        let urlParameter: Parameters = [
            "hashtag": self.hashtagTextField.text ?? "",
            "socialMediaPostLabelId": socialMediaPostLabelId,
            "post": self.PostTextView.text ?? "",
            "scheduledDate": scheduledDate,
            "socialProfileIds": socialProfileIds
        ]
        
        let request = ImageUploader(uploadImage: image, parameters: urlParameter, url: URL(string: url)!, method: methodType)
        request.uploadImage { (result) in
   
        DispatchQueue.main.async {
            self.view.HideSpinner()
            switch result {
            case .success(let value):
                print(value)
                if self.screenName == "Edit" {
                    self.view.showToast(message: "Social media post updated successfully.", color: UIColor().successMessageColor())
                } else {
                    self.view.showToast(message: "Social media post created successfully.", color: UIColor().successMessageColor())
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
     }
   }
}

extension CreatePostViewController: CreatePostViewControllerProtocol {
  
    /// received social-profiles list
    func socialMediaPostLabelsListRecived(){
        self.viewModel?.getSocialProfilesList()
    }
    
    func socialProfilesListRecived(){
        if screenName == "Edit" {
            self.viewModel?.getSocialPost(postId: postId)
        } else {
            self.view.HideSpinner()
        }
    }
    
    func socialPostRecived() {
        self.view.HideSpinner()
        self.setUpUI()
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreatePostViewController {
   
    @IBAction func openLabelListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.getSocialMediaPostLabelsListData ?? []
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.name
        }
       
        selectionMenu.setSelectedItems(items: self.selectedPostLabel) { [weak self] (text, index, selected, selectedList) in
            self?.labelTextField.text  = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedPostLabels = selectedList.map({$0.id ?? 0})
            self?.selectedPostLabel = selectedList
            if selectedList.count == 0 {
                self?.labelTextField.showError(message: "Label is required")
            }
         }
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openSocialChanelListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.getSocialProfilesListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.name
        }
        selectionMenu.setSelectedItems(items: self.selectedProfile) { [weak self] (text, index, selected, selectedList) in
            self?.socialChannelTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedSocialProfiles = selectedList.map({$0.id ?? 0})
            self?.selectedProfile = selectedList
            if selectedList.count == 0 {
                self?.socialChannelTextField.showError(message: "Social Channel is required")
            }
        }
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
}

extension CreatePostViewController: PostImageListViewControllerDelegateProtocol {
   
    func getSocialPostImageListDataAtIndex(content: Content) {
        self.postImageView.sd_setImage(with: URL(string:content.location ?? ""), placeholderImage: UIImage(named: "logo"), context: nil)
        self.postImageView.isHidden = false
        self.postImageViewButtonHight.constant = 150
    }

}
