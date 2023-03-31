//
//  CreatePostViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation
import UIKit

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
    
    @IBOutlet private weak var hashtagTextField: CustomTextField!
    @IBOutlet private weak var labelTextField: CustomTextField!
    @IBOutlet private weak var scheduleDateTextField: CustomTextField!
    @IBOutlet private weak var scheduleTimeTextField: CustomTextField!
    @IBOutlet private weak var socialChannelTextField: CustomTextField!
    @IBOutlet private weak var PostTextView: CustomTextView!
    @IBOutlet private weak var upLoadImageButton: UIButton!
    @IBOutlet private weak var selectFromLibButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewButtonHight: NSLayoutConstraint!

    var viewModel: CreatePostViewModelProtocol?
    var dateFormater: DateFormaterProtocol?
    var postId = Int()
    var selectedPostLabels = [Int]()
    var selectedSocialProfiles = [Int]()
    var screenName = ""
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
        self.scheduleDateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        
        self.scheduleTimeTextField.addInputViewDatePicker(target: self, selector: #selector(timeFromButtonPressed), mode: .time)
    }
    
    @objc func dateFromButtonPressed() {
        self.scheduleDateTextField.text = self.dateFormater?.dateFormatterString(textField: self.scheduleDateTextField)
    }
    
    @objc func timeFromButtonPressed() {
        self.scheduleTimeTextField.text = self.dateFormater?.timeFormatterString(textField: self.scheduleTimeTextField)
    }
    
    func setUpUI(){
        let item = viewModel?.getSocailPostData
        self.hashtagTextField.text = item?.hashtag
        let list: [String] = (item?.postLabels ?? []).map({$0.socialMediaPostLabel?.name ?? ""})
        self.labelTextField.text = list.joined(separator: ",")
        self.selectedPostLabel = (item?.postLabels ?? []).map({$0.socialMediaPostLabel!})
        
        let profileList: [String] = (item?.socialProfiles ?? []).map({$0.socialChannel ?? ""})
        self.socialChannelTextField.text = profileList.joined(separator: ",")
        self.selectedProfile = (item?.socialProfiles ?? []).map({$0})
        
        self.PostTextView.text = item?.post
        print(item?.scheduledDate)
        
        
    }
   
    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageFromLibButton(sender: UIButton) {
        let detailController = UIStoryboard(name: "PostImageListViewController", bundle: nil).instantiateViewController(withIdentifier: "PostImageListViewController") as! PostImageListViewController
        
        detailController.modalPresentationStyle = .overFullScreen
        detailController.delegate = self
        self.present(detailController, animated: true)
    }
    
    @IBAction func createTaskUser(sender: UIButton) {
        
        if let hashtagTextField = self.hashtagTextField.text,  hashtagTextField == "" {
            return
        }
        
        if let labelTextField = self.labelTextField.text,  labelTextField == "" {
            return
        }
        
        if let scheduleDateTextField = self.scheduleDateTextField.text,  scheduleDateTextField == "" {
            return
        }
        if let socialChannelTextField = self.socialChannelTextField.text,  socialChannelTextField == "" {
            return
        }
        
        self.view.ShowSpinner()
       
        guard let image = self.postImageView.image else { return  }
        let filename = "blob"
        let boundary = UUID().uuidString
        let socialMediaPostLabelId = self.selectedPostLabels.map { String($0) }.joined(separator: ",")
        let socialProfileIds = self.selectedSocialProfiles.map { String($0) }.joined(separator: ",")

        let str: String = (self.scheduleDateTextField.text ?? "") + " " + (self.scheduleTimeTextField.text ?? "")
        
        let scheduledDate = (dateFormater?.localToServerSocial(date: str)) ?? ""
                
        let name = ""
        let label = ""
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var url = String()
        var methodType = String()
        if  self.screenName == "Edit Screen" {
            url = "https://api.growthemr.com/api/socialMediaPost/\(postId)"
            methodType = "PUT"
        }else{
            url = "https://api.growthemr.com/api/socialMediaPost"
            methodType = "POST"
        }
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        
        urlRequest.addValue(UserRepository.shared.Xtenantid ?? String.blank, forHTTPHeaderField: "x-tenantid")
        urlRequest.addValue("Bearer "+(UserRepository.shared.authToken ?? String.blank), forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = methodType
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n \(name)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hashtag\"\r\n\r\n \(self.hashtagTextField.text ?? "")".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"label\"\r\n\r\n \(label)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"post\"\r\n\r\n \(self.PostTextView.text ?? "")".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"socialMediaPostLabelId\"\r\n\r\n \(socialMediaPostLabelId)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"scheduledDate\"\r\n\r\n \(String(describing: scheduledDate))".data(using: .utf8)!)

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"socialProfileIds\"\r\n\r\n \(socialProfileIds)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
                DispatchQueue.main.async {
                    self.view.HideSpinner()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }).resume()
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
        }else{
            self.view.HideSpinner()
        }
    }
    
    func socialPostRecived() {
        self.view.HideSpinner()
        self.setUpUI()
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
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
         }
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openSocialChanelListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.getSocialProfilesListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.socialChannel
        }
        selectionMenu.setSelectedItems(items: self.selectedProfile) { [weak self] (text, index, selected, selectedList) in
            self?.socialChannelTextField.text = selectedList.map({$0.socialChannel ?? String.blank}).joined(separator: ", ")
            self?.selectedSocialProfiles = selectedList.map({$0.id ?? 0})
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
