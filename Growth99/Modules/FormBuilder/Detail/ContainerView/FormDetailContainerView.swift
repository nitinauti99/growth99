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
        segmentedControl.insertSegment(withTitle: Constant.Profile.notification, at: 1)
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
        remove(asChildViewController: notificationListVC)
        remove(asChildViewController: questionarieVC)
        add(asChildViewController: formDetailVC)
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func selectionDidChange(sender:ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: notificationListVC)
            remove(asChildViewController: questionarieVC)
            add(asChildViewController: formDetailVC)
            navigationItem.rightBarButtonItem = nil
        case 1:
            remove(asChildViewController: questionarieVC)
            remove(asChildViewController: formDetailVC)
            add(asChildViewController: notificationListVC)
            navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
        case 2:
            remove(asChildViewController: notificationListVC)
            remove(asChildViewController: formDetailVC)
            add(asChildViewController: questionarieVC)
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
    
    @objc func creatUser() {
        let createNotificationVC = UIStoryboard(name: "CreateNotificationViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateNotificationViewController") as! CreateNotificationViewController
        createNotificationVC.questionId = workflowFormId
        createNotificationVC.screenName = "Create Form"
        self.navigationController?.pushViewController(createNotificationVC, animated: true)
    }
    
    private lazy var notificationListVC: NotificationListViewController = {
        let notificationListVC = UIStoryboard(name: "NotificationListViewController", bundle: nil).instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
        notificationListVC.questionId = workflowFormId
        return notificationListVC
    }()
    
    private lazy var questionarieVC: QuestionarieViewController = {
        let questionarieList = UIStoryboard(name: "QuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "QuestionarieViewController") as! QuestionarieViewController
        questionarieList.pateintId = workflowFormId
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
