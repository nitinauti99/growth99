//
//  FormDetailViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 15/02/23.
//

import Foundation

protocol FormDetailViewModelProtocol {
    var getFormDetailData: [FormDetailModel] { get }
    var getFormFilterListData: [FormDetailModel] { get }
    func addFormDetailData(item: FormDetailModel)
    func removeFormData(index: IndexPath)
    func getFormDetail(questionId: Int)
    func filterData(searchText: String)
    func FormDataAtIndex(index: Int) -> FormDetailModel?
    func formFilterDataAtIndex(index: Int)-> FormDetailModel?
    func getFormQuestionnaireData(questionnaireId: Int)
    var  getFormQuestionnaireData: CreateFormModel? { get }
    func updateFormData(questionnaireId: Int,formData:[String: Any])
    func updateQuestionFormData(questionnaireId: Int,formData: [String: Any])
    func removeQuestions(questionId: Int, childQuestionId: Int)
    
}

class FormDetailViewModel {
    var delegate: FormDetailViewControllerProtocol?
    var formDetailData: [FormDetailModel] = []
    var FormFilterData: [FormDetailModel] = []
    var formQuestionnaireData: CreateFormModel?
    
    init(delegate: FormDetailViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getFormQuestionnaireData(questionnaireId: Int) {
        let finaleUrl = ApiUrl.questionnaireFormURL + "\(questionnaireId)"
        
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result<CreateFormModel, GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                print(FormData)
                self.formQuestionnaireData = FormData
                self.delegate?.formsQuestionareDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getFormDetail(questionId: Int) {
        let finaleURL = ApiUrl.fromDetail.appending("\(questionId)/questions")
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[FormDetailModel], GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                self.formDetailData = FormData
                self.delegate?.FormsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func updateFormData(questionnaireId: Int,formData:[String: Any]){
        let finaleURL = ApiUrl.fromDetail.appending("\(questionnaireId)")
        
        self.requestManager.request(forPath: finaleURL, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: formData, encoding: .jsonEncoding)) { (result: Result<CreateFormModel, GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                print(FormData)
                self.delegate?.updatedFormDataSuccessfully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func updateQuestionFormData(questionnaireId: Int,formData: [String: Any]){
        let finaleURL = ApiUrl.fromDetail.appending("\(questionnaireId)/questions")
        
        self.requestManager.request(forPath: finaleURL, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: formData, encoding: .jsonEncoding)) { (result: Result<CreateFormModel, GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                print(FormData)
                self.delegate?.updatedFormDataSuccessfully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    
    func removeQuestions(questionId: Int, childQuestionId: Int) {
        let finaleUrl = ApiUrl.fromDetail.appending("\(questionId)/questions/\(childQuestionId)")
        
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if(response.statusCode == 200){
                    self.delegate?.questionRemovedSuccefully(mrssage: "Consents removed successfully")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "To Delete These Consents Form, Please remove it for the service attched")
                } else{
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.FormFilterData = (self.formDetailData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.FormFilterData)
    }
    
    func formFilterDataAtIndex(index: Int) -> FormDetailModel? {
        return self.FormFilterData[index]
    }
    
    func FormDataAtIndex(index: Int)-> FormDetailModel? {
        return self.formDetailData[index]
    }
    
    func addFormDetailData(item: FormDetailModel){
        self.formDetailData.append(item)
    }
    
    func removeFormData(index: IndexPath){
        self.formDetailData.remove(at: index.row)
    }
}

extension FormDetailViewModel: FormDetailViewModelProtocol {
    
    var getFormQuestionnaireData: CreateFormModel? {
        return self.formQuestionnaireData
    }
    
    var getFormFilterListData: [FormDetailModel] {
        return self.FormFilterData
    }
    
    var getFormDetailData: [FormDetailModel] {
        return self.formDetailData
    }
    
}
