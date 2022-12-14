//
//  RegistrationViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/10/22.
//

import Foundation
import Alamofire

protocol RegistrationViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidPasswordAndReapeatPassword(_ password: String, _ repeatPassword: String) -> Bool
    func registration(firstName: String, lastName: String, email: String, phoneNumber: String, password: String, repeatPassword: String, businesName: String, agreeTerms: Bool)
}

class RegistrationViewModel {
    
    var delegate: RegistrationViewControllerProtocol?
    
    init(delegate: RegistrationViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func registration(firstName: String, lastName: String, email: String, phoneNumber: String, password: String, repeatPassword: String, businesName: String, agreeTerms: Bool) {
        
        let parameter: Parameters = ["firstName": firstName,
                                     "lastName": lastName,
                                     "email": email,
                                     "phone": phoneNumber,
                                     "password": password,
                                     "confirmPassword": repeatPassword,
                                     "businessName": businesName,
                                     "agreeTerms": agreeTerms
        ]
        
        self.requestManager.request(forPath: ApiUrl.register, method: .POST,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.delegate?.LoaginDataRecived()
                print("Successful Response", response)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension RegistrationViewModel : RegistrationViewModelProtocol {
   
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 12 {
            return true
        }
        return false
    }
    
    func isValidPasswordAndReapeatPassword(_ password: String, _ repeatPassword: String) -> Bool {
        if password == repeatPassword {
            return true
        }
        return false
    }
   
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^.*(?=.{8,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&?]).*$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)

        if passwordPred.evaluate(with: password) && password.count >= 8 {
            return true
        }
        return false
    }
    
}





//let url = URL(string: "https://api.growthemr.com/api/account/register")!
//var request = URLRequest(url: url)
//request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpMethod = "POST"
//let parameters: [String: Any] = [
//    "firstName": "test",
//    "lastName": "test",
//    "email": "tes123gdtet@test.com",
//    "password": "Password1@!",
//    "confirmPassword": "Password1@!",
//    "phone": "1111111111",
//    "businessName": "test business 123",
//    "agreeTerms": true,
//    "address": "Geeding Str, Gratis, OH 45381, USA"
//]
//let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//request.httpBody = jsonData
//
//let task = URLSession.shared.dataTask(with: request) { data, response, error in
//    guard
//        let responseData = data,
//        let response = response as? HTTPURLResponse,
//        error == nil
//    else {                                                               // check for fundamental networking error
//        print("error", error ?? URLError(.badServerResponse))
//        return
//    }
//
//    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//        print("statusCode should be 2xx, but is \(response.statusCode)")
//        print("response = \(response)")
//        return
//    }
//
//    // do whatever you want with the `data`, e.g.:
//
//    do {
//          // create json object from data or use JSONDecoder to convert to Model stuct
//          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
//            print(jsonResponse)
//            // handle json response
//          } else {
//            print("data maybe corrupted or in wrong format")
//            throw URLError(.badServerResponse)
//          }
//        } catch let error {
//          print(error.localizedDescription)
//        }
//}
//
//task.resume()
