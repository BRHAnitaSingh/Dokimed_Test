//
//  CalendarVC.swift
//  Lex
//
//  Created by ChawTech Solutions on 06/07/22.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var datesWithEvent = [String]()
    var totalTestsList = [testList_Struct]()
    var selectedDayEventArr = [testList_Struct]()
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.calendarView.reloadData()
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.locale = Locale(identifier: L102Language.currentAppleLanguage())
        if L102Language.currentAppleLanguage() == "he" {
            calendarView.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceRightToLeft
            calendarView.calendarWeekdayView.semanticContentAttribute = .forceRightToLeft
            calendarView.collectionView.semanticContentAttribute = .forceRightToLeft
            self.calendarView.locale = Locale(identifier: "he")
        } else {
            calendarView.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
            calendarView.calendarWeekdayView.semanticContentAttribute = .forceLeftToRight
            calendarView.collectionView.semanticContentAttribute = .forceLeftToRight
            self.calendarView.locale = Locale(identifier: "en")
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func filterDate(_ strDate: [String], selectedDate: String) -> Bool {
        var contains = false
            for j in strDate {
                if j == selectedDate {
                    contains = true
                    break
                }
            }
        return contains
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = self.dateFormatter.string(from: date)
//        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
//        print("selected dates is \(selectedDates)")
//        if monthPosition == .next || monthPosition == .previous {
//            calendar.setCurrentPage(date, animated: true)
//        }
//
//        self.selectedDayEventArr.removeAll()
//        self.selectedDayEventArr = self.avaiabilityListArr.filter({ (item) -> Bool in
//            let isDatesInBetween = self.isDateInBetween(self.dateFormatter.string(from: date), startDateString: item.startDate, endDateString: item.endDate)
//
//            return isDatesInBetween
//
//            //return item.startDate.contains("\(self.dateFormatter.string(from: date))")
//        })
//
//        if selectedDayEventArr.count > 0 {
//            self.emptyView.isHidden = true
//            self.tableView.isHidden = false
//        } else {
//            self.emptyView.isHidden = false
//            self.tableView.isHidden = true
//        }
//
        
        self.selectedDayEventArr.removeAll()
        self.selectedDayEventArr = self.totalTestsList.filter({ (item) -> Bool in
            let contains = self.filterDate(item.calendar_date, selectedDate: self.selectedDate)
            return contains
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
       
        return 0
    }

    
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedDayEventArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        let info = self.selectedDayEventArr[indexPath.row]
        cell.cellMainLbl.text = info.answer
        cell.cellDescLbl.text = info.description
        
        return cell
    }
    
    
}
