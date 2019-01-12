//
//  navigateVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 21/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit

class navigateVc: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if  (UserDefaults.standard.value(forKey: AppKey.LoginStatus) as? String  == "1")
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVc") as? HomeVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }

        // Do any additional setup after loading the view.
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
