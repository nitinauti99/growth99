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
    
    var viewModel: ChatConfigurationViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ChatConfigurationViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.users
        self.view.ShowSpinner()
        self.viewModel?.getChatConfigurationDataList()
    }

    func chatConfigurationDataRecived() {
        self.view.HideSpinner()
        self.setUPUI()
    }
    
    func setUPUI(){
        let item = viewModel?.getChatConfigurationData
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
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
