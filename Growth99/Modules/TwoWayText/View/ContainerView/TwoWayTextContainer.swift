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
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var twoWayListTableView: UITableView!
    
    var bussinessInfoData: BusinessSubDomainModel?
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    var viewModel: TwoWayListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [AuditLogsList]()
    var currentPage : Int = 0
    var isLoadingList : Bool = true
    var totalCount: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Message Center"
        self.viewModel = TwoWayListViewModel(delegate: self)
        tableViewCellRegister()
        addSerchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "selectedIndex") , object: nil)
        self.view.ShowSpinner()
        viewModel?.getTwoWayList(pageNo: currentPage, pageSize: 15, fromPage: "List")
    }
    
    
    func loadMoreItemsForList(){
        if (viewModel?.twoWayCompleteListData.count ?? 0) == viewModel?.getTotalCount {
            return
        }
        self.currentPage += 1
        self.view.ShowSpinner()
        viewModel?.getTwoWayList(pageNo: currentPage, pageSize: 15, fromPage: "Pagination")
     }
    
    func twoWayListDataRecived() {
        self.view.HideSpinner()
        self.twoWayListTableView.setContentOffset(.zero, animated: true)
        clearSearchBar()
    }
    
    func setupSegment() {
        segmentedControl.setTitle("\(Constant.Profile.all) (\(self.viewModel?.getTwoWayData.filter({$0.lastMessageRead == true}).count ?? 0))", forSegmentAt: 0)
        segmentedControl.setTitle("\(Constant.Profile.unread) (\(self.viewModel?.getTwoWayData.filter({$0.lastMessageRead == false}).count ?? 0))", forSegmentAt: 1)
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search Name or Number"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func twoWayDetailListDataRecived() {}
    
    func twoWayDetailDataRecived() {}
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        setupSegment()
        twoWayListTableView.reloadData()
    }
    
    func tableViewCellRegister() {
        twoWayListTableView.register(UINib(nibName: "TwoWayListTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoWayListTableViewCell")
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let segment = notification.userInfo?["selectedIndex"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = segment
    }
    
    @IBAction func twoWaySegmentSelection(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0  {
            segmentedControl.selectedSegmentIndex = 0
            viewModel?.selectedSegmentName = "Open"
        } else { 
            segmentedControl.selectedSegmentIndex = 0
            viewModel?.selectedSegmentName = "Closed"
        }
        clearSearchBar()
    }
    
    @IBAction func twoWayAllUnreadSegmentSelection(_ sender: UISegmentedControl) {
        viewModel?.selectedChildSegmentIndexValue = sender.selectedSegmentIndex
        clearSearchBar()
    }
}
