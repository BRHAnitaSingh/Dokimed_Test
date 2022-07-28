//
//  ViewController.swift
//  Lex
//
//  Created by ChawTech Solutions on 07/03/22.
//

import UIKit
import SkyFloatingLabelTextField
import Toast_Swift
import LanguageManager_iOS
//import MOLH

class ViewController: UIViewController {

    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTf: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTf: SkyFloatingLabelTextField!
    @IBOutlet weak var dobTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var quesTableView: UITableView!
    @IBOutlet weak var langBtn: UIButton!
    
    @IBOutlet weak var womanBtn: UIButton!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var smokeBtn: UIButton!
    @IBOutlet weak var nonSmokeBtn: UIButton!
    var lang = "en"
    var questionsList = [QuestionsList_Struct]()
    var duplicateQuestionsList = [QuestionsList_Struct]()
    var currentTestsList = [testList_Struct]()
    var futureTestsList = [testList_Struct]()
    var isMale = false
    var isSmoke = false
    var isPrivacyChecked = false
    let datePicker = UIDatePicker()
    var year = ""
    var month = ""
    var structToJson = [Any]()
    var needToResetSelection = false
    var calendarArray: [String] = []
    @IBOutlet weak var privacyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showDatePicker()
        self.needToResetSelection = false
        view.backgroundColor = UIColor.white
        UserDefaults.standard.set(self.lang, forKey: "lang")
//        if UserDefaults.standard.value(forKey: "lang") != nil {
//            self.lang = UserDefaults.standard.value(forKey: "lang") as! String
//            self.langBtn.setTitle(self.lang == "he" ? "Hebrew".localized() : "English".localized(), for: .normal)
//        }
        
        if L102Language.currentAppleLanguage() == "he" {
            L102Language.setAppleLAnguageTo(lang: "he")
            self.langBtn.setTitle("Hebrew".localized(), for: .normal)
            self.lang = "he"
            self.firstNameTf.isLTRLanguage = false
            self.dobTxtField.isLTRLanguage = false
            self.lastNameTf.isLTRLanguage = false
            self.emailTf.isLTRLanguage = false
            
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            self.langBtn.setTitle("English".localized(), for: .normal)
            self.lang = "en"
            self.firstNameTf.isLTRLanguage = true
            self.dobTxtField.isLTRLanguage = true
            self.lastNameTf.isLTRLanguage = true
            self.emailTf.isLTRLanguage = true
        }
        
        if let questionsListDictionariesFromUserDefaults = UserDefaults().array(forKey: "questionsList") as? [[String: Any]], questionsListDictionariesFromUserDefaults.count > 0 {
            self.firstNameTf.text = UserDefaults.standard.object(forKey: "firstName") as! String
            self.lastNameTf.text = UserDefaults.standard.object(forKey: "lastName") as! String
            self.emailTf.text = UserDefaults.standard.object(forKey: "email") as! String
            self.dobTxtField.text = UserDefaults.standard.object(forKey: "dob") as! String
            self.isMale = UserDefaults.standard.object(forKey: "sex") as! Bool
            self.isSmoke = UserDefaults.standard.object(forKey: "smoke") as! Bool
            self.isPrivacyChecked = UserDefaults.standard.object(forKey: "privacy") as! Bool
            
            
            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from:self.dobTxtField.text!)!
            dateFormatter.dateFormat = "yyyy"
            self.year = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MM"
            self.month = dateFormatter.string(from: date)
            
            if isMale {
                self.manBtn.setImage(UIImage.init(named: "men-check"), for: .normal)
                self.womanBtn.setImage(UIImage.init(named: "woman"), for: .normal)
            } else {
                self.womanBtn.setImage(UIImage.init(named: "lady-check"), for: .normal)
                self.manBtn.setImage(UIImage.init(named: "man"), for: .normal)
            }
            
            if !isSmoke {
                self.smokeBtn.setImage(UIImage.init(named: "smoke-check"), for: .normal)
                self.nonSmokeBtn.setImage(UIImage.init(named: "noSmoke"), for: .normal)
            } else {
                self.nonSmokeBtn.setImage(UIImage.init(named: "noSmoke-check"), for: .normal)
                self.smokeBtn.setImage(UIImage.init(named: "smoke"), for: .normal)
            }
            
            if isPrivacyChecked {
                self.privacyBtn.setImage(UIImage(named: "checkbox_chk"), for: .normal)
            } else {
                self.privacyBtn.setImage(UIImage(named: "checkbox"), for: .normal)
            }
            
            self.getVCDataFromUserDefaults()
            
        } else {
            self.getQuestionsList()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteTapped(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
    }
    
    @objc func deleteTapped(notification: Notification) {
        self.lang = UserDefaults.standard.value(forKey: "lang") as! String
        self.manBtn.setImage(UIImage.init(named: "man"), for: .normal)
        self.womanBtn.setImage(UIImage.init(named: "woman"), for: .normal)
        self.smokeBtn.setImage(UIImage.init(named: "smoke"), for: .normal)
        self.nonSmokeBtn.setImage(UIImage.init(named: "noSmoke"), for: .normal)
        self.privacyBtn.setImage(UIImage(named: "checkbox"), for: .normal)
        self.isPrivacyChecked = false
        self.dobTxtField.text = ""
        self.firstNameTf.text = ""
        self.lastNameTf.text = ""
        self.emailTf.text = ""
        self.resetDefaults()
        self.getQuestionsList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        
//        self.questionsList = self.duplicateQuestionsList
//        DispatchQueue.main.async {
//            self.manBtn.setImage(UIImage.init(named: "man"), for: .normal)
//            self.womanBtn.setImage(UIImage.init(named: "woman"), for: .normal)
//            self.smokeBtn.setImage(UIImage.init(named: "smoke"), for: .normal)
//            self.nonSmokeBtn.setImage(UIImage.init(named: "noSmoke"), for: .normal)
//            self.dobTxtField.text = ""
//            self.firstNameTf.text = ""
//            self.lastNameTf.text = ""
//            self.emailTf.text = ""
//            self.quesTableView.reloadData()
//        }
//        
//    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
       
//        datePicker.accessibilityLanguage = L102Language.currentAppleLanguage()
        let loc = Locale(identifier: L102Language.currentAppleLanguage())
        datePicker.locale = loc
        
        let prefLanguage = Locale.preferredLanguages[0]
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = NSLocale(localeIdentifier: prefLanguage) as Locale
        print(calendar.shortWeekdaySymbols)
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dobTxtField.inputAccessoryView = toolbar
        dobTxtField.inputView = datePicker
        
    }

      @objc func donedatePicker(){

          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          dobTxtField.text = formatter.string(from: datePicker.date)
//          formatter.locale = Locale
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy"
          self.year = dateFormatter.string(from: self.datePicker.date)
          dateFormatter.dateFormat = "MM"
          self.month = dateFormatter.string(from: self.datePicker.date)
          self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
    @IBAction func changeLanguageAction(_ sender: Any) {
        self.openActionSheet()
    }
    
    @IBAction func viewTestsAction(_ sender: UIButton) {
        if self.firstNameTf.text!.isEmpty {
            self.view.makeToast("Please enter your first name.".localized())
            return
        } else if self.lastNameTf.text!.isEmpty {
            self.view.makeToast("Please enter your last name.".localized())
            return
        } else if self.emailTf.text!.isEmpty {
            self.view.makeToast("Please enter your email.".localized())
            return
        } else if self.dobTxtField.text!.isEmpty {
            self.view.makeToast("Please select your DOB".localized())
            return
        } else if checkIfAnyQuestionIsNotAnswered() {
            self.view.makeToast("Please answer all the question.".localized())
            return
        } else if !self.isPrivacyChecked {
            self.view.makeToast("Please agree to our privacy policy.".localized())
            return
        }
//        do {
//            let jsonData = try JSONEncoder().encode(self.questionsList)
//            if let structToJsonn = String(data: jsonData, encoding: .utf8)
//            {
//                print(structToJsonn)
//                self.structToJson = structToJsonn
//            }
//
//
//        } catch {  }
        
        do {
            let jsonData = try JSONEncoder().encode(self.questionsList)
            
            let thanedaarArr = try JSONSerialization.jsonObject(with: jsonData, options:[])
//            print(thanedaarArr)
            self.structToJson = thanedaarArr as! [Any]
        } catch {  }
        
        self.postWorkStatusToAdminAPI()
        
    }
    
    func checkIfAnyQuestionIsNotAnswered() -> Bool {
        var notAnswered = false
        for i in self.questionsList {
            if i.answer == "" {
                notAnswered = true
                break
            }
        }
        return notAnswered
    }
    
    @IBAction func sexAction(_ sender: UIButton) {
        isMale = sender.tag == 101 ? true : false
        if isMale {
            self.manBtn.setImage(UIImage.init(named: "men-check"), for: .normal)
            self.womanBtn.setImage(UIImage.init(named: "woman"), for: .normal)
        } else {
            self.womanBtn.setImage(UIImage.init(named: "lady-check"), for: .normal)
            self.manBtn.setImage(UIImage.init(named: "man"), for: .normal)
        }

    }
    
    @IBAction func smokerAction(_ sender: UIButton) {
        isSmoke = sender.tag == 201 ? true : false
        if !isSmoke {
            self.smokeBtn.setImage(UIImage.init(named: "smoke-check"), for: .normal)
            self.nonSmokeBtn.setImage(UIImage.init(named: "noSmoke"), for: .normal)
        } else {
            self.nonSmokeBtn.setImage(UIImage.init(named: "noSmoke-check"), for: .normal)
            self.smokeBtn.setImage(UIImage.init(named: "smoke"), for: .normal)
        }
    }
    
    @IBAction func yesNoCellAction(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = quesTableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        print("button is in row \(indexPath.row)")
        self.questionsList[indexPath.row].answer = (sender.titleLabel?.text!)!
    }
    
    @IBAction func privacyCheckAction(_ sender: Any) {
        if !isPrivacyChecked {
            self.privacyBtn.setImage(UIImage(named: "checkbox_chk"), for: .normal)
        } else {
            self.privacyBtn.setImage(UIImage(named: "checkbox"), for: .normal)
        }
        self.isPrivacyChecked = !self.isPrivacyChecked
        
    }
    
    
    @IBAction func privacyAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebPageVC") as! WebPageVC
        vc.urlStr = "https://dokiudif.com/privacy-policy"
        self.present(vc, animated: true)
    }
    
    
    func openActionSheet() {
        let alert = UIAlertController(title: "Language".localized(), message: "Please Select language".localized(), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English".localized(), style: .default , handler:{ (UIAlertAction)in
            UserDefaults().removeObject(forKey: "questionsList")
            L102Language.setAppleLAnguageTo(lang: "en")
            UserDefaults.standard.set("en", forKey: "lang")
            self.lang = "en"
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            self.firstNameTf.textAlignment = .right
//            self.firstNameTf.semanticContentAttribute = .forceLeftToRight
//            self.dobTxtField.semanticContentAttribute = .forceLeftToRight
//            self.dobTxtField.layoutIfNeeded()
            Bundle.setLanguage("en")
//            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
//            MOLH.reset()
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            LanguageManager.shared.setLanguage(language: .en)
//                { title -> UIViewController in
//                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                  // the view controller that you want to show after changing the language
//                  return storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                } animation: { view in
//                  // do custom animation
//                  view.transform = CGAffineTransform(scaleX: 2, y: 2)
//                  view.alpha = 0
//                }
        }))
        
        alert.addAction(UIAlertAction(title: "Hebrew".localized(), style: .default , handler:{ (UIAlertAction)in
            UserDefaults().removeObject(forKey: "questionsList")
            self.lang = "he"
            L102Language.setAppleLAnguageTo(lang: "he")
            UserDefaults.standard.set("he", forKey: "lang")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextView.appearance().semanticContentAttribute = .forceRightToLeft
            self.firstNameTf.textAlignment = .left
//            self.firstNameTf.semanticContentAttribute = .forceRightToLeft
//            self.dobTxtField.semanticContentAttribute = .forceRightToLeft
//            self.dobTxtField.layoutIfNeeded()
            Bundle.setLanguage("he")
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let domain = Bundle.main.bundleIdentifier!
//            UserDefaults.standard.removePersistentDomain(forName: domain)
//            UserDefaults.standard.synchronize()
//            self.resetDefaults()
            
            self.getQuestionsList()
            
//            LanguageManager.shared.setLanguage(language: .he)
//                { title -> UIViewController in
//                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                  // the view controller that you want to show after changing the language
//                  return storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                } animation: { view in
//                  // do custom animation
//                  view.transform = CGAffineTransform(scaleX: 2, y: 2)
//                  view.alpha = 0
//                }
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //MARK: : GE Questions API
    func  getQuestionsList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            let param:[String:String] = [:]
            let url = PROJECT_URL.getQuestionListApi + "?lang=\(self.lang)"
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlString, successBlock: { (json) in
                debugPrint(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].boolValue
                if success {
                    let data = json["data"].arrayValue
                    self.questionsList.removeAll()
                    for i in 0..<data.count {
                        
                        let question = data[i]["question"].stringValue
                        let question_type = data[i]["question_type"].stringValue
                        let order = data[i]["order"].intValue
                        let id = data[i]["id"].stringValue
                        
                        self.questionsList.append(QuestionsList_Struct.init(order: order, id: id, question: question, question_type: question_type))
                        self.duplicateQuestionsList.append(QuestionsList_Struct.init(order: order, id: id, question: question, question_type: question_type))
                    }
                    
                    DispatchQueue.main.async {
                        self.quesTableView.reloadData()
                    }
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func postWorkStatusToAdminAPI() {
        if Reachability.isConnectedToNetwork() {
//            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                //                fcmKey = ""
                fcmKey = "abcdef"
            }
                
            let param:[String:Any] = ["lang": self.lang, "age_year": self.year,"age_month": self.month, "data": structToJson, "gender": self.isMale ? "male" : "female"]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.submitAnswerApi, successBlock: { (json) in
                print(json)
//                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].boolValue
                if success {
                    let currentData = json["data"]["currentList"].arrayValue
                    let futureData = json["data"]["futuredList"].arrayValue
                    self.currentTestsList.removeAll()
                    self.futureTestsList.removeAll()
                    for i in 0..<currentData.count {
                        
                        let description = currentData[i]["description"].stringValue
                        let answer = currentData[i]["answer"].stringValue
                        let order = currentData[i]["order"].intValue
                        let id = currentData[i]["id"].stringValue
                        let at_what_age = currentData[i]["at_what_age"].intValue
                        let how_often_year_label = currentData[i]["how_often_year_label"].stringValue
                        let how_often_year = currentData[i]["how_often_year"].stringValue
                        let calendar_date = currentData[i]["calendar_date"].arrayValue
//                        let calendarFirstDate = currentData[i]["calendar_date"][0].str
                        let link = currentData[i]["link"].stringValue
                        let is_check = currentData[i]["is_check"].boolValue
                        
                        if calendar_date.count > 0 {
                            self.calendarArray.removeAll()
                            for j in calendar_date {
                                self.calendarArray.append("\(j)")
                            }
                        }
//                        var calendarFirstDate = ""
//                        var index = -1
//                        for k in calendar_date {
//                            index += 1
//                            let startDate = "\(k)"
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy-MM-dd"
//                            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                            let formatedStartDate = dateFormatter.date(from: startDate)
//
//                            let currentDate = Date()
//                            dateFormatter.dateFormat = "yyyy-MM-dd"
//                            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                            let formatedCurrentDate = dateFormatter.date(from: currentDate.string(format: "yyyy-MM-dd"))
//
//                            print(formatedStartDate! >= formatedCurrentDate!)
//                            if formatedStartDate! >= formatedCurrentDate! {
//                                calendarFirstDate = calendar_date[index].stringValue
//                                break
//                            }
//                        }
//                        let calendarFirstDate = currentData[i]["calendar_date"][k].stringValue
                        let calendarFirstDate = self.calendarArray[0]
                        let numberOfdays = calendarFirstDate.numberOfDaysInBetween(calendarFirstDate)
                        let timerLbl = getTimerLabel(calendarFirstDate)
                        self.currentTestsList.append(testList_Struct.init(order: order, id: id, description: description, answer: answer, at_what_age: at_what_age, how_often_year_label: how_often_year_label, how_often_year: how_often_year, link: link, calendar_date: self.calendarArray, is_check: is_check, gender: self.isMale ? "male" : "female", age_year: "2022", age_month: "03", timer_day: "\(timerLbl.2)", timer_month: "\(timerLbl.1)", timer_year: "\(timerLbl.0)", label_day: "", lng: "en", numberOfDays: Int(numberOfdays)!))
                    }
                    
                    self.currentTestsList = self.currentTestsList.sorted(by: { $0.numberOfDays < $1.numberOfDays })
                    
                    for i in 0..<futureData.count {
                        
                        let description = futureData[i]["description"].stringValue
                        let answer = futureData[i]["answer"].stringValue
                        let order = futureData[i]["order"].intValue
                        let id = futureData[i]["id"].stringValue
                        let at_what_age = futureData[i]["at_what_age"].intValue
                        let how_often_year_label = futureData[i]["how_often_year_label"].stringValue
                        let calendar_date = futureData[i]["calendar_date"].arrayValue
                        let link = futureData[i]["link"].stringValue
                        let is_check = futureData[i]["is_check"].boolValue
                        if calendar_date.count > 0 {
                            self.calendarArray.removeAll()
                            for j in calendar_date {
                                self.calendarArray.append("\(j)")
                            }
                        }
                        
                        var futureCalendarFirstDate = ""
                        var index = -1
                        for k in calendar_date {
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
                                futureCalendarFirstDate = calendar_date[index].stringValue
                                break
                            }
                        }
                        
                        let futureNumberOfdays = futureCalendarFirstDate.numberOfDaysInBetween(futureCalendarFirstDate)
                        let futureTimerLbl = getTimerLabel(futureCalendarFirstDate)
                        
                        self.futureTestsList.append(testList_Struct.init(order: order, id: id, description: description, answer: answer, at_what_age: at_what_age, how_often_year_label: how_often_year_label, link: link, calendar_date: self.calendarArray, is_check: is_check, gender: self.isMale ? "male" : "female", age_year: "2022", age_month: "03", timer_day: "\(futureTimerLbl.2)", timer_month: "\(futureTimerLbl.1)", timer_year: "\(futureTimerLbl.0)", label_day: "", lng: "en", numberOfDays: Int(futureNumberOfdays)!))
                    }
                    
                    self.futureTestsList = self.futureTestsList.sorted(by: { $0.numberOfDays < $1.numberOfDays })
                    print(self.futureTestsList)
                    print(self.currentTestsList)
//                    print(self.currentTestsList.count)
//                    print(self.futureTestsList.count)
                    self.saveToUserDefaults()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestsVC") as! TestsVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.modalPresentationStyle = .fullScreen
                    vc.currentTestsList = self.currentTestsList
                    vc.futureTestsList = self.futureTestsList
                    self.needToResetSelection = false
                    self.present(vc, animated: true)
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
//                hideAllProgressOnView(appDelegateInstance.window!)
            })
        }else{
//            hideAllProgressOnView(appDelegateInstance.window!)
//            //UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    @objc func textChanged(textField: UITextField) {
        let index = textField.tag
        // this index is equal to the row of the textview
        debugPrint("Textfeild index is \(index)")
//        if Int(textField.text!) ?? 0 > 100 {
//            self.view.makeToast("Please enter value less than 100.")
//            textField.text = ""
//            self.questionsList[index].answer = ""
//            return
//        }
        
        if self.questionsList[index].question == "what is your weight?" {
            self.view.makeToast("Please input value between 1 to 250.".localized())
            textField.text = ""
            self.questionsList[index].answer = ""
            return
        }
        if self.questionsList[index].question == "What is your height?" {
            self.view.makeToast("Please input height between 5 to 275.".localized())
            textField.text = ""
            self.questionsList[index].answer = ""
            return
        }
        self.questionsList[index].answer = textField.text!
    }
    
//    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
//        var screenshotImage :UIImage?
//        let layer = UIApplication.shared.keyWindow!.layer
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
//        guard let context = UIGraphicsGetCurrentContext() else {return nil}
//        layer.render(in:context)
//        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        if let image = screenshotImage, shouldSave {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
//        return screenshotImage
//    }
    
    func snapshot() -> UIImage?
    {
        UIGraphicsBeginImageContext(quesTableView.contentSize)
        
        let savedContentOffset = quesTableView.contentOffset
        let savedFrame = quesTableView.frame
        
        quesTableView.contentOffset = CGPoint.zero
        quesTableView.frame = CGRect(x: 0, y: 0, width: quesTableView.contentSize.width, height: quesTableView.contentSize.height)
        
        quesTableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        quesTableView.contentOffset = savedContentOffset
        quesTableView.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func saveToUserDefaults() {
//        // [Struct] -> [Dictionary]
//        let currentTestsListDictionaries = currentTestsList.map({ $0.dictionaryRepresentation })
//        let futureTestsListDictionaries = futureTestsList.map({ $0.dictionaryRepresentation })
//        // [Dictionary] to UserDefaults
//        UserDefaults().set(currentTestsListDictionaries, forKey: "currentTestsList")
//        UserDefaults().set(futureTestsListDictionaries, forKey: "futureTestsList")
        // [Struct] -> [Dictionary]
        let questionsListDictionaries = questionsList.map({ $0.dictionaryRepresentation })
        let currentListDictionaries = currentTestsList.map({ $0.dictionaryRepresentation })
        let futureListDictionaries = futureTestsList.map({ $0.dictionaryRepresentation })
        
        // [Dictionary] to UserDefaults
        UserDefaults().set(questionsListDictionaries, forKey: "questionsList")
        UserDefaults().set(currentListDictionaries, forKey: "currentList")
        UserDefaults().set(futureListDictionaries, forKey: "futureList")
        
        UserDefaults().set(self.firstNameTf.text!, forKey: "firstName")
        UserDefaults().set(self.lastNameTf.text!, forKey: "lastName")
        UserDefaults().set(self.emailTf.text!, forKey: "email")
        UserDefaults().set(self.dobTxtField.text!, forKey: "dob")
        UserDefaults().set(self.isMale, forKey: "sex")
        UserDefaults().set(self.isSmoke, forKey: "smoke")
        UserDefaults().set(self.isPrivacyChecked, forKey: "privacy")
        
    }
    
    func getVCDataFromUserDefaults() {
//        // [Dictionary] from UserDefaults
//        let currentListDictionariesFromUserDefaults = UserDefaults().array(forKey: "currentTestsList")! as! [[String: Any]]
//        let futureListDictionariesFromUserDefaults = UserDefaults().array(forKey: "futureTestsList")! as! [[String: Any]]
//        // [Dictionary] -> [Struct]
//        self.currentTestsList = currentListDictionariesFromUserDefaults.compactMap({ testList_Struct(dictionary: $0) })
//        self.futureTestsList = futureListDictionariesFromUserDefaults.compactMap({ testList_Struct(dictionary: $0) })
        
        // [Dictionary] from UserDefaults
        let questionsListDictionariesFromUserDefaults = UserDefaults().array(forKey: "questionsList")! as! [[String: Any]]
        // [Dictionary] -> [Struct]
        self.questionsList = questionsListDictionariesFromUserDefaults.compactMap({ QuestionsList_Struct(dictionary: $0) })
        DispatchQueue.main.async {
            self.quesTableView.reloadData()
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestsVC") as! TestsVC
//                    self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
//        vc.currentTestsList = self.currentTestsList
//        vc.futureTestsList = self.futureTestsList
        self.needToResetSelection = false
        self.present(vc, animated: true)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(self.questionsList)
        let info = self.questionsList[indexPath.row]
        if info.question_type == "input" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            
            if info.answer.isEmpty {
                cell.textFeild.placeholder = info.question
                cell.textFeild.text = ""
            } else {
                cell.textFeild.text = info.answer
            }
            
//            cell.textFeild.delegate = self
            cell.textFeild.tag = indexPath.row
            if self.lang == "he" {
                cell.textFeild.isLTRLanguage = false
            } else {
                cell.textFeild.isLTRLanguage = true
            }
            
            cell.textFeild.addTarget(self, action: #selector(textChanged(textField:)), for: .editingDidEnd)
//            addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
            
//            if info.answer == "Yes" || info.answer == "כן" {
//                cell.noLbl.isSelected = false
//                cell.yesLbl.isSelected = true
//            } else if info.answer == "No" || info.answer == "לא" {
//                cell.noLbl.isSelected = true
//                cell.yesLbl.isSelected = false
//            } else {
//                cell.noLbl.isSelected = false
//                cell.yesLbl.isSelected = false
//            }
//
//            cell.selectionStyle = .none
            if needToResetSelection {
                cell.textFeild.placeholder = info.question
                cell.textFeild.text = ""
            }
            
            return  cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            
            cell.quesLbl.text = info.question
            
            if info.answer == "Yes" || info.answer == "כן" {
                cell.noLbl.isSelected = false
                cell.yesLbl.isSelected = true
            } else if info.answer == "No" || info.answer == "לא" {
                cell.noLbl.isSelected = true
                cell.yesLbl.isSelected = false
            } else {
                cell.noLbl.isSelected = false
                cell.yesLbl.isSelected = false
            }
            
            cell.selectionStyle = .none
            if needToResetSelection {
                cell.yesLbl.isSelected = false
                cell.noLbl.isSelected = false
            }
            
            return  cell
        }
        
    }
    
    
}

//extension ViewController: UITextFieldDelegate {
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        let cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
//        let table: UITableView = cell.superview as! UITableView
//        let textFieldIndexPath = table.indexPath(for: cell)!
//        debugPrint(textFieldIndexPath)
//    }
//}

//extension UITextField {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if L102Language.currentAppleLanguage() == "he" {
//            if textAlignment == .natural {
//                self.textAlignment = .right
//            }
//        }
//    }
//}


// Converting to dictionary
extension testList_Struct {
    var dictionaryRepresentation: [String: Any] {
        let data = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }
}
// Converting back to struct
extension testList_Struct {
    init?(dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return nil }
        guard let info = try? JSONDecoder().decode(testList_Struct.self, from: data) else { return nil }
        self = info
    }
}

// Converting to dictionary
extension QuestionsList_Struct {
    var dictionaryRepresentation: [String: Any] {
        let data = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }
}
// Converting back to struct
extension QuestionsList_Struct {
    init?(dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return nil }
        guard let info = try? JSONDecoder().decode(QuestionsList_Struct.self, from: data) else { return nil }
        self = info
    }
}
