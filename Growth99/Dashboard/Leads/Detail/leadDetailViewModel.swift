////
////  leadDetailViewModel.swift
////  Growth99
////
////  Created by nitin auti on 21/12/22.
////
//
//import Foundation
//
//protocol leadDetailViewProtocol {
//    func getLeadDetail(questionnaireId: Int)
//    var leadUserData: [leadModel] { get }
//    var leadTotalCount: Int { get }
//    func leadDataAtIndex(index: Int) -> leadModel?
//}
//
//class leadDetailViewModel {
//    var delegate: leadViewControllerProtocol?
//    var leadData: [leadModel] = []
//    var leadPeginationListData: [leadModel]?
//    var totalCount: Int = 0
//    init(delegate: leadViewControllerProtocol? = nil) {
//        self.delegate = delegate
//    }
//    
//    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
//    
//    func getLeadDetail(questionnaireId: Int) {
//        let finaleUrl = ApiUrl.updateQuestionnaireSubmission + "\(questionnaireId)"
//        
//        self.requestManager.request(forPath: finaleUrl, method: .PATCH, headers: self.requestManager.Headers()) {  [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let data):
//                print(data)
//                self.delegate?.LeadDataRecived()
//            case .failure(let error):
//                self.delegate?.errorReceived(error: error.localizedDescription)
//                print("Error while performing request \(error)")
//            }
//        }
//    }
//    
//   
//}
//
//extension leadDetailViewModel: leadDetailViewProtocol {
//   
//    var leadTotalCount: Int {
//        return totalCount
//    }
//    func leadDataAtIndex(index: Int) -> leadModel? {
//        
//    }
//    
//    var leadUserData: [leadModel] {
//        return self.leadPeginationListData ?? []
//    }
//}
