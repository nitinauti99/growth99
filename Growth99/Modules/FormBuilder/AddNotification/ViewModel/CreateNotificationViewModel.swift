//
//  CreateNotificationViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation

protocol CreateNotificationViewModelProtocol {
    func getCreateCreateNotification(questionId: Int)
    func createNotification(questionId: Int, params: [String: Any])
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
}

class CreateNotificationViewModel {
    var delegate: CreateNotificationViewContollerProtocol?
    var CreateNotificationData: [CreateNotificationModel] = []
    var notificationFilteListrData: [CreateNotificationModel] = []
        
    init(delegate: CreateNotificationViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func createNotification(questionId: Int, params: [String: Any]) {
        
        let finaleURL = ApiUrl.notificationList.appending("\(questionId)/notifications")

        self.requestManager.request(forPath: finaleURL, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: params, encoding: .jsonEncoding)) { (result: Result<CreateNotificationModel, GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                print(FormData)
                self.delegate?.createdNotificationSuccessfully(message: "Notification Created  Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getCreateCreateNotification(questionId: Int) {
        
    }
    
//    func getCreateCreateNotification(questionId: Int) {
//        let finaleURL = ""
//
//        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateNotificationModel], GrowthNetworkError>) in
//            switch result {
//            case .success(let CreateNotificationData):
//                self.CreateNotificationData = CreateNotificationData
//                self.delegate?.categoriesResponseReceived()
//            case .failure(let error):
//                self.delegate?.errorReceived(error: error.localizedDescription)
//                print("Error while performing request \(error)")
//            }
//        }
//    }
    
    func filterData(searchText: String) {
        self.CreateNotificationData = (self.CreateNotificationData.filter { $0.toEmail?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
   
    func getCreateNotificationDataAtIndexPath(index: Int) -> CreateNotificationModel? {
        return CreateNotificationData[index]

    }
    
    func getNotificationFilterDataAtIndexPath(index: Int) -> CreateNotificationModel? {
        return self.notificationFilteListrData[index]
    }

}

extension CreateNotificationViewModel: CreateNotificationViewModelProtocol {
 
    
    var getCreateNotificationData: [CreateNotificationModel] {
        return self.CreateNotificationData
    }
    
    var getNotificationFilterListData: [CreateNotificationModel] {
        return self.notificationFilteListrData
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 10 {
            return true
        }
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
