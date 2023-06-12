//
//  ScrapeWebsiteViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit


protocol ScrapeWebsiteViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func scrapeWebsiteDataUpdatedSuccessfully()
}

class ScrapeWebsiteViewController: UIViewController, ScrapeWebsiteViewControllerProtocol {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveUrlTextField: CustomTextField!

    var viewModel: ScrapeWebsiteViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ScrapeWebsiteViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.users
        self.saveButton.roundCorners(corners: [.allCorners], radius: 10)
        let scrapWebsiteUrl = UserDefaults.standard.string(forKey: "scrapWebsiteUrl")
        saveUrlTextField.text = scrapWebsiteUrl
    }
    
    func errorReceived(error: String){
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
   
    func scrapeWebsiteDataUpdatedSuccessfully(){
        self.view.HideSpinner()
        self.view.showToast(message: "URL submitted for scrapping you will see in question in questionnaires", color: UIColor().successMessageColor())
    }
    
    @IBAction func saveButton(sender: UIButton) {
        guard let textField = saveUrlTextField.text, !textField.isEmpty else {
            self.saveUrlTextField.showError(message: "URL is required.")
            return
        }
        self.view.ShowSpinner()
        viewModel?.updateChatConfigData(url: saveUrlTextField.text ?? "")
    }
}


extension ScrapeWebsiteViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if textField == saveUrlTextField {
            guard let textField = saveUrlTextField.text, !textField.isEmpty else {
                self.saveUrlTextField.showError(message: "URL is required.")
                return
            }
        }
        
    }
}
