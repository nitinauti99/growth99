//
//  VacationViewModel.swift
//  Growth99
//
//  Created by admin on 26/11/22.
//

import Foundation

class VacationViewModel {
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var allClinicsforVacation: [Clinics]?
    
    var delegate: VacationScheduleViewControllerCProtocol?

    init(delegate: VacationScheduleViewControllerCProtocol? = nil) {
        self.delegate = delegate
    }

    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    func getallClinicsforVacation(completion: @escaping([Clinics]?, Error?) -> Void) {
        ServiceManager.request(request: ApiRouter.getRequestForAllClinics.urlRequest, responseType: [Clinics].self) { response in
            switch response {
            case .success(let allClinics):
                completion(allClinics, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
        
    func sendRequestforVacation(vacationParams: [String: Any]) {
        
        let apiURL = ApiUrl.vacationSubmit.appending("\(UserRepository.shared.userId ?? 0)/vacation-schedules")
        var headerFields: [HTTPHeader] {
            [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .custom(key: "Content-Type", value: "application/json"),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? ""))]
        }
        self.requestManager.request(forPath: apiURL, method: .POST, headers: headerFields, task: .requestParameters(parameters: vacationParams, encoding: .jsonEncoding)) { (result: Result<ResponseModel, FargoNetworkError>) in
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.apiResponseRecived(apiResponse: response)
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
    
    func dateFormatterString(textField: CustomTextField) -> String {
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todaysDate = Date()
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    func timeFormatterString(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }

}
