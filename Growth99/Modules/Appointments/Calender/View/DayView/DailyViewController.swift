//
//  CalenderBaseViewController.swift
//  Growth99
//
//  Created by admin on 01/01/23.
//

import UIKit

var selectedDate = Date()

class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var hourTableView: UITableView!
	@IBOutlet weak var dayOfWeekLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	
	var hours = [Int]()
    var hourString = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		initTime()
		setDayView()
	}
	
	func initTime() {
        
		for hour in 0...23 {
			hours.append(hour)
		}
        hourString.append("12 AM")
        hourString.append("1 AM")
        hourString.append("2 AM")
        hourString.append("3 AM")
        hourString.append("4 AM")
        hourString.append("5 AM")
        hourString.append("6 AM")
        hourString.append("7 AM")
        hourString.append("8 AM")
        hourString.append("9 AM")
        hourString.append("10 AM")
        hourString.append("11 AM")
        hourString.append("12 PM")
        hourString.append("1 AM")
        hourString.append("2 PM")
        hourString.append("3 PM")
        hourString.append("4 PM")
        hourString.append("5 PM")
        hourString.append("6 PM")
        hourString.append("7 PM")
        hourString.append("8 PM")
        hourString.append("9 PM")
        hourString.append("10 PM")
        hourString.append("11 PM")
	}
	
	func setDayView() {
		dayLabel.text = CalendarHelper().monthDayString(date: selectedDate)
		dayOfWeekLabel.text = CalendarHelper().weekDayAsString(date: selectedDate)
		hourTableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hours.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellDailyID") as! DailyCell
		
		let hour  = hours[indexPath.row]
        cell.time.text = hourString[indexPath.row]
        cell.selectionStyle = .none
		let events = Event().eventsForDateAndTime(date: selectedDate, hour: hour)
		setEvents(cell, events)
		
		return cell
	}
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.addEventViewController, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.addEventViewController) as! AddEventViewController
        let navController = UINavigationController(rootViewController: addEventVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navController, animated:true, completion: nil)
    }
    
    
	func setEvents(_ cell: DailyCell, _ events: [Event]) {
		hideAll(cell)
		switch events.count {
		case 1:
			setEvent1(cell, events[0])
		case 2:
			setEvent1(cell, events[0])
			setEvent2(cell, events[1])
		case 3:
			setEvent1(cell, events[0])
			setEvent2(cell, events[1])
			setEvent3(cell, events[2])
		
		case let count where count > 3:
			setEvent1(cell, events[0])
			setEvent2(cell, events[1])
			setMoreEvents(cell, events.count - 2)
		default:
			break
		}
	}
	
	
	func setMoreEvents(_ cell: DailyCell, _ count: Int) {
		cell.event3.isHidden = false
        cell.event3.text = String(count) + Constant.Profile.moreEvents
	}
	
	func setEvent1(_ cell: DailyCell, _ event: Event) {
		cell.event1.isHidden = false
		cell.event1.text = event.name
	}
	
	func setEvent2(_ cell: DailyCell, _ event: Event) {
		cell.event2.isHidden = false
		cell.event2.text = event.name
	}
	
	func setEvent3(_ cell: DailyCell, _ event: Event) {
		cell.event3.isHidden = false
		cell.event3.text = event.name
	}
	
	func hideAll(_ cell: DailyCell) {
		cell.event1.isHidden = true
		cell.event2.isHidden = true
		cell.event3.isHidden = true
	}
	
	func formatHour(hour: Int) -> String {
		return String(format: "%02d:%02d", hour, 0)
	}
	
	@IBAction func nextDayAction(_ sender: Any) {
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: 1)
		setDayView()
	}
	
	@IBAction func previousDayAction(_ sender: Any) {
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: -1)
		setDayView()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setDayView()
	}
}
