//
//  placeholder.swift
//  GOT_TASTE
//
//  Created by ios-keshav-6 on 12/12/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

import Foundation
import UIKit
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension  UITextField{
    
   
    
    func  setPlaceHolder() {
    
        self.attributedPlaceholder = NSAttributedString(string: (self.placeholder )!,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    func AddPadding()
    {
       
        
     
    }
    
    
}

extension  UIView{
    
    
    
    func  setViewBorder() {
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
        self.clipsToBounds      = true
    }
    func  setButtonCorner() {
        
       
        
        self.layer.cornerRadius = 3.0
        self.clipsToBounds      = true
    }
    
    
    
}

