//
//  PateintsTimeLineViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation

protocol PateintsTimeLineViewModelProtocol {
    func getPateintsTimeLineData(pateintsId: Int)
    func getTimeLineTemplateData(pateintsId: Int)
    func pateintsTimeLineDataAtIndex(index: Int)-> PateintsTimeLineModel?
    var getPateintsTimeLineData: [PateintsTimeLineModel]? { get }
}

class PateintsTimeLineViewModel {
    var pateintsTimeLineData: [PateintsTimeLineModel]?

    var delegate: PateintsTimeLineViewControllerProtocol?

    
    init(delegate: PateintsTimeLineViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)

    
    func getPateintsTimeLineData(pateintsId: Int) {
        let finaleURL = ApiUrl.patentsTimeLine +  "\(pateintsId)"
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintsTimeLineModel], GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.pateintsTimeLineData = list
                self.delegate?.recivedPateintsTimeLineData()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTimeLineTemplateData(pateintsId: Int) {
        let finaleURL = "https://api.growthemr.com/api/v1/audit/appointment/json/content?id=" +  "\(pateintsId)"
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                print(list)
                //self.pateintsTimeLineData = list
                self.delegate?.recivedPateintsTimeLineData()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func pateintsTimeLineDataAtIndex(index: Int)-> PateintsTimeLineModel? {
        return self.pateintsTimeLineData?[index]
    }
}

extension PateintsTimeLineViewModel: PateintsTimeLineViewModelProtocol {
 
    var getPateintsTimeLineData: [PateintsTimeLineModel]? {
        return self.pateintsTimeLineData
    }

}
