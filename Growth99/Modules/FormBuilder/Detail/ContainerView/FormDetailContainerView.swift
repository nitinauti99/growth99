//
//  FormDetailContainerView.swift
//  Growth99
//
//  Created by Nitin Auti on 15/02/23.
//

import Foundation
import UIKit

class FormDetailContainerView: UIViewController {
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var workflowFormId = Int()
    var selectedindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setupView()
        self.title = Constant.Profile.designer
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: Constant.Profile.designer, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.Questionnarie, at: 1)
        segmentedControl.insertSegment(withTitle: Constant.Profile.submission, at: 2)

        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = true
        segmentedControl.selectedSegmentIndex = selectedindex
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
        remove(asChildViewController: tasksListVC)
        remove(asChildViewController: questionarieVC)
        add(asChildViewController: formDetailVC)
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: PateintsAppointmentListVC)
            add(asChildViewController: formDetailVC)
            navigationItem.rightBarButtonItem = nil
        case 1:
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: formDetailVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: PateintsAppointmentListVC)
            add(asChildViewController: questionarieVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        case 2:
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: formDetailVC)
            remove(asChildViewController: consentsListVC)
            remove(asChildViewController: PateintsAppointmentListVC)
            add(asChildViewController: tasksListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addTaskTapped), imageName: "add")
        default:
            break
        }

    }
    
    static func viewController() -> FormDetailContainerView {
          return UIStoryboard.init(name: "FormDetailContainerView", bundle: nil).instantiateViewController(withIdentifier: "FormDetailContainerView") as! FormDetailContainerView
      }
    
    private lazy var formDetailVC: FormDetailViewController = {
        guard let formDetailVC = storyboard?.instantiateViewController(withIdentifier: "FormDetailViewController") as? FormDetailViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        formDetailVC.questionId = workflowFormId
        return formDetailVC
    }()
    
    
    
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
    
    private lazy var tasksListVC: TasksListViewController = {
        let tasksList = UIStoryboard(name: "TasksListViewController", bundle: nil).instantiateViewController(withIdentifier: "TasksListViewController") as! TasksListViewController
        tasksList.workflowTaskPatient = workflowFormId
        tasksList.fromPateint = true
        return tasksList
    }()
    
    private lazy var questionarieVC: QuestionarieViewController = {
        let questionarieList = UIStoryboard(name: "QuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "QuestionarieViewController") as! QuestionarieViewController
        questionarieList.pateintId = workflowFormId
        return questionarieList
    }()
    
    private lazy var consentsListVC: ConsentsListViewController = {
        let consentsList = UIStoryboard(name: "ConsentsListViewController", bundle: nil).instantiateViewController(withIdentifier: "ConsentsListViewController") as! ConsentsListViewController
        consentsList.pateintId = workflowFormId
        return consentsList
    }()

    private lazy var PateintsAppointmentListVC: PatientAppointmentViewController = {
        let patientAppointmentList = UIStoryboard(name: "PatientAppointmentViewController", bundle: nil).instantiateViewController(withIdentifier: "PatientAppointmentViewController") as! PatientAppointmentViewController
        patientAppointmentList.pateintId = workflowFormId
        return patientAppointmentList
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
