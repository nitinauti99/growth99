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
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: leadHistoryVC)
            remove(asChildViewController: combineTimeLineVC)
            add(asChildViewController: chatConfigurationVC)
            navigationItem.rightBarButtonItem = nil
        case 1:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: chatConfigurationVC)
            remove(asChildViewController: leadHistoryVC)
            remove(asChildViewController: combineTimeLineVC)
            add(asChildViewController: leadTimeLineVC)
            navigationItem.rightBarButtonItem = nil
        case 2:
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: chatConfigurationVC)
            remove(asChildViewController: leadHistoryVC)
            remove(asChildViewController: combineTimeLineVC)
            add(asChildViewController: tasksListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addTaskTapped), imageName: "add")
        case 3:
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: chatConfigurationVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: combineTimeLineVC)
            add(asChildViewController: leadHistoryVC)
            navigationItem.rightBarButtonItem = nil
        case 4:
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: chatConfigurationVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: leadHistoryVC)
            add(asChildViewController: combineTimeLineVC)
            navigationItem.rightBarButtonItem = nil
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
    
    /// questionarie for Pateints
    private lazy var leadTimeLineVC: leadTimeLineViewController = {
        let leadTimeLineVC = UIStoryboard(name: "leadTimeLineViewController", bundle: nil).instantiateViewController(withIdentifier: "leadTimeLineViewController") as! leadTimeLineViewController
        leadTimeLineVC.leadId = workflowLeadId
        return leadTimeLineVC
    }()
    
    /// task for Pateints
    private lazy var tasksListVC: TasksListViewController = {
        let tasksList = UIStoryboard(name: "TasksListViewController", bundle: nil).instantiateViewController(withIdentifier: "TasksListViewController") as! TasksListViewController
        tasksList.workflowTaskLeadId = workflowLeadId
        tasksList.screenTitile = "Lead Task"
        return tasksList
    }()
    
    @objc func addTaskTapped(_ sender: UIButton) {
        let createLeadTasksVC = UIStoryboard(name: "CreateLeadTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLeadTasksViewController") as! CreateLeadTasksViewController
        createLeadTasksVC.workflowTaskLeadId = workflowLeadId
        navigationController?.pushViewController(createLeadTasksVC, animated: true)
    }
    
    /// Lead History
    private lazy var leadHistoryVC: LeadHistoryViewController = {
        let leadHistoryList = UIStoryboard(name: "LeadHistoryViewController", bundle: nil).instantiateViewController(withIdentifier: "LeadHistoryViewController") as! LeadHistoryViewController
        return leadHistoryList
    }()
      
    /// LeadCombine TimeLine
    private lazy var combineTimeLineVC: CombineTimeLineViewController = {
        let combineTimeLineVC = UIStoryboard(name: "CombineTimeLineViewController", bundle: nil).instantiateViewController(withIdentifier: "CombineTimeLineViewController") as! CombineTimeLineViewController
        return combineTimeLineVC
    }()
    
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
