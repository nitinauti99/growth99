//
//  EditTasksViewModel.swift
//  Growth99
//
//  Created by nitin auti on 15/01/23.
//

import Foundation

protocol EditTasksViewModelProtocol {
   /// get task
    func getTaskDetail(taskId: Int)
    var taskDetailData: EditTasksModel? { get }
    func serverToLocalDeadline(date: String) -> String

    ///get all task list
    func getTaskUserList()
    var taskUserList: [TaskAllUserListModel] { get }
    func taskUserListAtIndex(index: Int) -> TaskAllUserListModel?
    
    /// get all patients list
    func getTaskPatientsList()
    var taskPatientsList: [TaskPatientsListModel] { get }
    func taskPatientsListAtIndex(index: Int) -> TaskPatientsListModel?
    
    /// get all patients list
    func getQuestionnaireSubmissionList()
    var taskQuestionnaireSubmissionList: [TaskQuestionnaireSubmissionModel] { get }
    func taskQuestionnaireSubmissionListAtIndex(index: Int) -> TaskQuestionnaireSubmissionModel?
    
    /// create patients user
    func createTaskUser(patientId: Int, name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String)
}

class EditTasksViewModel {
    var delegate: EditTasksViewControllerProtocol?
    var taskUserListArray: [TaskAllUserListModel] = []
    var taskPatientsListArray: [TaskPatientsListModel] = []
    var taskQuestionnaireSubmissionListArray: [TaskQuestionnaireSubmissionModel] = []
    var tasDetailArray: EditTasksModel?
    
    init(delegate: EditTasksViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    func getTaskDetail(taskId: Int) {
        let finaleUrl = ApiUrl.taskDetail + "\(taskId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<EditTasksModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsList):
                self.tasDetailArray = pateintsList
                self.delegate?.receivedTaskDetail()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

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
    
    func getTaskPatientsList() {
        self.requestManager.request(forPath: ApiUrl.taskPatientsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TaskPatientsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let taskPatientsList):
                self.taskPatientsListArray = taskPatientsList
                self.delegate?.taskPatientsListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getQuestionnaireSubmissionList() {
        self.requestManager.request(forPath: ApiUrl.taskQuestionnaireSubmissionList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TaskQuestionnaireSubmissionModel], GrowthNetworkError>) in
            switch result {
            case .success(let taskQuestionnaireSubmissionList):
                self.taskQuestionnaireSubmissionListArray = taskQuestionnaireSubmissionList
                self.delegate?.taskQuestionnaireSubmissionListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createTaskUser(patientId: Int, name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String){
        var urlParameter: Parameters = [String: Any]()

        if workflowTaskPatient == 0 {
            urlParameter = [
                "name": name,
                "description": description,
                "workflowTaskStatus": workflowTaskStatus,
                "workflowTaskUser": workflowTaskUser,
                "deadline": deadline,
                "workflowTaskPatient": NSNull(),
                "questionnaireSubmissionId": questionnaireSubmissionId,
                "leadOrPatient": leadOrPatient,
            ]
        }else {
            urlParameter = [
                "name": name,
                "description": description,
                "workflowTaskStatus": workflowTaskStatus,
                "workflowTaskUser": workflowTaskUser,
                "deadline": deadline,
                "workflowTaskPatient": workflowTaskPatient,
                "questionnaireSubmissionId": NSNull(),
                "leadOrPatient": leadOrPatient,
            ]
        }
        let finalUrl = ApiUrl.createTaskUser.appending("/\(patientId)")
        
        self.requestManager.request(forPath: finalUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
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
    
    func serverToLocalDeadline(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date as Date)
    }
}

extension EditTasksViewModel: EditTasksViewModelProtocol {
    
    var taskDetailData: EditTasksModel? {
        return self.tasDetailArray
    }

    var taskUserList: [TaskAllUserListModel] {
        return self.taskUserListArray
    }
    
    func taskUserListAtIndex(index: Int)-> TaskAllUserListModel? {
         return self.taskUserList[index]
     }
    
    var taskPatientsList: [TaskPatientsListModel] {
        return self.taskPatientsListArray
    }
    
    func taskPatientsListAtIndex(index: Int) -> TaskPatientsListModel? {
        return self.taskPatientsListArray[index]
    }
    
    var taskQuestionnaireSubmissionList: [TaskQuestionnaireSubmissionModel] {
        return self.taskQuestionnaireSubmissionListArray
    }
    
    func taskQuestionnaireSubmissionListAtIndex(index: Int) -> TaskQuestionnaireSubmissionModel? {
        return self.taskQuestionnaireSubmissionListArray[index]
    }
   
}
