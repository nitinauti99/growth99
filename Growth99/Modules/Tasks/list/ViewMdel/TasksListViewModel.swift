//
//  TasksListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/01/23.
//

import Foundation

protocol TasksListViewModelProtocol {
    func getTaskList()
    func getPateintTaskList(pateintId: Int)
    var taskData: [TaskDTOList] { get }
    func taskDataAtIndex(index: Int) -> TaskDTOList?
    var taskFilterData: [TaskDTOList] { get }
    func taskFilterDataAtIndex(index: Int)-> TaskDTOList?
}

class TasksListViewModel {
    var delegate: TasksListViewControllerProtocol?
    var taskDTOList: [TaskDTOList] = []
    var taskFilterData: [TaskDTOList] = []
    
    init(delegate: TasksListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getTaskList() {
        self.requestManager.request(forPath: ApiUrl.workflowtasks, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<TasksListModel, GrowthNetworkError>) in
            switch result {
            case .success(let taskList):
                self.taskDTOList = taskList.taskDTOList.reversed()
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getPateintTaskList(pateintId: Int){
        self.requestManager.request(forPath: ApiUrl.workflowPatientTasks.appending("\(pateintId)"), method: .GET, headers: self.requestManager.Headers()) {  (result: Result<TasksListModel, GrowthNetworkError>) in
            switch result {
            case .success(let taskList):
                self.taskDTOList = taskList.taskDTOList.reversed()
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func taskDataAtIndex(index: Int)-> TaskDTOList? {
        return self.taskDTOList[index]
    }
    
    func taskFilterDataAtIndex(index: Int)-> TaskDTOList? {
        return self.taskDTOList[index]
    }
}

extension TasksListViewModel: TasksListViewModelProtocol {
  
    var TaskFilterDataData: [TaskDTOList] {
        return self.taskFilterData
    }
    
    var taskData: [TaskDTOList] {
        return self.taskDTOList
    }
}
