//
//  PateintsTimeLineViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation

protocol PateintsTimeLineViewModelProtocol {
    func getPateintsTimeLineData(pateintsId: Int)
    func pateintsTimeLineDataAtIndex(index: Int)-> PateintsTimeLineModel?
    var getPateintsTimeLineData: [PateintsTimeLineModel]? { get }
}

class PateintsTimeLineViewModel {
    var pateintsTimeLineData: [PateintsTimeLineModel]?

    var delegate: PateintsTimeLineViewControllerProtocol?

    
    init(delegate: PateintsTimeLineViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)

    
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
    
    func pateintsTimeLineDataAtIndex(index: Int)-> PateintsTimeLineModel? {
        return self.pateintsTimeLineData?[index]
    }
}

extension PateintsTimeLineViewModel: PateintsTimeLineViewModelProtocol {
 
    var getPateintsTimeLineData: [PateintsTimeLineModel]? {
        return self.pateintsTimeLineData
    }

}
