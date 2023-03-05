//
//  LeadHistoryViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation

protocol LeadHistoryViewModelProtocol {
    func getLeadHistory()
    func leadHistoryDataAtIndex(index: Int) -> LeadHistoryModel?
    func leadHistoryFilterDataAtIndex(index: Int)-> LeadHistoryModel?
    func filterData(searchText: String)
  
    var  getLeadHistroyData: [LeadHistoryModel] { get }
    var  getLeadHistroyFilterData: [LeadHistoryModel] { get }
}

class LeadHistoryViewModel {
    var delegate: LeadHistoryViewControllerProtocol?
    var leadHistroyData: [LeadHistoryModel] = []
    var leadHistroyFilterData: [LeadHistoryModel] = []
    let user = UserRepository.shared

    init(delegate: LeadHistoryViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getLeadHistory() {
        let finaleURL = ApiUrl.getLeadHistory.appending("\(self.user.primaryEmailId ?? "")")
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LeadHistoryModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.leadHistroyData = userData.reversed()
                self.delegate?.LeadHistoryDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.leadHistroyFilterData = (self.leadHistroyData.filter { $0.firstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
          print(self.leadHistroyFilterData)
    }
    
    func leadHistoryDataAtIndex(index: Int)-> LeadHistoryModel? {
        return self.leadHistroyData[index]
    }
    
    func leadHistoryFilterDataAtIndex(index: Int)-> LeadHistoryModel? {
        return self.leadHistroyFilterData[index]
    }
}

extension LeadHistoryViewModel: LeadHistoryViewModelProtocol {
   
    var getLeadHistroyFilterData: [LeadHistoryModel] {
         return self.leadHistroyFilterData
    }

    var getLeadHistroyData: [LeadHistoryModel] {
        return self.leadHistroyData
    }
}
