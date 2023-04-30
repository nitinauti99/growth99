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
    func uploadSelectedPostImage(image: UIImage)
    func isValidHashTag(_ text: String)-> Bool
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
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
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
    
    func uploadSelectedPostImage(image: UIImage) {
        self.requestManager.request(requestable: AddPostImage.upload(image: image.pngData() ?? Data())) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.postSocialProfilesListDataRecived(responseMessage: "Information updated sucessfully")
                } else {
                    self.delegate?.postSocialProfilesListDataRecived(responseMessage: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
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
    
    func isValidHashTag(_ text: String) -> Bool {
        let pattern = "^#[a-zA-Z0-9_]+$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.matches(in: text, range: range)
        return !matches.isEmpty
    }
}

enum AddPostImage {
    case upload(image: Data)
}

extension AddPostImage: Requestable {
    
    var baseURL: String {
        EndPoints.baseURL
    }
    
    var headerFields: [HTTPHeader]? {
        [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .custom(key: "Content-Type", value: "application/json"),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? String.blank))]
    }
    
    var requestMode: RequestMode {
        .noAuth
    }
    
    var path: String {
        "/api/socialMediaPost"
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var task: RequestTask {
        switch self {
        case let .upload(data):
            let multipartFormData = [MultipartFormData(formDataType: .data(Data()), fieldName: "", name: "name"),
                                     MultipartFormData(formDataType: .data(Data()), fieldName: "#Test 5555", name: "hashtag"),
                                     MultipartFormData(formDataType: .data(Data()), fieldName: "", name: "label"),
                                     MultipartFormData(formDataType: .data(Data()), fieldName: "Sample 324435354", name: "post"),
                                     MultipartFormData(formDataType: .data(Data()), fieldName: "3102,3209", name: "socialMediaPostLabelId"),
                                     MultipartFormData(formDataType: .data(Data()), fieldName: "2023-03-25 12:57:00 +0530", name: "scheduledDate"),
                                     MultipartFormData(formDataType: .data(Data()), fieldName: "729,728", name: "socialProfileIds"),
                                     MultipartFormData(formDataType: .data(data), fieldName: "blob", name: "files", mimeType: "image/png")]
            return .multipartUpload(multipartFormData)
        }
    }
}
