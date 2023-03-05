//
//  LeadDetailContainerView.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

class LeadDetailContainerView: UIViewController {
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var workflowLeadId = Int()
    var selectedindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSegemtControl()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "changeSegment") , object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.leadDetail
    }
    
    func setUpSegemtControl(){
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: Constant.Profile.leadDetail, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.leadTimeLine, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.leadTask, at: 2)
        segmentedControl.insertSegment(withTitle: Constant.Profile.leadHistory, at: 3)
        segmentedControl.insertSegment(withTitle: Constant.Profile.leadCombinedTimeLine, at: 4)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        segmentedControl.selectedSegmentIndex = selectedindex
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        self.selectedindex = segment
        self.selectionDidChange(sender: segmentedControl)
    }
  
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: leadDetailVC)
            navigationItem.rightBarButtonItem = nil
        case 1:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: leadDetailVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: leadTimeLineVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addQuestionariButtonTapped), imageName: "add")
        case 2:
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: leadDetailVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: tasksListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addTaskTapped), imageName: "add")
        case 3:
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: leadDetailVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: consentsListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addNewConsentButtonTapped), imageName: "add")
        case 4:
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: leadDetailVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: pateintsAppointmentListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addAppointMentButtonTapped), imageName: "add")
        case 5:
            remove(asChildViewController: leadDetailVC)
            remove(asChildViewController: leadTimeLineVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            add(asChildViewController: pateinstTimeLineVC)
            navigationItem.rightBarButtonItem = nil
        default:
            break
        }
    }
    
    static func viewController() -> LeadDetailContainerView {
          return UIStoryboard.init(name: "LeadDetailContainerView", bundle: nil).instantiateViewController(withIdentifier: "LeadDetailContainerView") as! LeadDetailContainerView
      }
    
    private lazy var leadDetailVC: leadDetailViewController = {
        let detailController = UIStoryboard(name: "leadDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "leadDetailViewController") as! leadDetailViewController
        detailController.leadId = workflowLeadId
        return detailController
    }()
    
    /// questionarie for Pateints
    private lazy var leadTimeLineVC: leadTimeLineViewController = {
        let leadTimeLineVC = UIStoryboard(name: "leadTimeLineViewController", bundle: nil).instantiateViewController(withIdentifier: "leadTimeLineViewController") as! leadTimeLineViewController
        leadTimeLineVC.leadId = workflowLeadId
        return leadTimeLineVC
    }()
    
    @objc func addQuestionariButtonTapped(_ sender: UIButton) {
        let addNewQuestionarieVC = UIStoryboard(name: "AddNewQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestionarieViewController") as! AddNewQuestionarieViewController
        addNewQuestionarieVC.pateintId = workflowLeadId
        navigationController?.pushViewController(addNewQuestionarieVC, animated: true)
    }
    
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
    
    /// Consents for Pateints
    private lazy var consentsListVC: ConsentsListViewController = {
        let consentsList = UIStoryboard(name: "ConsentsListViewController", bundle: nil).instantiateViewController(withIdentifier: "ConsentsListViewController") as! ConsentsListViewController
        consentsList.pateintId = workflowLeadId
        return consentsList
    }()
    
    @objc func addNewConsentButtonTapped(_ sender: UIButton){
        let addNewConsentsVC = UIStoryboard(name: "AddNewConsentsViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewConsentsViewController") as! AddNewConsentsViewController
        navigationController?.pushViewController(addNewConsentsVC, animated: true)
    }
    
    /// Appointmen for Pateints
    private lazy var pateintsAppointmentListVC: PatientAppointmentViewController = {
        let patientAppointmentList = UIStoryboard(name: "PatientAppointmentViewController", bundle: nil).instantiateViewController(withIdentifier: "PatientAppointmentViewController") as! PatientAppointmentViewController
        patientAppointmentList.pateintId = workflowLeadId
        return patientAppointmentList
    }()
    
    @objc func addAppointMentButtonTapped(_ sender: UIButton){
        let addEventVC = UIStoryboard(name: "AddEventViewController", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        addEventVC.screenTitile = "Pateints Appointment"
        addEventVC.userSelectedDate = "Manual"
        navigationController?.pushViewController(addEventVC, animated: true)
    }
  
    /// pateints TimeLine
    private lazy var pateinstTimeLineVC: PateintsTimeLineViewController = {
        let pateintsTimeLineVC = UIStoryboard(name: "PateintsTimeLineViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTimeLineViewController") as! PateintsTimeLineViewController
        pateintsTimeLineVC.pateintsId = workflowLeadId
        return pateintsTimeLineVC
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
