//
//  TwoWayTextContainer.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit

class TwoWayTextContainer: UIViewController {
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var twoWayListTableView: UITableView!

    var bussinessInfoData: BusinessSubDomainModel?
    
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Message Center"
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = true
        setupSegment()
        tableViewCellRegister()
    }

    func setupSegment() {
        segmentedControl.insertSegment(withTitle: Constant.Profile.all, at: 0)
        segmentedControl.insertSegment(withTitle: Constant.Profile.unread, at: 1)
       // add(asChildViewController: twoWayTextVC)
    }
    
    func tableViewCellRegister() {
        twoWayListTableView.register(UINib(nibName: "TwoWayListTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoWayListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "selectedIndex") , object: nil)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = segment
    }
    
    @objc private func selectionDidChange(sender: ScrollableSegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    lazy var twoWayTextVC: TwoWayTextViewController = {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "TwoWayTextViewController") as? TwoWayTextViewController else {
            fatalError("Unable to Instantiate Summary View Controller")
        }
        return twoWayTextVC
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
