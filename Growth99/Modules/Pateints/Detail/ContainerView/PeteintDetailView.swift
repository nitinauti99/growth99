//
//  PeteintDetailView.swift
//  Growth99
//
//  Created by nitin auti on 01/02/23.
//

import Foundation
import UIKit

class PeteintDetailView: UIViewController {
//    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    var workflowTaskPatientId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setupView()
        self.title = Constant.Profile.patientDetail
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Pateint Detail", at: 0)
        segmentedControl.insertSegment(withTitle: "Questionarie", at: 1)
        segmentedControl.insertSegment(withTitle: "Tasks", at: 2)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 40
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.fixedSegmentWidth = true
    }
    
    func setupView() {
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: QuestionarieVC)
            add(asChildViewController: pateintDetailVC)
            navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: QuestionarieVC)
            add(asChildViewController: pateintDetailVC)
            navigationItem.rightBarButtonItem = nil
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            remove(asChildViewController: tasksListVC)
            remove(asChildViewController: pateintDetailVC)
            add(asChildViewController: QuestionarieVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        }
        if segmentedControl.selectedSegmentIndex == 2 {
            remove(asChildViewController: QuestionarieVC)
            remove(asChildViewController: pateintDetailVC)
            add(asChildViewController: tasksListVC)
            navigationItem.rightBarButtonItem = nil

        }
//        if segmentedControl.selectedSegmentIndex == 3 {
//            remove(asChildViewController: tasksListVC)
//            remove(asChildViewController: tasksListVC)
//            add(asChildViewController: pateintDetailVC)
//        }
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let addNewQuestionarieVC = UIStoryboard(name: "AddNewQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestionarieViewController") as! AddNewQuestionarieViewController
        navigationController?.pushViewController(addNewQuestionarieVC, animated: true)
    }
    
    static func viewController() -> PeteintDetailView {
          return UIStoryboard.init(name: "PeteintDetailView", bundle: nil).instantiateViewController(withIdentifier: "PeteintDetailView") as! PeteintDetailView
      }
    
    private lazy var pateintDetailVC: PateintDetailViewController = {
        // Load Storyboard
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "PateintDetailViewController") as? PateintDetailViewController else {
               fatalError("Unable to Instantiate Summary View Controller")
           }
        detailController.workflowTaskPatientId = workflowTaskPatientId
        return detailController
    }()
    
    
    private lazy var tasksListVC: TasksListViewController = {
        let tasksList = UIStoryboard(name: "TasksListViewController", bundle: nil).instantiateViewController(withIdentifier: "TasksListViewController") as! TasksListViewController
        tasksList.workflowTaskPatient = workflowTaskPatientId
        return tasksList
    }()
    
    private lazy var QuestionarieVC: QuestionarieViewController = {
        let questionarieList = UIStoryboard(name: "QuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "QuestionarieViewController") as! QuestionarieViewController
        questionarieList.pateintId = workflowTaskPatientId
        return questionarieList
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
