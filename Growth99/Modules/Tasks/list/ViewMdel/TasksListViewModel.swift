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
    func getLeadTaskList(LeadId: Int)
    func taskDataAtIndex(index: Int) -> TaskDTOList?
    func taskFilterDataAtIndex(index: Int)-> TaskDTOList?
    func filterData(searchText: String)
    func removeTask(taskId: Int)
    
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
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
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
    
    func getLeadTaskList(LeadId: Int){
        self.requestManager.request(forPath:ApiUrl.leadTaskList.appending("\(LeadId)"), method: .GET, headers: self.requestManager.Headers()) {  (result: Result<TasksListModel, GrowthNetworkError>) in
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
    
    func removeTask(taskId: Int){
        let finaleUrl = ApiUrl.taskDetail.appending("\(taskId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.taskRemovedSuccefully(message: "Pateints removed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.taskFilterList = self.taskList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            let statusMatch = task.status?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let userNameMatch = task.userName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            return nameMatch || idMatch || statusMatch || userNameMatch
        }
    }
    
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var taskName: UILabel!
    @IBOutlet private weak var assignedTo: UILabel!
    @IBOutlet private weak var status: UILabel!
    
    
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
