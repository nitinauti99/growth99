//
//  TasksListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/01/23.
//

import Foundation

protocol TasksListViewModelProtocol {
    func getTasksList()
    func getPateintTaskList(pateintId: Int)
    func taskDataAtIndex(index: Int) -> TaskDTOList?
    func taskFilterDataAtIndex(index: Int)-> TaskDTOList?
    func filterData(searchText: String)
    var getTaskData: [TaskDTOList] { get }
    var getTaskFilterData: [TaskDTOList] { get }
}

class TasksListViewModel {
    var delegate: TasksListViewControllerProtocol?
    var taskList: [TaskDTOList] = []
    var taskFilterList: [TaskDTOList] = []
    
    init(delegate: TasksListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getTasksList() {
        self.requestManager.request(forPath: ApiUrl.workflowtasks, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<TasksListModel, GrowthNetworkError>) in
            switch result {
            case .success(let taskList):
                self.taskList = taskList.taskDTOList.reversed()
                self.delegate?.tasksDataRecived()
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
                self.taskList = taskList.taskDTOList.reversed()
                self.delegate?.tasksDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func filterData(searchText: String) {
       self.taskFilterList = (self.taskList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func taskDataAtIndex(index: Int)-> TaskDTOList? {
        return self.taskList[index]
    }
    
    func taskFilterDataAtIndex(index: Int)-> TaskDTOList? {
        return self.taskFilterList[index]
    }
}

extension TasksListViewModel: TasksListViewModelProtocol {
  
    var getTaskFilterData: [TaskDTOList] {
        return self.taskFilterList
    }
    
    var getTaskData: [TaskDTOList] {
        return self.taskList
    }
}
