//
//  AddPostViewModel.swift
//  Growth99
//
//  Created by Apple on 18/03/23.
//

protocol AddPostViewModelProtocol {
    func getPostLabelList()
    func getPostSocialProfilesList() 
    var  getPostLabelData: [LabelListModel] { get }
    var  getPostSocialProfilesListData: [SocialProfilesListModel] { get }
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
}

class AddPostViewModel: AddPostViewModelProtocol {
    var delegate: AddPostViewControllerProtocol?
    var postLabelList: [LabelListModel] = []
    var postSocialProfilesList: [SocialProfilesListModel] = []
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    
    init(delegate: AddPostViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getPostLabelList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostLabels, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LabelListModel], GrowthNetworkError>) in
            switch result {
            case .success(let postLabelList):
                self.postLabelList = postLabelList
                self.delegate?.postLabelListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getPostSocialProfilesList() {
        self.requestManager.request(forPath: ApiUrl.socialProfileList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[SocialProfilesListModel], GrowthNetworkError>) in
            switch result {
            case .success(let postSocialProfilesList):
                self.postSocialProfilesList = postSocialProfilesList
                self.delegate?.postSocialProfilesListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getPostLabelData: [LabelListModel] {
        return postLabelList
    }
    
    var  getPostSocialProfilesListData: [SocialProfilesListModel] {
        return postSocialProfilesList
    }
    
    func dateFormatterString(textField: CustomTextField) -> String {
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    func timeFormatterString(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
}
