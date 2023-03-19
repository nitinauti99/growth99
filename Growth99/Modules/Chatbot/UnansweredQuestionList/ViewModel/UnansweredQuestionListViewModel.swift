import Foundation

protocol UnansweredQuestionListViewModelProtocol {
    func getUnansweredQuestionList()
    func getUnansweredQuestionListDataAtIndex(index: Int) -> UnansweredQuestionListModel?
    func getUnansweredQuestionListFilterDataAtIndex(index: Int)-> UnansweredQuestionListModel?
    func filterData(searchText: String)
    
    var getUnansweredQuestionListData: [UnansweredQuestionListModel] { get }
    var getUnansweredQuestionFilterListData: [UnansweredQuestionListModel] { get }
}

class UnansweredQuestionListViewModel {
    var delegate: UnansweredQuestionListViewControllerProtocol?
    
    var unansweredQuestionList: [UnansweredQuestionListModel] = []
    var unansweredQuestionFilterList: [UnansweredQuestionListModel] = []
    
    init(delegate: UnansweredQuestionListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getUnansweredQuestionList() {
        self.requestManager.request(forPath: ApiUrl.UnansweredQuestionList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[UnansweredQuestionListModel], GrowthNetworkError>) in
            switch result {
            case .success(let unansweredQuestionList):
                self.unansweredQuestionList = unansweredQuestionList.reversed()
                self.delegate?.unansweredQuestionListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.unansweredQuestionFilterList = (self.unansweredQuestionList.filter { $0.question?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func getUnansweredQuestionListFilterDataAtIndex(index: Int) -> UnansweredQuestionListModel? {
        return self.unansweredQuestionFilterList[index]
    }
    
    func getUnansweredQuestionListDataAtIndex(index: Int)-> UnansweredQuestionListModel? {
        return self.unansweredQuestionList[index]
    }
}

extension UnansweredQuestionListViewModel: UnansweredQuestionListViewModelProtocol {
    
    var getUnansweredQuestionFilterListData: [UnansweredQuestionListModel] {
        return self.unansweredQuestionFilterList
    }
    
    var getUnansweredQuestionListData: [UnansweredQuestionListModel] {
        return self.unansweredQuestionList
    }
    
}
