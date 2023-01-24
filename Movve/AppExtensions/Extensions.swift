//
//  Extensions.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 19.12.2022.
//

import UIKit

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

extension DateFormatter {
    static let dateFormatterGet: DateFormatter = {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        return dateFormatterGet
    }()
    
    static var dateFormatterPrint: DateFormatter = {
        let dateFormatterPrint = DateFormatter()
        return dateFormatterPrint
    }()
    
    static func switchDateFormat(from dateStr: String) -> String {
        DateFormatter.dateFormatterPrint.dateFormat = "MMM d, yyyy"
        
        if let date = DateFormatter.dateFormatterGet.date(from: dateStr) {
            return DateFormatter.dateFormatterPrint.string(from: date)
        } else {
            return dateStr
        }
    }
    
    static func showOnlyYear(from dateStr: String) -> String {
        DateFormatter.dateFormatterPrint.dateFormat = "yyyy"
        
        if let date = DateFormatter.dateFormatterGet.date(from: dateStr) {
            return DateFormatter.dateFormatterPrint.string(from: date)
        } else {
            return dateStr
        }
    }
}

extension UINavigationController {
    func transitionType() -> TransitionType {
        if let delegate = self.delegate as? NavigationControllerDelegate {
            return delegate.transitionType
        }
        return .standard
    }
    
    func setTransitionType(transitionType: TransitionType) {
        if let delegate = self.delegate as? NavigationControllerDelegate {
            delegate.transitionType = transitionType
        }
    }
}

