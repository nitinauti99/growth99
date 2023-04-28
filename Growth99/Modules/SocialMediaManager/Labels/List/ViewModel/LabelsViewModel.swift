//
//  LabelsViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol LabelListViewModelProtocol {
    func getLabelList()
    func labelListDataAtIndex(index: Int) -> LabelListModel?
    func labelFilterListDataAtIndex(index: Int)-> LabelListModel?
    func removeLabel(LabelId: Int)
    func filterData(searchText: String)
    
    var getLabelData: [LabelListModel] { get }
    var getLabelFilterData: [LabelListModel] { get }
}

class LabelListViewModel {
    var delegate: LabelListViewControllerProtocol?
    
    var labelList: [LabelListModel] = []
    var labelFilterList: [LabelListModel] = []
    
    init(delegate: LabelListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getLabelList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostLabels, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LabelListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.labelList = pateintsTagList.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.labelListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeLabel(LabelId: Int) {
        self.requestManager.request(forPath: ApiUrl.createMediaPostLabels.appending("/\(LabelId)"), method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.labelRemovedSuccefully(message: "Post Label deleted successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.labelRemovedSuccefully(message: "The Label associated with post cannot be deleted")
                }else {
                    self.delegate?.errorReceived(error: "internal server error")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.labelFilterList = self.labelList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func labelListDataAtIndex(index: Int)-> LabelListModel? {
        return self.labelList[index]
    }
    
    func labelFilterListDataAtIndex(index: Int)-> LabelListModel? {
        return self.labelFilterList[index]
    }
}

extension LabelListViewModel: LabelListViewModelProtocol {
    
    var getLabelData: [LabelListModel] {
        return self.labelList
    }
    
    var getLabelFilterData: [LabelListModel] {
        return self.labelFilterList
    }
}
