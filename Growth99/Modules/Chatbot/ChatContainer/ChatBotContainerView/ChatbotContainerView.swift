//
//  ChatbotContainerView.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

class ChatbotContainerView: UIViewController {
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var workflowLeadId = Int()
    var leadData: leadListModel?

    var selectedindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSegemtControl()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "changeLeadSegment") , object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.leadDetail
    }
    
    func setUpSegemtControl(){
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: Constant.Profile.chatConfiguration, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.scrapeWebsite, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.chatQuestionnaires, at: 2)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        segmentedControl.selectedSegmentIndex = selectedindex
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        self.selectedindex = segment
        self.segmentedControl.selectedSegmentIndex = self.selectedindex
        self.selectionDidChange(sender: segmentedControl)
    }
  
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: ScrapeWebsiteVC)
            remove(asChildViewController: chatQuestionnaireVC)
            add(asChildViewController: chatConfigurationVC)
            navigationItem.rightBarButtonItem = nil
        case 1:
            remove(asChildViewController: chatQuestionnaireVC)
            remove(asChildViewController: chatConfigurationVC)
            add(asChildViewController: ScrapeWebsiteVC)
            navigationItem.rightBarButtonItem = nil
        case 2:
            remove(asChildViewController: ScrapeWebsiteVC)
            remove(asChildViewController: chatConfigurationVC)
            add(asChildViewController: chatQuestionnaireVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(createChatQuestionariButtonTapped), imageName: "add")

        default:
            break
        }
    }
    
    static func viewController() -> ChatbotContainerView {
          return UIStoryboard.init(name: "ChatbotContainerView", bundle: nil).instantiateViewController(withIdentifier: "ChatbotContainerView") as! ChatbotContainerView
      }
    
    private lazy var chatConfigurationVC: ChatConfigurationViewController = {
        let detailController = UIStoryboard(name: "ChatConfigurationViewController", bundle: nil).instantiateViewController(withIdentifier: "ChatConfigurationViewController") as! ChatConfigurationViewController
        return detailController
    }()
    
    /// task for Pateints
    private lazy var ScrapeWebsiteVC: ScrapeWebsiteViewController = {
        let scrapeWebsiteList = UIStoryboard(name: "ScrapeWebsiteViewController", bundle: nil).instantiateViewController(withIdentifier: "ScrapeWebsiteViewController") as! ScrapeWebsiteViewController
        return scrapeWebsiteList
    }()
 
    /// Lead History
    private lazy var chatQuestionnaireVC: chatQuestionnaireViewContoller = {
        let chatQuestionnaire = UIStoryboard(name: "chatQuestionnaireViewContoller", bundle: nil).instantiateViewController(withIdentifier: "chatQuestionnaireViewContoller") as! chatQuestionnaireViewContoller
        return chatQuestionnaire
    }()
    
    @objc func createChatQuestionariButtonTapped(_ sender: UIButton){
        let createChatQuestionareVC = UIStoryboard(name: "CreateChatQuestionareViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateChatQuestionareViewController") as! CreateChatQuestionareViewController
       navigationController?.pushViewController(createChatQuestionareVC, animated: true)
    }
 
   /// add VC as child view contoller
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    /// remove VC from parent View
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
