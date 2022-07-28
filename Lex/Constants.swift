//
//  Constants.swift
//  TeamLink
//
//  Created by chawtech solutions on 3/01/18.
//  Copyright © 2018 chawtech solutions. All rights reserved.

import UIKit
import MBProgressHUD
import AVFoundation
import SwiftyJSON
import SDWebImage
//import SkyFloatingLabelTextField
//import Toast_Swift

let regularFont = UIFont.systemFont(ofSize: 16)
let boldFont = UIFont.boldSystemFont(ofSize: 16)
let IS_IPHONE_5 = UIScreen.main.bounds.width == 320
let IS_IPHONE_6 = UIScreen.main.bounds.width == 375
let IS_IPHONE_6P = UIScreen.main.bounds.width == 414
let IS_IPAD = UIScreen.main.bounds.width >= 768.0
let IS_IPAD_Mini = UIScreen.main.bounds.width == 768.0
let IS_IPAD_Pro = UIScreen.main.bounds.width == 834.0
let IS_IPAD_Pro12 = UIScreen.main.bounds.width == 1024.0
let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate
var myNewlyAddedImages = [UIImage]()
var CategoiresImagesIDArray = [String]()
 var categoiresimagarray = [URL]()
var categoiresNewimagearray = [UIImage]()
var NewinspectionIdStr : String? = ""
var imageCount : Int = 1
var uploadedimageCount : Int = 0
var myImagesDecoded = [UIImage]()
var inspectionIdStr : String? = ""
var myImagesID = [String]()
var imageUrlArray = [URL]();
var global : String? = ""
var myImagespath = [URL]()
var ButtonClickcountPics : Int = 0

let deviceType = "iOS"
let kPasswordMinimumLength = 6
let kPasswordMaximumLength = 15
let kUserFullNameMaximumLength = 56
let kPhoneNumberMaximumLength = 10
let kMessageMinimumLength = 25
let kMessageMaximumLength = 250
let selectionColor = UIColor(red: 123/255.0, green: 107/255.0, blue: 255/255.0, alpha: 1.0)
let kLostInternetConnectivityAlertString = "Your internet connection seems to be lost." as String
let kPasswordLengthAlertString = NSString(format:"The Password should consist at least %d characters.",kPasswordMinimumLength) as String
let kPasswordWhiteSpaceAlertString = "The Password should not contain any whitespaces." as String
let kUnequalPasswordsAlertString = "Both Passwords do not match." as String
let kEqualPasswordsAlertString = "Old & New Password are same." as String
let kMessageTextViewPlaceholderString = "Write your experience..." as String
let kMesssageLengthAlertString = NSString(format:"The Message should consist at least %d-%d characters.",kMessageMinimumLength,kMessageMaximumLength) as String
let kUnexpectedErrorAlertString = "An unexpected error has occurred. Please try again." as String
let kNoDataFoundAlertString = "Sorry! No data found." as String
let kChooseAnyOneOpttionAlertString = "Please choose any one option" as String
let kSignUpCaseAlertString = "Password should contains at least 1 Upper Case, 1 Lower Case, 1 number & 1 special character."
var countryArr = [String]()
//http://35.160.227.253/SaharaGo/File/
let BASE_URL = "https://dokimed.chawtechsolutions.ch/api"
let FLAG_BASE_URL = "http://35.160.227.253/SaharaGo/Flag"
//let FILE_BASE_URL = "http://allin1inspections.chawtechsolutions.ch/admin/admin_assets/inspection_images/thumbnail"
let FILE_BASE_URL = "https://allin1inspections.com/admin/admin_assets/inspection_images/thumbnail"
let BANNER_BASE_URL = "http://35.160.227.253/SaharaGo/Banner/"
let TRUST_BASE_URL = "http://35.160.227.253:8081"
let IMAGE_URL = ""
let GOOGLE_API_KEY =  "AIzaSyDwBRVfP3aoCIZ77fhT1Gj8ntbKoL01qPE"
let X_API_KEY = "SPQBhoUsPfrldEnoWl4JFdKsRshby8Dl5Q7s1m5DehphKDuTB1NiCu4F29nkxWMz"

var fcmKey:String = "dudaaaa"
var stateArr = [String]()
var countArr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
var isExpanded = true
var isNewInspection = false
var newInspectionArray = NSMutableDictionary()
var clientInfoArray = NSMutableDictionary()
var retailorInfoArray = NSMutableDictionary()
var inspectionInfoArray = NSMutableDictionary()
var paymentInfoArray = NSMutableDictionary()
var isNewInspect = "iSNewInspect"
var isUpdate = false
var isInspectionInfoSaved = false
var isDelete:Bool = false
var isFromDB = false
var isNewInspectionSaved = false



@available(iOS 10.0, *)
var appDelegate = UIApplication.shared.delegate as! AppDelegate
@available(iOS 10.0, *)
//var context = appDelegate.persistentContainer.viewContext
//var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

struct PROJECT_URL {
    
    static let LOGIN = "/login"
    static let CHANGE_PASSWORD = "/profile/change_password"
    static let UPDATE_PROFILE = "/profile/update"
    static let GET_INSPECTION_LIST = "/inspection/get_assigned_property"
    static let FORGET_PASSWORD = "/login/forgot_password"
    static let GET_CLIENT_INFO = "/inspection/get_property_client"
    static let GET_RETALORS_INFO = "/inspection/get_property_retalor"
    static let GET_INSPECTION_INFO = "/inspection/get_property_info"
    static let GET_STATE = "/inspection/get_state"
    static let SAVE_CLIENT_INFO = "/inspection/update_client_info"
    static let SAVE_REALTOR_INFO = "/inspection/update_retalor_info"
    static let GET_INSPECTION_TAGS = "/inspection/get_inspection_tag"
    static let GET_INSPECTION_TYPE = "/inspection/get_inspection_type"
    static let SAVE_INSPECTION_INFO = "/inspection/update_inspection_info"
    static let PAYMENT_INSPECTION_INFO = "/inspection/get_payment_info"
    static let SAVE_PAYMENT_INFO = "/inspection/update_payment_info"
    
    static let GET_PICS = "/inspection/get_inspection_image"
    static let GET_ADDITIONAL_PICS = "/inspection/get_additional_image"
    static let GET_INSPECT_CATEGORIES = "/inspection/get_category?type=inspect"
    static let GET_ALL_CATEGORIES = "/inspection/get_category"
    static let GET_SUB_CATEGORY = "/inspection/get_subcategory"
    static let ASSIGN_IMAGE = "/inspection/assign_image"
    static let GET_QUESTION_ANSWER = "/inspection/get_question_answer"
    static let GET_WIND_MITIGATION_CATEGORIES = "/inspection/get_category?type=wind-mitigation"
    static let GET_4_POINT_CATEGORIES = "/inspection/get_category?type=4-point"
    static let SAVE_QUESTIONS = "/inspection/save_question_answer"
    
    static let getSyncAllDataApi  = "https://allin1inspections.chawtechsolutions.ch/admin/api/inspection/get_assigned_property"

    static let getQuestionListApi = BASE_URL + "/questions"
    static let submitAnswerApi = "/submitanswer"
    static let saveAnswerApi = "/saveanswer"

}

struct CONDITION_KEYS {
    static let EMAIL_OTP = "emailOtp"
    static let MOBILE_OTP = "mobileOtp"
}

struct USER_DEFAULTS_KEYS {
    
    static let VENDOR_SIGNUP_OTP_ID = "vendorSignupOtpId"
    static let VENDOR_SIGNUP_TOKEN = "vendorSignupToken"
    static let USER_TYPE = "userType"
    static let CART_ID = "cartId"
    static let USER_ID = "userId"
    static let CART_PRODUCTS = "cartProducts"
    static let COUNTRY_COLOR_CODE = "countryColorCode"
    static let SELECTED_COUNTRY = "selectedCountry"
    static let SELECTED_FLAG = "selectedFlag"
    static let IS_LOGIN = "isLogin"
    static let FCM_KEY = "fcmKey"
    
    
    static let LOGIN_TOKEN = "loginToken"
    static let INSPECTOR_FIRST_NAME = "firstName"
    static let INSPECTOR_LAST_NAME = "lastName"
    static let INSPECTOR_EMAIL = "email"
    static let INSPECTIONPIC_COUNT = "inspectionpiccount"
    static let assign_inspector_name = "assign_inspector_name"
    static let assign_agent_id = "assign_agent_id"

    
    
}
struct NOTIFICATION_KEYS
{
    static let PROFILE_ADD_UPDATE = "profileaddupdate"
    static let EVENT_ADD_UPDATE = "eventaddupdate"
}

func getTimerLabel(_ startDate: String) -> (Int, Int, Int) {
    let startDate = startDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let formatedStartDate = dateFormatter.date(from: startDate)
    
    let currentDate = Date()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let formatedCurrentDate = dateFormatter.date(from: currentDate.string(format: "yyyy-MM-dd"))
    let components = Set<Calendar.Component>([.day, .month, .year])
//            let components = Set<Calendar.Component>([.day])
    let differenceOfDate = Calendar.current.dateComponents(components, from: formatedCurrentDate!, to: formatedStartDate!)
    return (differenceOfDate.year ?? 0, differenceOfDate.month ?? 0, differenceOfDate.day ?? 0)
}

func removeController(rootController:UINavigationController)
{
    for controller in rootController.viewControllers
    {
        if  controller is UITabBarController
        {
            
        }
        else
        {
            controller.removeFromParent()
        }
    }
}
//MARK:- Remove User Defaults
func flushUserDefaults() {
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
}

//MARK:- MBProgressHUD Methods
func showProgressOnView(_ view:UIView) {
    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.indeterminate
    loadingNotification.label.text = "Loading.."
}

func hideProgressOnView(_ view:UIView) {
    MBProgressHUD.hide(for: view, animated: true)
}

func hideAllProgressOnView(_ view:UIView) {
//    MBProgressHUD.hideAllHUDs(for: view, animated: true)
    MBProgressHUD.hide(for: view, animated: true)
}

//MARK:-document directory realted method
public func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
public func getImageUrl() -> URL? {
    let url = URL(fileURLWithPath: (getDirectoryPath() as NSString).appendingPathComponent("temp.jpeg"))
    return url
}

public func saveImageDocumentDirectory(usedImage:UIImage, nameStr:String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(nameStr)
    let imageData = usedImage.jpegData(compressionQuality: 0.1)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}
public func saveImageDocumentDirectory(usedImage:UIImage)
{
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("temp.jpeg")
    let imageData = usedImage.jpegData(compressionQuality: 0.1)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

func deleteDirectory(name:String){
    
    let fileManager = FileManager.default
    do {
        let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for url in fileURLs {
            try fileManager.removeItem(at: url)
        }
    } catch {
        print(error)
    }
}

//MARK:- Fetch Device Width
func fetchDeviceWidth() -> CGFloat {
    if IS_IPHONE_5 {
        return 320
    } else if IS_IPHONE_6 {
        return 375
    } else if IS_IPHONE_6P{
        return 414
    }else if IS_IPAD_Mini {
        return 768
    } else if IS_IPAD_Pro {
        return 834.0
    }
    else if IS_IPAD_Pro12 {
        return 760
    }
    else {
        return 1024
    }
}
//MARK:- Fetch Device Height

func fetchDeviceHeight() -> CGFloat {
    if IS_IPHONE_5 {
        return 568
    } else if IS_IPHONE_6 {
        return 667
    } else if IS_IPHONE_6P {
        return 736
    } else if IS_IPAD_Mini {
        return 1024
    } else if IS_IPAD_Pro  {
        return 1112
    } else if IS_IPAD_Pro12  {
        return 1366
    }else {
        return 1366
    }
    
}

public func disableEditinginTextFieldWithTagArr(tagList:Array<Int>,targetView:UIView)
{
    for index in tagList
    {
        let txtField =  targetView.viewWithTag(index) as! UITextField
        txtField.isEnabled = false
    }
}


public func isTimeLyingBetween(target:String,from:String,to:String) -> Bool
{
    var isTimeLying = false
    let formatter = DateFormatter()
    //formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    let fromTime = formatter.date(from: from)
    let toTime = formatter.date(from: to)
    let targetTime = formatter.date(from: target)
    
    if (fromTime?.compare(targetTime!) == .orderedAscending) && (targetTime?.compare(toTime!) == .orderedAscending)
    {
        isTimeLying = true
    }
    return isTimeLying
    
}

public func getTimeInAmPm()-> String?
{
    let formatter = DateFormatter()
    // formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    // formatter.dateFormat = "h:mm a yyyy-MM-dd HH:mm:ss"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    let dateString = formatter.string(from: Date())
    print("dateInAmPm : \(dateString)")
    return dateString
}

public func getDayName()->String?
{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let today = formatter.string(from: date)
    
    if let todayDate = formatter.date(from: today)
    {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            print("Error fetching days")
            return "Day"
        }
    } else {
        return nil
    }
}
func getCountryCodeAndName()
{
    var countryDictionary = ["AF":"93", "AL":"355", "DZ":"213","AS":"1", "AD":"376", "AO":"244", "AI":"1","AG":"1","AR":"54","AM":"374","AW":"297","AU":"61","AT":"43","AZ":"994","BS":"1","BH":"973","BD":"880","BB":"1","BY":"375","BE":"32","BZ":"501","BJ":"229","BM":"1","BT":"975","BA":"387","BW":"267","BR":"55","IO":"246","BG":"359","BF":"226","BI":"257","KH":"855","CM":"237","CA":"1","CV":"238","KY":"345","CF":"236","TD":"235","CL":"56","CN":"86","CX":"61","CO":"57","KM":"269","CG":"242","CK":"682","CR":"506","HR":"385","CU":"53","CY":"537","CZ":"420","DK":"45","DJ":"253","DM":"1","DO":"1","EC":"593","EG":"20","SV":"503","GQ":"240","ER":"291","EE":"372","ET":"251","FO":"298","FJ":"679","FI":"358","FR":"33","GF":"594","PF":"689","GA":"241","GM":"220","GE":"995","DE":"49","GH":"233","GI":"350","GR":"30","GL":"299","GD":"1","GP":"590","GU":"1","GT":"502","GN":"224","GW":"245","GY":"595","HT":"509","HN":"504","HU":"36","IS":"354","IN":"91","ID":"62","IQ":"964","IE":"353","IL":"972","IT":"39","JM":"1","JP":"81","JO":"962","KZ":"77","KE":"254","KI":"686","KW":"965","KG":"996","LV":"371","LB":"961","LS":"266","LR":"231","LI":"423","LT":"370","LU":"352","MG":"261","MW":"265","MY":"60","MV":"960","ML":"223","MT":"356","MH":"692","MQ":"596","MR":"222","MU":"230","YT":"262","MX":"52","MC":"377","MN":"976","ME":"382","MS":"1","MA":"212","MM":"95","NA":"264","NR":"674","NP":"977","NL":"31","AN":"599","NC":"687","NZ":"64","NI":"505","NE":"227","NG":"234","NU":"683","NF":"672","MP":"1","NO":"47","OM":"968","PK":"92","PW":"680","PA":"507","PG":"675","PY":"595","PE":"51","PH":"63","PL":"48","PT":"351","PR":"1","QA":"974","RO":"40","RW":"250","WS":"685","SM":"378","SA":"966","SN":"221","RS":"381","SC":"248","SL":"232","SG":"65","SK":"421","SI":"386","SB":"677","ZA":"27","GS":"500","ES":"34","LK":"94","SD":"249","SR":"597","SZ":"268","SE":"46","CH":"41","TJ":"992","TH":"66","TG":"228","TK":"690","TO":"676","TT":"1","TN":"216","TR":"90","TM":"993","TC":"1","TV":"688","UG":"256","UA":"380","AE":"971","GB":"44","US":"1", "UY":"598","UZ":"998", "VU":"678", "WF":"681","YE":"967","ZM":"260","ZW":"263","BO":"591","BN":"673","CC":"61","CD":"243","CI":"225","FK":"500","GG":"44","VA":"379","HK":"852","IR":"98","IM":"44","JE":"44","KP":"850","KR":"82","LA":"856","LY":"218","MO":"853","MK":"389","FM":"691","MD":"373","MZ":"258","PS":"970","PN":"872","RE":"262","RU":"7","BL":"590","SH":"290","KN":"1","LC":"1","MF":"590","PM":"508","VC":"1","ST":"239","SO":"252","SJ":"47","SY":"963","TW":"886","TZ":"255","TL":"670","VE":"58","VN":"84","VG":"284","VI":"340"]
    
    
    let allKeys = countryDictionary.keys
    for key in allKeys
    {
        let combindStr = "\(key)(+\(countryDictionary[key]!))"
        countryArr.append(combindStr)
    }
    
    print(countryDictionary.count)
}


func getDayNameFromDate(dateStr:String) -> String {
    let formatter = DateFormatter()
    //formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "MM/dd/yyyy"
    let date = formatter.date(from: dateStr)
    formatter.dateFormat = "EEEE"
    let dayName = formatter.string(from: date!)
    return dayName
}

func getFormattedDateStr(dateStr:String) -> String
{
    let formatter = DateFormatter()
    //    formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let date = formatter.date(from: dateStr)
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "dd MMM,yyyy HH:mm:ss"
    
    let strdate = formatter.string(from: date!)
    return strdate
}

func convertOnlyDateFormat(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    
    if let date = dateFormatter.date(from: dateStr) {
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
    
        return dateFormatter.string(from: date)
    }
    return dateStr
}

func convertOnlyTimeFormat(dateStr:String) -> String?
{
    let formatter = DateFormatter()
    //    formatter.dateFormat = "dd/MM/yyyy"
    formatter.dateFormat = "HH:mm:ss"
//    formatter.timeZone = TimeZone(abbreviation: "GMT")
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//    let date = formatter.date(from: dateStr)
//    formatter.timeZone = TimeZone.current
//    formatter.dateFormat = "hh:mm aa"
    
//    let strdate = formatter.string(from: date!)
    
    if let date = formatter.date(from: dateStr) {
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "hh:mm aa"
    
        return formatter.string(from: date)
    }
    return dateStr
}

func convertJsonDataToSwiftyJSon(jsonData:Data?)->JSON?
{
    var  finalJson: JSON? = nil
    do
    {
        finalJson =   try JSON.init(data: jsonData!)
    }
    catch
    {}
    return finalJson
}
func convertDictionaryToJsonData(infoDict:NSDictionary)-> Data
{
    var jsonData: Data? = nil
    do
    {
        jsonData = try JSONSerialization.data(withJSONObject: infoDict as Any, options: .prettyPrinted)
    }
    catch
    {
    }
    return jsonData!
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

