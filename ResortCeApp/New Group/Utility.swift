//
//  UserPreferences.swift
//  Libertas
//
//  Created by Jatin Kumar on 9/11/17.
//  Copyright © 2017 Jatin Kumar. All rights reserved.
//

import Foundation
import UIKit

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

public func allValues< T: Hashable>(_:T.Type) -> Array<T> {
    var allValues = [T]()
    let iterator = iterateEnum(T.self)
    for item in iterator {
        allValues.append(item)
    }
    
    return allValues
}

public func < < T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

public func > < T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

public class Utility: NSObject {
    
    public class func validate(_ string: Any?) -> String {
        if let stringValue = string as? String {
            return stringValue
        }
        if let intValue = string as? Int {
            return "\(intValue)"
        }
        if let doubleValue = string as? Double {
            return "\(doubleValue)"
        }
        if let floatValue = string as? Float {
            return "\(floatValue)"
        }
        if let boolValue = string as? Bool {
            return boolValue == true ? "1" : "0"
        }
        return ""
    }
    public  class func dictvalidate(_ dict: AnyObject) -> NSDictionary {
          if let dictValue = dict as? NSDictionary{
            return dictValue
        }
        return [:]
    }

    class func indexPath(_ tableView: UITableView, _ button: UIButton) -> IndexPath {
        let buttonFrame: CGRect = button.convert(button.bounds, to: tableView)
        return tableView.indexPathForRow(at: buttonFrame.origin)!
    }
    
    
    
    
    
}
