//
//  WorkingScheduleViewModel.swift
//  Growth99
//
//  Created by admin on 30/11/22.
//

import Foundation

class WorkingScheduleViewModel {
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var allClinicsforWorkingSchedule: [Clinics]?
    
    var delegate: WorkingScheduleViewControllerCProtocol?
    
    init(delegate: WorkingScheduleViewControllerCProtocol? = nil) {
        self.delegate = delegate
    }
        private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getallClinicsforWorkingSchedule(completion: @escaping([Clinics]?, Error?) -> Void) {
        ServiceManager.request(request: ApiRouter.getRequestForAllClinics.urlRequest, responseType: [Clinics].self) { response in
            switch response {
            case .success(let allClinics):
                completion(allClinics, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
