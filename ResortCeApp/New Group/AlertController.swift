//
//  AlertController.swift
//  Libertas
//
//  Created by Jatin Kumar on 5/15/17.
//  Copyright © 2017 Jatin Kumar. All rights reserved.
//

import UIKit

typealias ActionHandler  = (_ title: String) -> Void
typealias FieldActionHandler = (_ title: String,_ fieldText: String) -> Void

extension UIAlertController {
    
    //MARK:  Show Toast
   class func showToast(_ sender: UIViewController, message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 20, y: sender.view.frame.size.width/2-100, width: sender.view.frame.size.width-40, height: 60))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.bringSubview(toFront: sender.view)
        sender.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    //MARK:  Show Message
    class func show(_ sender: UIViewController, _ title : String?, _ message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: KOk, style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    //MARK:  Show Message with Multiple Options
    class func showWithAction(_ sender: UIViewController, _ title: String?, _ message: String?, _ cancelTitle: String? = nil, _ destructiveOptions: [String]? = nil, _ otherOptions: [String]? = nil, _ isAlert: Bool = true, _ completion: @escaping ActionHandler) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: isAlert ? .alert : .actionSheet)
        
        if let cancel =  cancelTitle {
            alertController.addAction(UIAlertAction(title: cancel, style: .cancel, handler: {
                (action : UIAlertAction) -> Void in
                completion(action.title!)
            }))
        }
        if let distructive = destructiveOptions, distructive.count > 0 {
            for title in distructive {
                alertController.addAction(UIAlertAction(title: title, style: .destructive, handler: {
                    (action : UIAlertAction) -> Void in
                    completion(action.title!)
                }))
            }
        }
        if let others = otherOptions, others.count > 0 {
            for title in others {
                alertController.addAction(UIAlertAction(title: title, style: .default, handler: {
                    (action : UIAlertAction) -> Void in
                    completion(action.title!)
                }))
            }
        }
        
        DispatchQueue.main.async {
            if !isAlert && UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                alertController.popoverPresentationController?.sourceRect = self.sourceRectForBottomAlertController(alertController)();
                alertController.popoverPresentationController!.sourceView = sender.view;
                sender.present(alertController, animated: true, completion: nil)
            }
            else {
                sender.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

    
    //MARK:  Private Methods
    private func sourceRectForBottomAlertController() -> CGRect {
        var sourceRect :CGRect = CGRect.zero
        sourceRect.origin.x = self.view.bounds.midX - self.view.frame.origin.x/2.0
        sourceRect.origin.y = self.view.bounds.midY
        return sourceRect
    }
}
