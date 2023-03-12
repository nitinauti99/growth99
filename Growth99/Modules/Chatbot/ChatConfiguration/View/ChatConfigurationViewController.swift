//
//  ChatbotViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import UIKit

protocol ChatConfigurationViewControllerProtocol: AnyObject {
    func chatConfigurationDataRecived()
    func errorReceived(error: String)
    func chatConfigurationDataUpdatedSuccessfully()

}


class ChatConfigurationViewController: UIViewController, ChatConfigurationViewControllerProtocol {
    
    @IBOutlet weak var botName: CustomTextField!
    @IBOutlet weak var privacyLink: CustomTextField!
    @IBOutlet weak var defaultWelcomeMessage: CustomTextView!
    @IBOutlet weak var formMessage: CustomTextView!
    @IBOutlet weak var welcomeMessage: CustomTextView!
    @IBOutlet weak var faqNotFoundMessage: CustomTextView!
    @IBOutlet weak var appointmentBookingUrl: CustomTextField!
    @IBOutlet weak var enableAppointment: UIButton!
    @IBOutlet weak var enableInPersonAppointment: UIButton!
    @IBOutlet weak var enableVirtualAppointment: UIButton!

    /// set appointMent time
    @IBOutlet weak var morningStartTime: CustomTextField!
    @IBOutlet weak var morningEndTime: CustomTextField!

    @IBOutlet weak var noonStartTime: CustomTextField!
    @IBOutlet weak var noonEndTime: CustomTextField!
    
    @IBOutlet weak var eveningStartTime: CustomTextField!
    @IBOutlet weak var eveningEndTime: CustomTextField!
    
    ///
    @IBOutlet weak var weeksToShow: CustomTextField!
    @IBOutlet weak var longCodePhoneNumber: CustomTextField!

    @IBOutlet weak var poweredByText: CustomTextField!
    @IBOutlet weak var showPoweredBy: UIButton!

    @IBOutlet weak var isChatbotStatic: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var appointmentViewHight: NSLayoutConstraint!
    @IBOutlet weak var appointmentView: UIView!

    @IBOutlet weak var showPoweredChatbotFooterViewHight: NSLayoutConstraint!
    @IBOutlet weak var showPoweredChatbotFooterView: UIView!

    var viewModel: ChatConfigurationViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ChatConfigurationViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.users
        self.saveButton.roundCorners(corners: [.allCorners], radius: 10)
        self.view.ShowSpinner()
        self.viewModel?.getChatConfigurationDataList()
    }

    func chatConfigurationDataRecived() {
        self.view.HideSpinner()
        self.setUPUI()
    }
    
    @IBAction func enableAppointment(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            self.appointmentViewHight.constant = 0
            self.appointmentView.isHidden = true
        } else {
            sender.isSelected = true
            self.appointmentViewHight.constant = 390
            self.appointmentView.isHidden = false
        }
    }
    
    @IBAction func showPoweredChatbotFooter(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            self.showPoweredChatbotFooterView.isHidden = true
            self.showPoweredChatbotFooterViewHight.constant = 0
        } else {
            sender.isSelected = true
            self.showPoweredChatbotFooterView.isHidden = false
            self.showPoweredChatbotFooterViewHight.constant = 100
        }
    }
    
    func setUPUI(){
        let item = viewModel?.getChatConfigurationData
        self.appointmentViewHight.constant = 0
        self.appointmentView.isHidden = true
        if item?.enableAppointment == true {
            self.appointmentViewHight.constant = 390
            self.appointmentView.isHidden = false
        }
        
        self.showPoweredChatbotFooterView.isHidden = true
        self.showPoweredChatbotFooterViewHight.constant = 0
        
        if item?.showPoweredBy == true {
            self.showPoweredChatbotFooterView.isHidden = false
            self.showPoweredChatbotFooterViewHight.constant = 100
        }
        
        self.botName.text = item?.botName
        self.privacyLink.text = item?.privacyLink
        self.defaultWelcomeMessage.text = item?.defaultWelcomeMessage
        self.formMessage.text = item?.formMessage
        self.welcomeMessage.text = item?.welcomeMessage
        self.faqNotFoundMessage.text = item?.faqNotFoundMessage
        self.appointmentBookingUrl.text = item?.appointmentBookingUrl
        self.enableAppointment.isSelected = item?.enableAppointment ?? false
        self.enableInPersonAppointment.isSelected = item?.enableInPersonAppointment ?? false
        self.enableVirtualAppointment.isSelected = item?.enableVirtualAppointment ?? false
        
        self.morningStartTime.text = item?.morningStartTime
        self.morningEndTime.text = item?.morningEndTime
        self.noonStartTime.text = item?.noonStartTime
        self.noonEndTime.text = item?.noonEndTime
        self.eveningStartTime.text = item?.eveningStartTime
        self.eveningEndTime.text = item?.eveningEndTime
        
        self.weeksToShow.text = String(item?.weeksToShow ?? 0)
        self.longCodePhoneNumber.text = item?.longCodePhoneNumber
        self.poweredByText.text = item?.poweredByText
        self.showPoweredBy.isSelected = item?.showPoweredBy ?? false
        self.isChatbotStatic.isSelected = item?.isChatbotStatic ?? false
    }
    
    func chatConfigurationDataUpdatedSuccessfully(){
        self.viewModel?.getChatConfigurationDataList()
    }
    
    @IBAction func saveButtonAction(sender: UIButton){
        let param: [String: Any] = [
            "botName": self.botName.text ?? "",
            "privacyLink": self.privacyLink.text ?? "",
            "defaultWelcomeMessage": self.defaultWelcomeMessage.text ?? "",
            "formMessage": formMessage.text ?? "",
            "welcomeMessage": welcomeMessage.text ?? "",
            "faqNotFoundMessage": faqNotFoundMessage.text ?? "",
            "appointmentBookingUrl": appointmentBookingUrl.text ?? "",
            "enableInPersonAppointment": enableInPersonAppointment.isSelected,
            "morningStartTime": morningStartTime.text ?? "",
            "morningEndTime": morningEndTime.text ?? "",
            "noonStartTime": noonStartTime.text ?? "",
            "noonEndTime": noonEndTime.text ?? "",
            "eveningStartTime": eveningStartTime.text ?? "",
            "eveningEndTime": eveningEndTime.text ?? "",
            "weeksToShow": weeksToShow.text ?? "",
            "longCodePhoneNumber": longCodePhoneNumber.text ?? "",
            "poweredByText": poweredByText.text ?? "",
            "showPoweredBy": showPoweredBy.isSelected,
            "isChatbotStatic": isChatbotStatic.isSelected,
            "backgroundColor": viewModel?.getChatConfigurationData.backgroundColor ?? "",
            "foregroundColor": viewModel?.getChatConfigurationData.foregroundColor ?? "",
        ]
       
        self.view.ShowSpinner()
        viewModel?.updateChatConfigData(param: param)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
