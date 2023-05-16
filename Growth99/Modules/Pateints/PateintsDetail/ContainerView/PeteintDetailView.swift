//
//  PeteintDetailView.swift
//  Growth99
//
//  Created by nitin auti on 01/02/23.
//

import Foundation
import UIKit

class PeteintDetailView: UIViewController {
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var workflowTaskPatientId = Int()
    var pateintsEmail = String()
    var selectedindex = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSegemtControl()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "changeSegment") , object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.patientDetail
    }
    
    func setUpSegemtControl(){
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: Constant.Profile.patientDetail, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.Questionnarie, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.tasks, at: 2)
        segmentedControl.insertSegment(withTitle: Constant.Profile.Consents, at: 3)
        segmentedControl.insertSegment(withTitle: Constant.Profile.appointmentDetail, at: 4)
        segmentedControl.insertSegment(withTitle: Constant.Profile.timeLineDetail, at: 5)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        segmentedControl.selectedSegmentIndex = selectedindex
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = segment
        self.selectionDidChange(sender: segmentedControl)
    }
  
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: pateintDetailVC)
            navigationItem.rightBarButtonItem = nil
        case 1:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: pateintDetailVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: questionarieVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addQuestionariButtonTapped), imageName: "add")
        case 2:
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: pateintDetailVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: tasksListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addTaskTapped), imageName: "add")
        case 3:
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: pateintDetailVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: consentsListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addNewConsentButtonTapped), imageName: "add")
        case 4:
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: pateintDetailVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateinstTimeLineVC)
            add(asChildViewController: pateintsAppointmentListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addAppointMentButtonTapped), imageName: "add")
        case 5:
            remove(asChildViewController: pateintDetailVC)
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: pateintsAppointmentListVC)
            add(asChildViewController: pateinstTimeLineVC)
            navigationItem.rightBarButtonItem = nil
        default:
            break
        }
    }
    
    static func viewController() -> PeteintDetailView {
          return UIStoryboard.init(name: "PeteintDetailView", bundle: nil).instantiateViewController(withIdentifier: "PeteintDetailView") as! PeteintDetailView
      }
    
    private lazy var pateintDetailVC: PateintDetailViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "PateintDetailViewController") as? PateintDetailViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        detailController.workflowTaskPatientId = workflowTaskPatientId
        return detailController
    }()
    
    /// questionarie for Pateints
    private lazy var questionarieVC: QuestionarieViewController = {
        let questionarieList = UIStoryboard(name: "QuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "QuestionarieViewController") as! QuestionarieViewController
        questionarieList.pateintId = workflowTaskPatientId
        return questionarieList
    }()
    
    @objc func addQuestionariButtonTapped(_ sender: UIButton) {
        let addNewQuestionarieVC = UIStoryboard(name: "AddNewQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestionarieViewController") as! AddNewQuestionarieViewController
        addNewQuestionarieVC.pateintId = workflowTaskPatientId
        navigationController?.pushViewController(addNewQuestionarieVC, animated: true)
    }
    
    /// task for Pateints
    private lazy var tasksListVC: TasksListViewController = {
        let tasksList = UIStoryboard(name: "TasksListViewController", bundle: nil).instantiateViewController(withIdentifier: "TasksListViewController") as! TasksListViewController
        tasksList.workflowTaskPatientId = workflowTaskPatientId
        tasksList.screenTitile = "Patient Task"
        return tasksList
    }()
    
    @objc func addTaskTapped(_ sender: UIButton) {
        let createPateintsTasksVC = UIStoryboard(name: "CreatePateintsTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintsTasksViewController") as! CreatePateintsTasksViewController
        createPateintsTasksVC.workflowTaskPatient = workflowTaskPatientId
        navigationController?.pushViewController(createPateintsTasksVC, animated: true)
    }
    
    /// Consents for Pateints
    private lazy var consentsListVC: ConsentsListViewController = {
        let consentsList = UIStoryboard(name: "ConsentsListViewController", bundle: nil).instantiateViewController(withIdentifier: "ConsentsListViewController") as! ConsentsListViewController
        consentsList.pateintId = workflowTaskPatientId
        return consentsList
    }()
    
    @objc func addNewConsentButtonTapped(_ sender: UIButton){
        let addNewConsentsVC = UIStoryboard(name: "AddNewConsentsViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewConsentsViewController") as! AddNewConsentsViewController
        addNewConsentsVC.pateintId = workflowTaskPatientId
        navigationController?.pushViewController(addNewConsentsVC, animated: true)
    }
    
    /// Appointmen for Pateints
    private lazy var pateintsAppointmentListVC: PatientAppointmentViewController = {
        let patientAppointmentList = UIStoryboard(name: "PatientAppointmentViewController", bundle: nil).instantiateViewController(withIdentifier: "PatientAppointmentViewController") as! PatientAppointmentViewController
        patientAppointmentList.pateintId = workflowTaskPatientId
        return patientAppointmentList
    }()
    
    @objc func addAppointMentButtonTapped(_ sender: UIButton){
        let addEventVC = UIStoryboard(name: "AddEventViewController", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        addEventVC.screenTitile = "Patients Appointment"
        addEventVC.userSelectedDate = "Manual"
        addEventVC.pateintsEmail = pateintsEmail
        navigationController?.pushViewController(addEventVC, animated: true)
    }
  
    /// pateints TimeLine
    private lazy var pateinstTimeLineVC: PateintsTimeLineViewController = {
        let pateintsTimeLineVC = UIStoryboard(name: "PateintsTimeLineViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTimeLineViewController") as! PateintsTimeLineViewController
        pateintsTimeLineVC.pateintsId = workflowTaskPatientId
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
