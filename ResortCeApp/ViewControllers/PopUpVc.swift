//
//  PopUpVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit

class PopUpVc: UIViewController {
    var completedId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func ActnNextBtn(_ sender: Any)
    {
        // completed cousre id can be sent here if push is on lockerVc
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeVc {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
      
    }
    @IBAction func ActnCancelBtn(_ sender: Any)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeVc {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
        
        
//        UIView.animate(withDuration: 0.0, animations: { () -> Void in
//            self.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
//            self.view.layoutIfNeeded()
//            self.view.backgroundColor = UIColor.clear
//        }, completion: { (finished) -> Void in
//            self.view.removeFromSuperview()
//            self.removeFromParentViewController()
//        })
        
        
    }
        
    


}
