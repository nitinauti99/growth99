//
//  PostCalendarViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit
import FSCalendar

protocol PostCalendarViewContollerProtocol {
    func errorReceived(error: String)
    func postCalendarListDataRecived()
}

func firstDayOfMonthPostCalendar(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}

struct PostCalendarMonthSection {
    
    var month: Date
    var headlines: [PostCalendarListModel]
    static func group(headlines: [PostCalendarListModel]) -> [PostCalendarMonthSection] {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let groups = Dictionary(grouping: headlines) { headline in
            firstDayOfMonthPostCalendar(date: dateFormat.date(from: headline.scheduledDate ?? String.blank) ?? Date())
        }
        return groups.map(PostCalendarMonthSection.init(month: headlines:))
    }
}

class PostCalendarViewController: UIViewController, PostCalendarViewContollerProtocol {
    
    @IBOutlet var calendarscrollview: UIScrollView!
    @IBOutlet var calendarScrollViewHight: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postCalendarTableview: UITableView!
    @IBOutlet weak var addAppointmnetView: UIView!
    @IBOutlet weak var calendarSegmentControl: UISegmentedControl!
    
    var startDates: [Date] = []
    var endDates: [Date] = []
    var defaultCalendar: String = Constant.Profile.CalendarDefault
    var postCalnderInfoListData = [PostCalendarListModel]()
    var postCalendarViewModel: PostCalendarViewModelProtocol?
    var eventTypeSelected: String = Constant.EventTypeSelected.upcoming.rawValue
    var sections = [PostCalendarMonthSection]()
    
    var tableViewHeight: CGFloat {
        postCalendarTableview.layoutIfNeeded()
        return postCalendarTableview.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCellRegister()
        segmentControlUI()
        self.calendar.select(Date())
        self.calendar.scope = .month
        addAppointmnetView.layer.cornerRadius = 10
        postCalendarViewModel = PostCalendarViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name("EventCreated"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        getPostCalendarList()
        calendarSegmentControl.selectedSegmentIndex = 0
        eventTypeSelected = Constant.EventTypeSelected.upcoming.rawValue
        scrollToTop(of: calendarscrollview, animated: true)
        postCalendarTableview.reloadData()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.postCalendar
    }
    
    func tableViewCellRegister() {
        postCalendarTableview.register(UINib(nibName:"PostCalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCalendarTableViewCell")
        postCalendarTableview.register(UINib(nibName: Constant.ViewIdentifier.emptyEventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell)
    }
    
    func segmentControlUI() {
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    func scrollToTop(of scrollView: UIScrollView, animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -100)
        scrollView.setContentOffset(topOffset, animated: animated)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        self.view.showToast(message: "Post created successfully", color: UIColor().successMessageColor())
        postCalendarTableview.reloadData()
    }
    
    func getPostCalendarList() {
        self.view.ShowSpinner()
        postCalendarViewModel?.getPostCalendarList()
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        return formatter
    }()
    
    func scrollViewHeight() {
        calendarScrollViewHight.constant = tableViewHeight + 800
    }
    
    func postCalendarListDataRecived() {
        self.view.HideSpinner()
        postCalnderInfoListData = postCalendarViewModel?.postCalendarListData ?? []
        self.sections = PostCalendarMonthSection.group(headlines: self.postCalnderInfoListData)
        self.sections.sort { lhs, rhs in lhs.month > rhs.month }
        self.postCalendarTableview.setContentOffset(.zero, animated: true)
        postCalendarTableview.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func addAppointmentButtonAction(sender: UIButton) {
        let createPostVC = UIStoryboard(name: "CreatePostViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        self.navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    @IBAction func CalendarSegmentSelection(_ sender: Any) {
        switch calendarSegmentControl.selectedSegmentIndex {
        case 0:
            eventTypeSelected = Constant.EventTypeSelected.upcoming.rawValue
            postCalendarTableview.reloadData()
        case 1:
            eventTypeSelected = Constant.EventTypeSelected.past.rawValue
            postCalendarTableview.reloadData()
        case 2:
            eventTypeSelected = Constant.EventTypeSelected.all.rawValue
            postCalendarTableview.reloadData()
        default:
            break;
        }
    }
}

extension PostCalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        let createPostVC = UIStoryboard(name: "CreatePostViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        self.navigationController?.pushViewController(createPostVC, animated: true)
    }
}

extension PostCalendarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
}
