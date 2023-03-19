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
                self.labelList = pateintsTagList
                self.delegate?.labelListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeLabel(LabelId: Int) {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostLabels.appending("/\(LabelId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.labelRemovedSuccefully(message: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
       self.labelFilterList = (self.labelList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
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
