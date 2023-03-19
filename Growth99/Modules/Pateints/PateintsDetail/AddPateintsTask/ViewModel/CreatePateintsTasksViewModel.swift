//
//  CreatePateintsTasksViewModel.swift
//  Growth99
//
//  Created by nitin auti on 28/01/23.
//

import Foundation

protocol CreatePateintsTasksViewModelProtocol {
    ///get all task list
    func getTaskUserList()
    var taskUserList: [TaskAllUserListModel] { get }
    func taskUserListAtIndex(index: Int) -> TaskAllUserListModel?
    
    /// create patients user
    func createTaskUser(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int)
}

class CreatePateintsTasksViewModel {
    var delegate: CreatePateintsTasksViewControllerProtocol?
    var taskUserListArray: [TaskAllUserListModel] = []
    var taskPatientsListArray: [TaskPatientsListModel] = []
    var taskQuestionnaireSubmissionListArray: [TaskQuestionnaireSubmissionModel] = []

    init(delegate: CreatePateintsTasksViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
   
    func getTaskUserList() {
        self.requestManager.request(forPath: ApiUrl.usersAll, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TaskAllUserListModel], GrowthNetworkError>) in
            switch result {
            case .success(let taskList):
                self.taskUserListArray = taskList
                self.delegate?.taskUserListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createTaskUser(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int){
        let urlParameter: Parameters = [
            "name": name,
            "description": description,
            "workflowTaskStatus": workflowTaskStatus,
            "workflowTaskUser": workflowTaskUser,
            "deadline": deadline,
            "workflowTaskPatient": workflowTaskPatient ,
            "questionnaireSubmissionId": NSNull(),
        ]
        
        self.requestManager.request(forPath: ApiUrl.createTaskUser, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.taskUserCreatedSuccessfully(responseMessage: "task User Created Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }

}

extension CreatePateintsTasksViewModel: CreatePateintsTasksViewModelProtocol {
    var taskUserList: [TaskAllUserListModel] {
        return self.taskUserListArray
    }
    
    func taskUserListAtIndex(index: Int)-> TaskAllUserListModel? {
         return self.taskUserList[index]
     }
   
}
