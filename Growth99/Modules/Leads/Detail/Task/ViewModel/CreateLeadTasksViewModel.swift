//
//  LeadTaskListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation

protocol CreateLeadTasksViewModelProtocol {
    ///get all task list
    func getTaskUserList()
    func taskUserListAtIndex(index: Int) -> TaskAllUserListModel?
    func isValidFirstName(_ firstName: String) -> Bool

    /// create patients user
    func createTaskUser(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, questionnaireSubmissionId: Int)
    
    var taskUserList: [TaskAllUserListModel] { get }
}

class CreateLeadTasksViewModel {
    var delegate: CreateLeadTasksViewControllerProtocol?
    var taskUserListArray: [TaskAllUserListModel] = []
    var taskPatientsListArray: [TaskPatientsListModel] = []
    var taskQuestionnaireSubmissionListArray: [TaskQuestionnaireSubmissionModel] = []

    init(delegate: CreateLeadTasksViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
   
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
    
    func createTaskUser(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, questionnaireSubmissionId: Int){
        let urlParameter: Parameters = [
            "name": name,
            "description": description,
            "workflowTaskStatus": workflowTaskStatus,
            "workflowTaskUser": workflowTaskUser,
            "deadline": deadline,
            "questionnaireSubmissionId": questionnaireSubmissionId,
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

extension CreateLeadTasksViewModel: CreateLeadTasksViewModelProtocol {
    var taskUserList: [TaskAllUserListModel] {
        return self.taskUserListArray
    }
    
    func taskUserListAtIndex(index: Int)-> TaskAllUserListModel? {
         return self.taskUserList[index]
     }
   
    func isValidFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
    
}
