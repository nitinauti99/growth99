//
//  CreateNotificationViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation

protocol CreateNotificationViewModelProtocol {
    func getCreateCreateNotification(questionId: Int, notificationId: Int)
    func updateNotification(questionId: Int,notificationId: Int, params: [String: Any])
    func createNotification(questionId: Int, params: [String: Any])
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    var getgetNotificationData:CreateNotificationModel { get }
}

class CreateNotificationViewModel {
    var delegate: CreateNotificationViewContollerProtocol?
    var getNotificationData: CreateNotificationModel?
    
    init(delegate: CreateNotificationViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func createNotification(questionId: Int,params: [String: Any]) {
        
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
    
    func updateNotification(questionId: Int,notificationId: Int, params: [String: Any]) {
        
        let finaleURL = ApiUrl.notificationList.appending("\(questionId)/notifications/\(notificationId)")
        
        self.requestManager.request(forPath: finaleURL, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: params, encoding: .jsonEncoding)) { (result: Result<CreateNotificationModel, GrowthNetworkError>) in
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
    
    func getCreateCreateNotification(questionId: Int, notificationId: Int) {
        let finaleURL = ApiUrl.notificationList.appending("\(questionId)/notifications/\(notificationId)")
        
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<CreateNotificationModel, GrowthNetworkError>) in
            switch result {
            case .success(let getNotificationData):
                self.getNotificationData = getNotificationData
                self.delegate?.recivedNotificationData()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

}

extension CreateNotificationViewModel: CreateNotificationViewModelProtocol {
 
    
    var getgetNotificationData: CreateNotificationModel {
        return self.getNotificationData!
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
