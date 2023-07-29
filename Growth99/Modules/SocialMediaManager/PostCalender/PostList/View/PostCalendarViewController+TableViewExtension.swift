//
//  PostCalendarViewController+TableViewExtension.swift
//  Growth99
//
//  Created by Sravan Goud on 29/07/23.
//

import Foundation

extension PostCalendarViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return max(1, self.sections.count)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections.count > section else {
            return 0
        }
        let section = self.sections[section]
        let now = Date()
        let filteredHeadlines: [PostCalendarListModel]
        switch eventTypeSelected {
        case Constant.EventTypeSelected.upcoming.rawValue:
            filteredHeadlines = section.headlines.filter { $0.scheduledDate?.toDate() ?? now > now }
        case Constant.EventTypeSelected.past.rawValue:
            filteredHeadlines = section.headlines.filter { $0.scheduledDate?.toDate() ?? now < now }
        default:
            filteredHeadlines = section.headlines
        }
        return filteredHeadlines.count > 0 ? 21 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let headerView = UIView()
        let myLabel = UILabel(frame: CGRect(x: 5, y: 0, width: postCalendarTableview.frame.size.width, height: 20))
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        if eventTypeSelected == Constant.EventTypeSelected.upcoming.rawValue && section.headlines.contains(where: { $0.scheduledDate?.toDate() ?? Date() > Date() }) {
            myLabel.text = dateFormatter.string(from: section.month)
        } else if eventTypeSelected == Constant.EventTypeSelected.past.rawValue && section.headlines.contains(where: { $0.scheduledDate?.toDate() ?? Date() < Date() }) {
            myLabel.text = dateFormatter.string(from: section.month)
        } else if eventTypeSelected == Constant.EventTypeSelected.all.rawValue && section.headlines.count > 0 {
            myLabel.text = dateFormatter.string(from: section.month)
        } else {
            return nil
        }
        
        headerView.addSubview(myLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let firstSection = sections.first, !firstSection.headlines.isEmpty else {
            return 1
        }
        let currentDate = Date()
        let filteredHeadlines: [PostCalendarListModel]
        switch eventTypeSelected {
        case Constant.EventTypeSelected.upcoming.rawValue:
            filteredHeadlines = firstSection.headlines.filter { $0.scheduledDate?.toDate() ?? currentDate > currentDate }
        case Constant.EventTypeSelected.past.rawValue:
            filteredHeadlines = firstSection.headlines.filter { $0.scheduledDate?.toDate() ?? currentDate < currentDate }
        default:
            filteredHeadlines = firstSection.headlines
        }
        return filteredHeadlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections.isEmpty {
            return createEmptyEventsTableViewCell(for: tableView, indexPath: indexPath)
        } else {
            let section = self.sections[indexPath.section]
            let headline = section.headlines[indexPath.row]
            let isUpcoming = eventTypeSelected == Constant.EventTypeSelected.upcoming.rawValue
            let isPast = eventTypeSelected == Constant.EventTypeSelected.past.rawValue
            let filteredHeadlines: [PostCalendarListModel]
            if isUpcoming {
                filteredHeadlines = section.headlines.filter { ($0.scheduledDate?.toDate() ?? Date()) > Date() }
            } else if isPast {
                filteredHeadlines = section.headlines.filter { ($0.scheduledDate?.toDate() ?? Date()) < Date() }
            } else {
                filteredHeadlines = section.headlines
            }
            
            if filteredHeadlines.isEmpty {
                return createEmptyEventsTableViewCell(for: tableView, indexPath: indexPath)
            } else {
                return createEventsTableViewCell(for: tableView, indexPath: indexPath, headline: headline)
            }
        }
    }
    
    private func createEmptyEventsTableViewCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    private func createEventsTableViewCell(for tableView: UITableView, indexPath: IndexPath, headline: PostCalendarListModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCalendarTableViewCell", for: indexPath) as? PostCalendarTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(headline: headline, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < sections.count else {
            return
        }
        let section = sections[indexPath.section]
        guard indexPath.row < section.headlines.count else {
            return
        }
        let selectedHeadline = section.headlines[indexPath.row]
        let storyboard = UIStoryboard(name: "CreatePostViewController", bundle: nil)
        guard let editPostVC = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {
            return
        }
        editPostVC.screenName = "Edit"
        editPostVC.postId = selectedHeadline.id ?? 0
        navigationController?.pushViewController(editPostVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
}
