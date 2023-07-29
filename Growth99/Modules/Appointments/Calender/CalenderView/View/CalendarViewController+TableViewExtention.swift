//
//  CalendarViewController+TableViewExtention.swift
//  Growth99
//
//  Created by Sravan Goud on 29/07/23.
//

import Foundation

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return max(sections.count, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections.count != 0 else {
            return 0
        }
        
        let section = self.sections[section]
        var shouldShowHeader = false
        switch eventTypeSelected {
        case Constant.EventTypeSelected.upcoming.rawValue:
            shouldShowHeader = section.headlines.contains { $0.appointmentStartDate?.toDate() ?? Date() > Date() }
        case Constant.EventTypeSelected.past.rawValue:
            shouldShowHeader = section.headlines.contains { $0.appointmentStartDate?.toDate() ?? Date() < Date() }
        case Constant.EventTypeSelected.all.rawValue:
            shouldShowHeader = section.headlines.count > 0
        default:
            break
        }
        return shouldShowHeader ? 21 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        let date = section.month
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 5, y: 0, width: eventListView.frame.size.width, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = dateFormatter.string(from: date)
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        switch eventTypeSelected {
        case Constant.EventTypeSelected.upcoming.rawValue:
            if section.headlines.contains(where: { $0.appointmentStartDate?.toDate() ?? Date() > Date() }) {
                return headerView
            }
        case Constant.EventTypeSelected.past.rawValue:
            if section.headlines.contains(where: { $0.appointmentStartDate?.toDate() ?? Date() < Date() }) {
                return headerView
            }
        case Constant.EventTypeSelected.all.rawValue:
            if section.headlines.count > 0 {
                return headerView
            }
        default:
            break
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.count == 0  {
            return 1
        } else {
            let section = self.sections[section]
            let selectedEventType = Constant.EventTypeSelected(rawValue: eventTypeSelected)
            switch selectedEventType {
            case .upcoming:
                return section.headlines.filter({ $0.appointmentStartDate?.toDate() ?? Date() > Date() }).count
            case .past:
                return section.headlines.filter({ $0.appointmentStartDate?.toDate() ?? Date() < Date() }).count
            case .all:
                return section.headlines.count
            case .none:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections.isEmpty {
            return createEmptyEventsTableViewCell(for: tableView, indexPath: indexPath)
        } else {
            let section = self.sections[indexPath.section]
            let headline = section.headlines[indexPath.row]
            if eventTypeSelected == Constant.EventTypeSelected.upcoming.rawValue {
                if section.headlines.filter({ $0.appointmentStartDate?.toDate() ?? Date() > Date() }).isEmpty {
                    return createEmptyEventsTableViewCell(for: tableView, indexPath: indexPath)
                } else {
                    return createEventsTableViewCell(for: tableView, indexPath: indexPath, headline: headline)
                }
            } else if eventTypeSelected == Constant.EventTypeSelected.past.rawValue {
                if section.headlines.filter({ $0.appointmentStartDate?.toDate() ?? Date() < Date() }).isEmpty {
                    return createEmptyEventsTableViewCell(for: tableView, indexPath: indexPath)
                } else {
                    return createEventsTableViewCell(for: tableView, indexPath: indexPath, headline: headline)
                }
            } else {
                if section.headlines.isEmpty {
                    return createEmptyEventsTableViewCell(for: tableView, indexPath: indexPath)
                } else {
                    return createEventsTableViewCell(for: tableView, indexPath: indexPath, headline: headline)
                }
            }
        }
    }
    
    private func createEmptyEventsTableViewCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.emptyEventsTableViewCell, for: indexPath) as? EmptyEventsTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    private func createEventsTableViewCell(for tableView: UITableView, indexPath: IndexPath, headline: AppointmentDTOList) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ViewIdentifier.eventsTableViewCell, for: indexPath) as? EventsTableViewCell else {
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
        let storyboard = UIStoryboard(name: "CalenderEventEditViewController", bundle: nil)
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "CalenderEventEditViewController") as? CalenderEventEditViewController else {
            return
        }
        editVC.appointmentId = selectedHeadline.id
        editVC.editBookingHistoryData = selectedHeadline
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
