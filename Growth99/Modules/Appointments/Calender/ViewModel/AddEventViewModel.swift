//
//  AddEventViewModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 18/01/23.
//

import Foundation

protocol AddEventViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
}

class AddEventViewModel {
    
    var delegate: AddEventViewControllerProtocol?
    
    init(delegate: AddEventViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
}

extension AddEventViewModel : AddEventViewModelProtocol {
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 10 {
            return true
        }
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
