//
//  BusinessDetailView.swift
//  Growth99
//
//  Created by nitin auti on 01/02/23.
//

import Foundation
import UIKit

class BusinessDetailView: UIViewController {
//    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var workflowTaskPatientId = Int()
    var selectedindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setupView()
        self.title = Constant.Profile.business
        segmentedControl.segmentStyle = .textOnly
        setupSegment1()
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        segmentedControl.selectedSegmentIndex = selectedindex
    }
    
    func setupSegment() {
        segmentedControl.insertSegment(withTitle: Constant.Profile.businessProfile, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.personalization, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.subdomain, at: 2)
        segmentedControl.insertSegment(withTitle: Constant.Profile.refundPolicy, at: 3)
        segmentedControl.insertSegment(withTitle: Constant.Profile.trackingCode, at: 4)
        segmentedControl.insertSegment(withTitle: Constant.Profile.dataStudio, at: 5)
        segmentedControl.insertSegment(withTitle: Constant.Profile.paidMedia, at: 6)
        segmentedControl.insertSegment(withTitle: Constant.Profile.syndicationReport, at: 7)
        segmentedControl.insertSegment(withTitle: Constant.Profile.emailSMSAudit, at: 8)
    }
    
    func setupSegment1() {
        segmentedControl.insertSegment(withTitle: Constant.Profile.businessProfile, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.subdomain, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.refundPolicy, at: 2)
        segmentedControl.insertSegment(withTitle: Constant.Profile.trackingCode, at: 3)
        segmentedControl.insertSegment(withTitle: Constant.Profile.dataStudio, at: 4)
        segmentedControl.insertSegment(withTitle: Constant.Profile.paidMedia, at: 5)
//        segmentedControl.insertSegment(withTitle: Constant.Profile.syndicationReport, at: 7)
//        segmentedControl.insertSegment(withTitle: Constant.Profile.emailSMSAudit, at: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "selectedIndex") , object: nil)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = segment
    }
   
    func setupView() {
        remove(asChildViewController: personalizationVC)
        remove(asChildViewController: subdomainVC)
        remove(asChildViewController: refundPolicyVC)
        remove(asChildViewController: trackingCodeVC)
        remove(asChildViewController: dataStudioVC)
        remove(asChildViewController: paidMediaVC)
        remove(asChildViewController: SyndicationReportVC)
        remove(asChildViewController: emailSMSAuditVC)
        add(asChildViewController: businessProfileVC)
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: businessProfileVC)
        case 1:
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: personalizationVC)
        case 2:
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: subdomainVC)
        case 3:
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: refundPolicyVC)
        case 4:
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: trackingCodeVC)
        case 5:
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: dataStudioVC)
        case 6:
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: SyndicationReportVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: paidMediaVC)
        case 7:
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: emailSMSAuditVC)
            add(asChildViewController: SyndicationReportVC)
        case 8:
            remove(asChildViewController: businessProfileVC)
            remove(asChildViewController: personalizationVC)
            remove(asChildViewController: subdomainVC)
            remove(asChildViewController: refundPolicyVC)
            remove(asChildViewController: trackingCodeVC)
            remove(asChildViewController: dataStudioVC)
            remove(asChildViewController: paidMediaVC)
            remove(asChildViewController: SyndicationReportVC)
            add(asChildViewController: emailSMSAuditVC)
        default:
            break
        }

    }
    
    @objc func assignNewConsentButtonTapped(_ sender: UIButton){
        let addNewConsentsVC = UIStoryboard(name: "AddNewConsentsViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewConsentsViewController") as! AddNewConsentsViewController
        navigationController?.pushViewController(addNewConsentsVC, animated: true)
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let addNewQuestionarieVC = UIStoryboard(name: "AddNewQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestionarieViewController") as! AddNewQuestionarieViewController
        navigationController?.pushViewController(addNewQuestionarieVC, animated: true)
    }
    
    @objc func addTaskTapped(_ sender: UIButton) {
        let createTasksVC = UIStoryboard(name: "CreateTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateTasksViewController") as! CreateTasksViewController
        navigationController?.pushViewController(createTasksVC, animated: true)

    }
    
    static func viewController() -> PeteintDetailView {
          return UIStoryboard.init(name: "PeteintDetailView", bundle: nil).instantiateViewController(withIdentifier: "PeteintDetailView") as! PeteintDetailView
      }
    
    private lazy var businessProfileVC: BusinessProfileViewController = {
        // Load Storyboard
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as? BusinessProfileViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    
    private lazy var personalizationVC: PersonalizationViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "PersonalizationViewController") as? PersonalizationViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private lazy var subdomainVC: SubdomainViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "SubdomainViewController") as? SubdomainViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private lazy var refundPolicyVC: RefundPolicyViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "RefundPolicyViewController") as? RefundPolicyViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()

    private lazy var trackingCodeVC: TrackingCodeViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "TrackingCodeViewController") as? TrackingCodeViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private lazy var dataStudioVC: DataStudioViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "DataStudioViewController") as? DataStudioViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private lazy var paidMediaVC: PaidMediaViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "PaidMediaViewController") as? PaidMediaViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private lazy var SyndicationReportVC: SyndicationReportViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "SyndicationReportViewController") as? SyndicationReportViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private lazy var emailSMSAuditVC: EmailSMSAuditViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "EmailSMSAuditViewController") as? EmailSMSAuditViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        return detailController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
}
