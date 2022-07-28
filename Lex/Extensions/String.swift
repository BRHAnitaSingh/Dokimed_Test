//
//  String.swift
//  Lex
//
//  Created by ChawTech Solutions on 07/03/22.
//

import Foundation
import UIKit

extension String{
    
    func localized() -> String{
        return NSLocalizedString(self, comment: "")
    }
    
    func numberOfDaysInBetween(_ strtDate: String) -> String {
        let startDate = strtDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let formatedStartDate = dateFormatter.date(from: startDate)
        
        let currentDate = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let formatedCurrentDate = dateFormatter.date(from: currentDate.string(format: "yyyy-MM-dd"))
//            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let components = Set<Calendar.Component>([.day])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedCurrentDate!, to: formatedStartDate!)

//        print (differenceOfDate)
        print(differenceOfDate.day!)
        return "\(differenceOfDate.day!)"
    }
    
}

extension UIAlertController {
    class func showInfoAlertWithTitle(_ title: String?, message: String?, buttonTitle: String, viewController: UIViewController? = nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction.init(title: buttonTitle, style: .default, handler: { (okayAction) in
                if viewController != nil {
                    // viewController?.dismiss(animated: true, completion: nil)
                    viewController?.navigationController?.popViewController(animated: true)
                }
                else {
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(okayAction)
            if viewController != nil {
                viewController?.present(alertController, animated: true, completion: nil)
            }
            else {
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

extension UIView {

    func takeNewScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
