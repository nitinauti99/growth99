//
//  PostCalenderViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit
import FSCalendar

protocol PostCalenderViewContollerProtocol {
    func errorReceived(error: String)
    func postCalenderListDataRecived()
}

func firstDayOfMonthPostCalender(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}

struct PostCalenderMonthSection {
    
    var month: Date
    var headlines: [PostCalenderListModel]
    static func group(headlines: [PostCalenderListModel]) -> [PostCalenderMonthSection] {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let groups = Dictionary(grouping: headlines) { headline in
            firstDayOfMonthPostCalender(date: dateFormat.date(from: headline.scheduledDate ?? String.blank) ?? Date())
        }
        return groups.map(PostCalenderMonthSection.init(month: headlines:))
    }
}


class PostCalenderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostCalenderViewContollerProtocol, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var postCalenderTableview: UITableView!
    @IBOutlet var calenderscrollview: UIScrollView!
    @IBOutlet var calenderScrollViewHight: NSLayoutConstraint!
    @IBOutlet private weak var addAppointmnetView: UIView!
    @IBOutlet private weak var calenderSegmentControl: UISegmentedControl!
    
    var time = Date()
    var titles: [String] = []
    var startDates: [Date] = []
    var endDates: [Date] = []
    var defaultCalender: String = Constant.Profile.calenderDefault
    var postCalnderInfoListData = [PostCalenderListModel]()
    var postCalenderViewModel: PostCalenderViewModelProtocol?
    var eventTypeSelected: String = "upcoming"
    var sections = [PostCalenderMonthSection]()
    
    var tableViewHeight: CGFloat {
        postCalenderTableview.layoutIfNeeded()
        return postCalenderTableview.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        postCalenderViewModel = PostCalenderViewModel(delegate: self)
        self.calendar.scope = .month
        postCalenderTableview.register(UINib(nibName:"PostCalenderTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCalenderTableViewCell")
        postCalenderTableview.register(UINib(nibName: Constant.ViewIdentifier.emptyEventsTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell)
        addAppointmnetView.layer.cornerRadius = 10
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name("EventCreated"), object: nil)
        getPostCalenderList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        calenderSegmentControl.selectedSegmentIndex = 0
        eventTypeSelected = "upcoming"
        postCalenderTableview.reloadData()
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        self.view.showToast(message: "Post created sucessfully", color: UIColor().successMessageColor())
        postCalenderTableview.reloadData()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.postCalender
    }
    
    func getPostCalenderList() {
        self.view.ShowSpinner()
        postCalenderViewModel?.getPostCalenderList()
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    func scrollViewHeight() {
        calenderScrollViewHight.constant = tableViewHeight + 800
    }
    
    func postCalenderListDataRecived() {
        self.view.HideSpinner()
        postCalnderInfoListData = postCalenderViewModel?.postCalenderListData ?? []
        self.sections = PostCalenderMonthSection.group(headlines: self.postCalnderInfoListData)
        self.sections.sort { lhs, rhs in lhs.month < rhs.month }
        self.postCalenderTableview.setContentOffset(.zero, animated: true)
        postCalenderTableview.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.count == 0 {
            return 1
        } else {
            return self.sections.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections.count != 0 {
            let section = self.sections[section]
            if eventTypeSelected == "upcoming" {
                if section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() > Date()}).count > 0 {
                    return 21
                }
            } else if eventTypeSelected == "past" {
                if section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() < Date()}).count > 0 {
                    return 21
                }
            } else if eventTypeSelected == "all" {
                if section.headlines.count > 0 {
                    return 21
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        if eventTypeSelected == "upcoming" {
            if section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() > Date() }).count > 0 {
                let date = section.month
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                
                let myLabel = UILabel()
                myLabel.frame = CGRect(x: 5, y: 0, width: postCalenderTableview.frame.size.width, height: 20)
                myLabel.font = UIFont.boldSystemFont(ofSize: 18)
                myLabel.text = dateFormatter.string(from: date)
                let headerView = UIView()
                headerView.addSubview(myLabel)
                return headerView
            }
        } else if eventTypeSelected == "past" {
            
            if section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() < Date() }).count > 0 {
                let date = section.month
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                
                let myLabel = UILabel()
                myLabel.frame = CGRect(x: 5, y: 0, width: postCalenderTableview.frame.size.width, height: 20)
                myLabel.font = UIFont.boldSystemFont(ofSize: 18)
                myLabel.text = dateFormatter.string(from: date)
                let headerView = UIView()
                headerView.addSubview(myLabel)
                return headerView
            }
        } else if eventTypeSelected == "all" {
            if section.headlines.count > 0 {
                let date = section.month
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                
                let myLabel = UILabel()
                myLabel.frame = CGRect(x: 5, y: 0, width: postCalenderTableview.frame.size.width, height: 20)
                myLabel.font = UIFont.boldSystemFont(ofSize: 18)
                myLabel.text = dateFormatter.string(from: date)
                let headerView = UIView()
                headerView.addSubview(myLabel)
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.count == 0  {
            return 1
        } else {
            let section = self.sections[section]
            if eventTypeSelected == "upcoming" {
                return section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() > Date() }).count
            } else if sections.count > 0 && eventTypeSelected == "past" {
                return section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() < Date() }).count
            } else {
                return section.headlines.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            let section = self.sections[indexPath.section]
            let headline = section.headlines[indexPath.row]
            if eventTypeSelected == "upcoming" {
                if (section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() > Date() }).count) == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else { return UITableViewCell() }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCalenderTableViewCell", for: indexPath) as? PostCalenderTableViewCell else { return UITableViewCell() }
                    cell.postLabel.text = "\(headline.post ?? String.blank)"
                    if headline.approved == true {
                        cell.statusButton.setTitle("Approved", for: .normal)
                        cell.statusButton.titleLabel?.textColor = UIColor(hexString: "52afff")
                        cell.statusButton.layer.borderColor = UIColor(hexString: "52afff").cgColor

                    } else {
                        cell.statusButton.setTitle("Pending", for: .normal)
                        cell.statusButton.titleLabel?.textColor = UIColor.red
                        cell.statusButton.layer.borderColor = UIColor.red.cgColor
                    }
                    cell.timeLabel.text = postCalenderViewModel?.serverToLocalCalender(date: headline.scheduledDate ?? "")
                    cell.shortDateBtn.setTitle(headline.scheduledDate?.toDate()?.toString(), for: .normal)
                    cell.selectionStyle = .none
                    return cell
                }
            } else if eventTypeSelected == "past" {
                if (section.headlines.filter({ $0.scheduledDate?.toDate() ?? Date() < Date() }).count) == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else { return UITableViewCell() }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCalenderTableViewCell", for: indexPath) as? PostCalenderTableViewCell else { return UITableViewCell() }
                    cell.postLabel.text = "\(headline.post ?? String.blank)"
                    if headline.approved == true {
                        cell.statusButton.setTitle("Approved", for: .normal)
                        cell.statusButton.titleLabel?.textColor = UIColor(hexString: "52afff")
                        cell.statusButton.layer.borderColor = UIColor(hexString: "52afff").cgColor

                    } else {
                        cell.statusButton.setTitle("Pending", for: .normal)
                        cell.statusButton.titleLabel?.textColor = UIColor.red
                        cell.statusButton.layer.borderColor = UIColor.red.cgColor
                    }
                    cell.shortDateBtn.setTitle(headline.scheduledDate?.toDate()?.toString(), for: .normal)
                    cell.timeLabel.text = postCalenderViewModel?.serverToLocalCalender(date: headline.scheduledDate ?? "")
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                if section.headlines.count == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else { return UITableViewCell() }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCalenderTableViewCell", for: indexPath) as? PostCalenderTableViewCell else { return UITableViewCell() }
                    cell.postLabel.text = "\(headline.post ?? String.blank)"
                    if headline.approved == true {
                        cell.statusButton.setTitle("Approved", for: .normal)
                        cell.statusButton.titleLabel?.textColor = UIColor(hexString: "52afff")
                        cell.statusButton.layer.borderColor = UIColor(hexString: "52afff").cgColor

                    } else {
                        cell.statusButton.setTitle("Pending", for: .normal)
                        cell.statusButton.titleLabel?.textColor = UIColor.red
                        cell.statusButton.layer.borderColor = UIColor.red.cgColor
                    }
                    cell.timeLabel.text = postCalenderViewModel?.serverToLocalCalender(date: headline.scheduledDate ?? "")
                    cell.shortDateBtn.setTitle(headline.scheduledDate?.toDate()?.toString(), for: .normal)
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addPostVC = UIStoryboard(name: "AddPostViewController", bundle: nil).instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @IBAction func addAppointmentButtonAction(sender: UIButton) {
        let addEventVC = UIStoryboard(name: "AddPostViewController", bundle: nil).instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @IBAction func calenderSegmentSelection(_ sender: Any) {
        switch calenderSegmentControl.selectedSegmentIndex {
        case 0:
            eventTypeSelected = "upcoming"
            postCalenderTableview.reloadData()
        case 1:
            eventTypeSelected = "past"
            postCalenderTableview.reloadData()
        case 2:
            eventTypeSelected = "all"
            postCalenderTableview.reloadData()
        default:
            break;
        }
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        return formatter
    }()
    
    internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        let addEventVC = UIStoryboard(name: "AddPostViewController", bundle: nil).instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
}

extension PostCalenderViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
}
