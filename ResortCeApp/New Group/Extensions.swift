//
//  Extensions.swift
//  Amazon
//
//  Created by AJ on 15/09/17.
//  Copyright © 2017 AJ. All rights reserved.
//

import Foundation
import UIKit
extension NSLayoutConstraint
{
    func IPhoneXNavHight(NavigationHight:NSLayoutConstraint)
    {if(IdentifyIphone() == iPhoneX)
    {
        NavigationHight.constant = 100.0
        }
        
    }
    
}
let iPhone5 = true
let iPhone6 = true
let iPhone7nd8 = true
let iPhoneX = true
let iPhoneUnkn = true
func IdentifyIphone() -> Bool{
    
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return false
        //print("iPhone 5 or 5S or 5C")
        case 1334:
            return false
        // print("iPhone 6/6S/7/8")
        case 1920, 2208:
            return false
        //  print("iPhone 6+/6S+/7+/8+")
        case 2436:
            return iPhoneX
        //  print("iPhone X")
        default:
            return false
            // print("unknown")
        }
    }
    return false
}
extension UIViewController
{
    func isValidEmail(testStr:String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidPhnNo(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImageOrientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(transform)
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
}

extension UILabel{
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
extension UIView {
    
    @IBInspectable var borWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var corRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UITextField {
    
    func setBottomBorder() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor(red: 239/255, green: 238/255, blue: 241/255, alpha: 1.0).cgColor
        layer.addSublayer(bottomBorder)
        
        // self.borderStyle = .none
        // self.layer.backgroundColor = UIColor.white.cgColor
        // self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.gray.cgColor
        // self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        // self.layer.shadowOpacity = 1.0
        // self.layer.shadowRadius = 0.0
    }
    
    func setWithTextBottomBorder() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor(red: 247/255, green: 227/255, blue: 248/255, alpha: 1.0).cgColor
        layer.addSublayer(bottomBorder)
        
        // self.borderStyle = .none
        // self.layer.backgroundColor = UIColor.white.cgColor
        // self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.gray.cgColor
        // self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        // self.layer.shadowOpacity = 1.0
        // self.layer.shadowRadius = 0.0
    }
    
    func setColorBottomBorder() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor(red: 288/255, green: 181/255, blue: 199/255, alpha: 1.0).cgColor
        layer.addSublayer(bottomBorder)
        
        // self.borderStyle = .none
        // self.layer.backgroundColor = UIColor.white.cgColor
        // self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.gray.cgColor
        // self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        // self.layer.shadowOpacity = 1.0
        // self.layer.shadowRadius = 0.0
    }
    
    //    @IBInspectable var placeHolderColor: UIColor? {
    //        get {
    //            return self.placeHolderColor
    //        }
    //        set {
    //            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.: newValue!])
    //        }
    //    }
    
    @IBInspectable var borderWid: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderCol: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadi: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}

extension UIButton {
    
    @IBInspectable var cornerRadi: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWid: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderCol: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


extension UILabel {
    
    @IBInspectable var cornerRadi: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWid: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderCol: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}



extension UITextView {
    
    @IBInspectable var cornerRadi: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWid: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderCol: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension String{
     func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}


