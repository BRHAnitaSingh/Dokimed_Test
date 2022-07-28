//
//  TestsVC.swift
//  Lex
//
//  Created by ChawTech Solutions on 08/03/22.
//

import UIKit
import Toast_Swift
import EventKit
import SkyFloatingLabelTextField

class TestsVC: UIViewController {
    
    //    MARK: IBOutlets
    
    @IBOutlet weak var testTblView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var testNameLbl: UILabel!
    @IBOutlet weak var testdescLbl: UILabel!
    @IBOutlet weak var dateTf: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.layer.cornerRadius = 15
        }
    }
    
    var currentTestsList = [testList_Struct]()
    var futureTestsList = [testList_Struct]()
    var totalTestsList = [testList_Struct]()
    var saveData = DataSave_Struct()
    var data = AllData_Struct()
    var structToJson = [Any]()
    var calendarArray = [[String]]()
    var calculatedCalendarArray = [String]()
    let store = EKEventStore()
    let headerTitles = ["Tests to be performed Currently.", "Tests to be performed in Future."]
    var currentListStructToJson = [Any]()
    var futureListStructToJson = [Any]()
    var dataDic = [String: Any]()
    let datePicker = UIDatePicker()
    var year = 0
    var month = 0
    var day = 0
    var userSelectedDate = Date()
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        testTblView.delegate = self
        testTblView.dataSource = self
        
        if let futureListDictionariesFromUserDefaults = UserDefaults().array(forKey: "futureList") as? [[String: Any]], futureListDictionariesFromUserDefaults.count > 0 {
            self.getOutcomesDataFromUserDefaults()
        } else if let currentListDictionariesFromUserDefaults = UserDefaults().array(forKey: "currentList") as? [[String: Any]], currentListDictionariesFromUserDefaults.count > 0 {
            self.getOutcomesDataFromUserDefaults()
        } else {
            print("good")
        }
        
        if L102Language.currentAppleLanguage() == "he" {
            self.dateTf.isLTRLanguage = false
        } else {
            self.dateTf.isLTRLanguage = true
        }
         
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        do {
            let currentJsonData = try JSONEncoder().encode(self.currentTestsList)
            let currentArr = try JSONSerialization.jsonObject(with: currentJsonData, options:[])
            
            let futureJsonData = try JSONEncoder().encode(self.futureTestsList)
            let futureArr = try JSONSerialization.jsonObject(with: futureJsonData, options:[])
            
            self.currentListStructToJson = currentArr as! [Any]
            self.futureListStructToJson = futureArr as! [Any]
        } catch {  }
        
        self.dataDic = ["currentList": self.currentListStructToJson, "futuredList": self.futureListStructToJson]
        
        self.saveDataPostAPI() // Save data to server
    }
    
    @IBAction func openLinkBtnTapped(_ sender: UIButton) {
        let indexPath: IndexPath? = testTblView.indexPathForRow(at: sender.convert(CGPoint.zero, to: testTblView))
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebPageVC") as! WebPageVC
        if indexPath?.section == 0 {
            vc.urlStr = self.currentTestsList[sender.tag].link
        } else {
            vc.urlStr = self.futureTestsList[sender.tag].link
        }
        
        self.present(vc, animated: true)
    }
    
    @IBAction func checkboxAction(_ sender: UIButton) {
        
        let indexPath: IndexPath? = testTblView.indexPathForRow(at: sender.convert(CGPoint.zero, to: testTblView))
        self.selectedIndexPath = indexPath!
//        if indexPath?.section == 0 {
//            if self.currentTestsList[indexPath!.row].is_check {
//                self.currentTestsList[indexPath!.row].is_check = false
//            } else {
//                self.currentTestsList[indexPath!.row].is_check = true
//            }
//            self.setTestData(self.currentTestsList[indexPath!.row])
//            DispatchQueue.main.async {
//                self.popupView.isHidden = false
//                self.testTblView.reloadData()
//            }
//        }
        
        if indexPath?.section == 0 {
//            if self.currentTestsList[indexPath!.row].is_check {
//                self.currentTestsList[indexPath!.row].is_check = false
//            } else {
//                self.currentTestsList[indexPath!.row].is_check = true
//            }
            self.setTestData(self.currentTestsList[indexPath!.row])
            showDatePicker(self.currentTestsList[indexPath!.row])
            DispatchQueue.main.async {
                self.popupView.isHidden = false
//                self.testTblView.reloadData()
            }
        }
        
    }
    
    func setTestData(_ testDetails: testList_Struct) {
        self.testNameLbl.text = testDetails.answer
        self.testdescLbl.text = testDetails.description
    }
    
    func getMinimumDate(_ testDetails: testList_Struct) -> Date {
        var calendarFirstDate = ""
        var index = -1
        for k in testDetails.calendar_date {
            index += 1
            let startDate = k
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let formatedStartDate = dateFormatter.date(from: startDate)
            
            let currentDate = Date()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let formatedCurrentDate = dateFormatter.date(from: currentDate.string(format: "yyyy-MM-dd"))
            
            if formatedStartDate! >= formatedCurrentDate! {
                calendarFirstDate = testDetails.calendar_date[index]
                break
            }
        }
        
        
        
//        let calendarFirstDate = testDetails.calendar_date[0]
        var df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        df.timeZone = TimeZone(abbreviation: "UTC")
        let firstDate = df.date(from: calendarFirstDate)
        var newDate = Calendar.current.date(byAdding: .year, value: -Int(testDetails.how_often_year)!, to: firstDate!)
        return newDate!
    }
    
    func getMinimumDateNew(_ testDetails: testList_Struct) -> Date {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        df.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = Calendar.current.date(byAdding: .year, value: -Int(testDetails.how_often_year)!, to: Date())
        return newDate!
    }
    
    func getOutcomesDataFromUserDefaults() {
//        // [Dictionary] from UserDefaults
//        let currentListDictionariesFromUserDefaults = UserDefaults().array(forKey: "currentTestsList")! as! [[String: Any]]
//        let futureListDictionariesFromUserDefaults = UserDefaults().array(forKey: "futureTestsList")! as! [[String: Any]]
//        // [Dictionary] -> [Struct]
//        self.currentTestsList = currentListDictionariesFromUserDefaults.compactMap({ testList_Struct(dictionary: $0) })
//        self.futureTestsList = futureListDictionariesFromUserDefaults.compactMap({ testList_Struct(dictionary: $0) })
        
        // [Dictionary] from UserDefaults
        let currentListDictionariesFromUserDefaults = UserDefaults().array(forKey: "currentList")! as! [[String: Any]]
        let futureListDictionariesFromUserDefaults = UserDefaults().array(forKey: "futureList")! as! [[String: Any]]
        // [Dictionary] -> [Struct]
        self.currentTestsList = currentListDictionariesFromUserDefaults.compactMap({ testList_Struct(dictionary: $0) })
        self.futureTestsList = futureListDictionariesFromUserDefaults.compactMap({ testList_Struct(dictionary: $0) })
        
        for i in 0..<currentTestsList.count {
//            var calendarFirstDate = ""
//            var index = -1
            var currentObj = currentTestsList[i]
//            for k in currentObj.calendar_date {
//                index += 1
//                let startDate = "\(k)"
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                let formatedStartDate = dateFormatter.date(from: startDate)
//
//                let currentDate = Date()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                let formatedCurrentDate = dateFormatter.date(from: currentDate.string(format: "yyyy-MM-dd"))
//
//                calendarFirstDate = currentObj.calendar_date[0]
//
//                print(formatedStartDate! >= formatedCurrentDate!)
//                if formatedStartDate! >= formatedCurrentDate! {
//                    calendarFirstDate = currentObj.calendar_date[index]
//                    break
//                }
//            }
            let calendarFirstDate = currentObj.calendar_date[0]
            
            let numberOfdays = calendarFirstDate.numberOfDaysInBetween(calendarFirstDate)
            let timerLbl = getTimerLabel(calendarFirstDate)
            
            currentObj.numberOfDays = Int(numberOfdays)!
            currentObj.timer_year = "\(timerLbl.0)"
            currentObj.timer_month = "\(timerLbl.1)"
            currentObj.timer_day = "\(timerLbl.2)"
            
            self.currentTestsList.remove(at: i)
            self.currentTestsList.insert(currentObj, at: i)
        }
        

        for i in 0..<futureTestsList.count {
            var calendarFirstDate = ""
            var index = -1
            var futureObj = futureTestsList[i]
            for k in futureObj.calendar_date {
                index += 1
                let startDate = "\(k)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let formatedStartDate = dateFormatter.date(from: startDate)
                
                let currentDate = Date()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let formatedCurrentDate = dateFormatter.date(from: currentDate.string(format: "yyyy-MM-dd"))
                
                print(formatedStartDate! >= formatedCurrentDate!)
                if formatedStartDate! >= formatedCurrentDate! {
                    calendarFirstDate = futureObj.calendar_date[index]
                    break
                }
            }
    //                        let calendarFirstDate = currentData[i]["calendar_date"][k].stringValue
            let numberOfdays = calendarFirstDate.numberOfDaysInBetween(calendarFirstDate)
            let timerLbl = getTimerLabel(calendarFirstDate)
            
            futureObj.numberOfDays = Int(numberOfdays)!
            futureObj.timer_year = "\(timerLbl.0)"
            futureObj.timer_month = "\(timerLbl.1)"
            futureObj.timer_day = "\(timerLbl.2)"
            
            self.futureTestsList.remove(at: i)
            self.futureTestsList.insert(futureObj, at: i)
        }
        
                
        DispatchQueue.main.async {
            self.testTblView.reloadData()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dateTf.text = ""
        self.popupView.isHidden = true
    }
    
    @IBAction func popupSaveAction(_ sender: UIButton) {
        if self.dateTf.text!.isEmpty {
            self.view.makeToast("Please select a date.".localized())
            return
        }
//        let indexPath: IndexPath? = testTblView.indexPathForRow(at: sender.convert(CGPoint.zero, to: testTblView))

        let calendarDate = self.currentTestsList[selectedIndexPath.row].calendar_date
        
        var currentListObj = self.currentTestsList[selectedIndexPath.row]
        self.calculatedCalendarArray = self.makeCalculatedCalendarList(self.userSelectedDate, oftency: Int(self.currentTestsList[selectedIndexPath.row].how_often_year)!, calendarArr: self.currentTestsList[selectedIndexPath.row].calendar_date)
        
        currentListObj.calendar_date = self.calculatedCalendarArray
        let calendarFirstDate = self.calculatedCalendarArray[0]
        let numberOfdays = calendarFirstDate.numberOfDaysInBetween(calendarFirstDate)
        currentListObj.numberOfDays = Int(numberOfdays)!
        
        let timerLbl = getTimerLabel(calendarFirstDate)
        currentListObj.timer_year = "\(timerLbl.0)"
        currentListObj.timer_month = "\(timerLbl.1)"
        currentListObj.timer_day = "\(timerLbl.2)"
        
        self.currentTestsList.remove(at: selectedIndexPath.row)
        self.currentTestsList.insert(currentListObj, at: selectedIndexPath.row)
        
        
        self.currentTestsList = self.currentTestsList.sorted(by: { $0.numberOfDays < $1.numberOfDays })
//        print(self.currentTestsList)
        
//        if self.currentTestsList[indexPath!.row].is_check {
//            self.currentTestsList[indexPath!.row].is_check = false
//        } else {
//            self.currentTestsList[indexPath!.row].is_check = true
//        }
        self.dateTf.text = ""
        DispatchQueue.main.async {
            self.popupView.isHidden = true
            self.testTblView.reloadData()
        }
    }
    
    func makeCalculatedCalendarList(_ userDate: Date, oftency: Int, calendarArr: [String]) -> [String] {
        var arr = [String]()
        for i in 0..<calendarArr.count {
            var newDate = Calendar.current.date(byAdding: .year, value: oftency + i, to: userDate)
            arr.append(newDate!.string(format: "yyyy-MM-dd"))
        }
        return arr
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender.tag == 501 {
            //save button
            do {
                let currentJsonData = try JSONEncoder().encode(self.currentTestsList)
                let currentArr = try JSONSerialization.jsonObject(with: currentJsonData, options:[])
                
                let futureJsonData = try JSONEncoder().encode(self.futureTestsList)
                let futureArr = try JSONSerialization.jsonObject(with: futureJsonData, options:[])
                
                self.currentListStructToJson = currentArr as! [Any]
                self.futureListStructToJson = futureArr as! [Any]
            } catch {  }
            
            self.dataDic = ["currentList": self.currentListStructToJson, "futuredList": self.futureListStructToJson]
            
            self.saveDataPostAPI() // Save data to server
            
        } else if sender.tag == 502 {
            //delete button
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            
        } else {
            //calendar button
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            vc.modalPresentationStyle = .fullScreen
            vc.datesWithEvent = self.prepareCalendarEventArray()
            vc.totalTestsList = self.totalTestsList
            self.present(vc, animated: true)
        }
    }
    
    func prepareCalendarEventArray() -> [String] {
        var eventArr = [String]()
        self.totalTestsList = self.currentTestsList
        self.totalTestsList.append(contentsOf: self.futureTestsList)
        for i in 0..<self.totalTestsList.count {
             eventArr.append(contentsOf: self.totalTestsList[i].calendar_date)
        }
        return eventArr.uniqued()
    }
    
    func showDatePicker(_ testDetails: testList_Struct){
        //Formate Date
        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .inline
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        let date = dateFormatter.date(from: minimumDate)
        datePicker.minimumDate = getMinimumDateNew(testDetails)
        datePicker.maximumDate = Date()
        
//        datePicker.accessibilityLanguage = L102Language.currentAppleLanguage()
        let loc = Locale(identifier: L102Language.currentAppleLanguage())
        datePicker.locale = loc
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTf.inputAccessoryView = toolbar
        dateTf.inputView = datePicker
        
        
    }
    
    @objc func donedatePicker(){

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTf.text = formatter.string(from: datePicker.date)
        self.userSelectedDate = datePicker.date
//          formatter.locale = Locale
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
//        self.year = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "MM"
//        self.month = dateFormatter.string(from: self.datePicker.date)
        
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        print(components)
        
        self.view.endEditing(true)
   }

   @objc func cancelDatePicker(){
       self.dateTf.text = ""
      self.view.endEditing(true)
    }
    
    @IBAction func cellDeleteAction(_ sender: UIButton) {
        let indexPath: IndexPath? = testTblView.indexPathForRow(at: sender.convert(CGPoint.zero, to: testTblView))
        let deleteAlert = UIAlertController(title: "Delete".localized(), message: "Are you sure you want to remove this test from the list?".localized(), preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (action: UIAlertAction!) in
            self.currentTestsList.remove(at: indexPath!.row)
            DispatchQueue.main.async {
                self.testTblView.reloadData()
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            deleteAlert .dismiss(animated: true, completion: nil)
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
}

extension TestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.currentTestsList.count
        } else {
            return self.futureTestsList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var info = testList_Struct()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            info = self.currentTestsList[indexPath.row]
//            cell.cellSubLbl.text = info.description
            cell.cellMainLbl.text = info.answer
            cell.whatAgeLabel.text = "What age: ".localized() + "\(info.at_what_age)"
            cell.howOftenLbl.text = "Test to be performed: ".localized() + info.how_often_year_label
            
            var timerLbl = ""
            if info.timer_year != "0" {
                timerLbl += "\(info.timer_year)" + " Year".localized()
            }
            if info.timer_month != "0" {
                timerLbl += " \(info.timer_month)" + " Month".localized()
            }
            if info.timer_day != "0" {
                timerLbl += " \(info.timer_day)" + " Days".localized()
            }
            cell.cellDateLbl.text = info.numberOfDays <= 0 ? "Immediately".localized() : timerLbl
            
            
            cell.selectionStyle = .none
            if info.is_check {
                cell.cellCheckboxBtn.setImage(UIImage(named: "checkbox_chk"), for: .normal)
            } else {
                cell.cellCheckboxBtn.setImage(UIImage(named: "checkbox"), for: .normal)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            info = self.futureTestsList[indexPath.row]
//            cell.cellSubLbl.text = info.description
            cell.cellMainLbl.text = info.answer
//            cell.whatAgeLabel.text = "What age: \(info.at_what_age)".localized()
            cell.whatAgeLabel.text = "What age: ".localized() + "\(info.at_what_age)"
//            cell.howOftenLbl.text = "Test to be performed \(info.how_often_year_label)".localized()
            cell.howOftenLbl.text = "Test to be performed: ".localized() + info.how_often_year_label
            
            var timerLbl = ""
            if info.timer_year != "0" {
                timerLbl += "\(info.timer_year)" + " Year".localized()
            }
            if info.timer_month != "0" {
                timerLbl += " \(info.timer_month)" + " Month".localized()
            }
            if info.timer_day != "0" {
                timerLbl += " \(info.timer_day)" + " Days".localized()
            }
            cell.cellDateLbl.text = info.numberOfDays <= 0 ? "Immediately".localized() : timerLbl
            
            cell.selectionStyle = .none
            cell.cellCheckboxBtn.setImage(UIImage(named: "checkbox"), for: .normal)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = UIColor.init(red: 211/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)
            
            let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            headerLabel.text = "Tests to be performed Currenlty.".localized()
            headerLabel.textAlignment = .center
            
            headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
            headerView.addSubview(headerLabel)
            
            return headerView
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = UIColor.init(red: 211/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)
            
            let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            headerLabel.text = "Tests to be performed in Future.".localized()
            headerLabel.textAlignment = .center
            
            headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
            headerView.addSubview(headerLabel)
            
            return headerView
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func openLinkButtonTapped(sender:UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebPageVC") as! WebPageVC
        vc.urlStr = self.currentTestsList[sender.tag].link
        self.present(vc, animated: true)
    }
    
    
    
}
// MARK: fuction to save data on server

extension TestsVC{
    
    func saveDataPostAPI(){
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                fcmKey = "abcdef"
            }
            
            for items in currentTestsList{
                self.data.id = items.id
                self.data.answer = items.answer
                self.data.description = items.description
                self.data.calendar_date = items.calendar_date
                self.calendarArray.append(items.calendar_date)
                self.saveData.data.append(data)
            }
            
            do {
                let jsonData = try JSONEncoder().encode(self.saveData.data)
                let thanedaarArr = try JSONSerialization.jsonObject(with: jsonData, options:[])
                self.structToJson = thanedaarArr as! [Any]
                print("************")
            } catch {  }
            
            guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else { return }
            print(deviceID)
            
            let param:[String:Any] = ["fcmkey": fcmKey,"device_id":deviceID,"data":self.dataDic, "email_id":UserDefaults.standard.value(forKey: "email") as! String,"lng": "en"]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.saveAnswerApi, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].boolValue
                if success {
                    
                    self.createEventinTheCalendar(forDate: self.saveData) //Store events in calendar
                    
                    //save to user defaults
                    let currentListDictionaries = self.currentTestsList.map({ $0.dictionaryRepresentation })
                    let futureListDictionaries = self.futureTestsList.map({ $0.dictionaryRepresentation })
                    UserDefaults().set(currentListDictionaries, forKey: "currentList")
                    UserDefaults().set(futureListDictionaries, forKey: "futureList")
                    
                    self.view.makeToast("Data saved successfully.".localized())
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                }
            }, errorBlock: { (NSError) in
                self.view.makeToast("An unexpected error has occurred. Please try again.")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
        }else{
            self.view.makeToast("An unexpected error has occurred. Please try again.")
            hideAllProgressOnView(appDelegateInstance.window!)
        }
    }
}

// MARK: functions to add events in calendar

extension TestsVC{
    
    func createEventinTheCalendar(forDate eventStartDate:DataSave_Struct) {
        
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                
                for item in eventStartDate.data{
                    for innerItem in item.calendar_date{
                        var dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: innerItem)
                        
                        let event = EKEvent.init(eventStore: self.store)
                        
                        event.title = item.answer
                        //                        event.description = item.description
                        event.calendar = self.store.defaultCalendarForNewEvents // this will return deafult calendar from device calendars
                        event.startDate = date
                        event.endDate = event.startDate.addingTimeInterval(60*60)
                        let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
                        event.addAlarm(alarm)
                        
                        do {
                            try self.store.save(event, span: .thisEvent)
                            //event created successfullt to default calendar
                        } catch let error as NSError {
                            print("failed to save event with error : \(error)")
                        }
                    }
                }
            } else {
                //we have error in getting access to device calnedar
                print("error = \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    //    func check_permission(startDates:[[String]],eventName:String){
    //
    //        let eventStore = EKEventStore()
    //        switch EKEventStore.authorizationStatus(for: .event){
    //        case .notDetermined:
    //            eventStore.requestAccess(to: .event){ (status,error) in
    //                if status {
    //                    self.indsert_event(store: eventStore, startDate: startDates, eventName: "Final Meeting")
    //                }else{
    //                    print(error?.localizedDescription)
    //                }
    //            }
    //        case .restricted:
    //            print("restricted")
    //        case .denied:
    //            print("denied")
    //        case .authorized:
    //            self.indsert_event(store: eventStore, startDate: startDates, eventName: eventName)
    //            print("authorized")
    //        default:
    //            print("unknown")
    //        }
    //    }
    
    //    func indsert_event(store:EKEventStore,startDate:[[String]],eventName:String){
    //
    //                for item in startDate{
    //                    for innerItem in item{
    //
    //                        var dateFormatter = DateFormatter()
    ////                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //                        dateFormatter.dateFormat = "yyyy-MM-dd"
    //                        let date = dateFormatter.date(from:innerItem)
    //
    //                        let event = EKEvent(eventStore: store)
    //
    //                        event.calendar = store.defaultCalendarForNewEvents // this will return deafult calendar from device calendars.
    //                        event.startDate = date!
    //                        event.title = eventName
    //                        event.endDate = event.startDate.addingTimeInterval(60*60)
    //                        event.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)]
    //                        let reminder1 = EKAlarm(relativeOffset: -60)
    //                        let reminder2 = EKAlarm(relativeOffset: -300)
    //                        event.alarms = [reminder1,reminder2]
    //                        do{
    //                            try store.save(event,span: .thisEvent)
    //                            print("Event inserted")
    //                        }catch{
    //                            print(error.localizedDescription)
    //                        }
    //                    }
    //                }
    //            }
    
    
}

