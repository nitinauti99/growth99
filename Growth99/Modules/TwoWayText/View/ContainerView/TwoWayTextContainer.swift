//
//  TwoWayTextContainer.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit


protocol TwoWayListViewContollerProtocol: AnyObject {
    func twoWayListDataRecived()
    func twoWayDetailListDataRecived()
    func errorReceived(error: String)
    func twoWayDetailDataRecived()
}

class TwoWayTextContainer: UIViewController, TwoWayListViewContollerProtocol {
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var twoWayListTableView: UITableView!
    
    var bussinessInfoData: BusinessSubDomainModel?
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    var viewModel: TwoWayListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [AuditLogsList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Message Center"
        self.viewModel = TwoWayListViewModel(delegate: self)
        tableViewCellRegister()
        self.view.ShowSpinner()
        viewModel?.getTwoWayList(pageNo: 0, pageSize: 15, fromPage: "List")
        addSerchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "selectedIndex") , object: nil)
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Constant.Profile.searchList
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func twoWayDetailListDataRecived() {}
    
    func twoWayDetailDataRecived() {}
    
    func twoWayListDataRecived() {
        self.view.HideSpinner()
        self.twoWayListTableView.setContentOffset(.zero, animated: true)
        setupSegment()
        clearSearchBar()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        twoWayListTableView.reloadData()
    }
    
    func setupSegment() {
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "\(Constant.Profile.all) (\(self.viewModel?.getTwoWayData.filter({$0.lastMessageRead == true}).count ?? 0))", at: 0)
        segmentedControl.insertSegment(withTitle: "\(Constant.Profile.unread) (\(self.viewModel?.getTwoWayData.filter({$0.lastMessageRead == false}).count ?? 0))", at: 1)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.underlineHeight = 4
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        viewModel?.selectedSegmentName = "Open"
        segmentedControl.selectedSegmentIndex = selectedindex
    }
    
    func tableViewCellRegister() {
        twoWayListTableView.register(UINib(nibName: "TwoWayListTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoWayListTableViewCell")
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = segment
    }
    
    @objc private func selectionDidChange(sender: ScrollableSegmentedControl) {
        viewModel?.selectedSegmentIndexValue = sender.selectedSegmentIndex
        viewModel?.selectedSegmentName = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
        clearSearchBar()
    }
    
    @IBAction func twoWaySegmentSelection(_ sender: UISegmentedControl) {
        viewModel?.selectedSegmentIndexValue = sender.selectedSegmentIndex
        viewModel?.selectedSegmentName = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
        clearSearchBar()
    }
}
