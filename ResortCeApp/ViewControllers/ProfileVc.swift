//
//  ProfileVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit


class ProfileVc: UIViewController {
    
    @IBOutlet weak var TxtGender: UILabel!
    @IBOutlet weak var TxtMobile: UILabel!
    @IBOutlet weak var TxtAddress: UILabel!
    @IBOutlet weak var TxtDob: UILabel!
    @IBOutlet weak var TxtProfession: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserEmail: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var TxtSecondProfession: UITextField!
    @IBOutlet weak var TxtSpecialIn: UITextField!
    @IBOutlet weak var TxtSpecialInSecond: UITextField! //
    @IBOutlet weak var TxtStateOflicensure: UITextField!
    @IBOutlet weak var TxtLicenseNumber: UITextField!
    @IBOutlet weak var TxtNextREnewalData: UITextField!
    @IBOutlet weak var TxtRenewalcycle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserImage.layer.cornerRadius = UserImage.frame.height/2
        TxtDob.isHidden = true
 
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postUserProfile()
    }
    func postUserProfile() {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.userProfileDetail, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            print(sucess)
            let user_dict = sucess.value(forKey: "body") as! [String:Any]
            let fname = user_dict["firstname"]as! String
            let lname = user_dict["lastname"]as! String
            self.UserName.text = fname + " "  + lname
            self.UserEmail.text = user_dict["email"] as? String
            self.TxtAddress.text = user_dict["address"] as? String
            self.TxtMobile.text = (user_dict["phone"] as! String)
            self.TxtProfession.text = (user_dict["Profession_name"] as! String)
            
             self.TxtSecondProfession.text = (user_dict["secondary_profession"] as! String)
            
             self.TxtRenewalcycle.text = (user_dict["renewal_cycle"] as! String)
            self.TxtSpecialInSecond.text = (user_dict["secondary_profession_subspecialty"] as! String)
            
             self.TxtSpecialIn.text = (user_dict["profession_subspecialty"] as! String)
             self.TxtNextREnewalData.text = (user_dict["next_renewal_date"] as! String)
             self.TxtStateOflicensure.text = (user_dict["license"] as! String)
             self.TxtLicenseNumber.text = (user_dict["license_number"] as! String)
            
//            if UserDefaults.standard.value(forKey: "dob") == nil
//            {
//                self.TxtDob.text = ""
//                
//            }
//            else
//            {
//                self.TxtDob.text = (UserDefaults.standard.value(forKey: "dob")  as! String)
//            }
           
            
            let photo = user_dict["image"] as? String
            self.UserImage.sd_setImage(with: URL(string: photo!), placeholderImage: #imageLiteral(resourceName: "DefaultImage"))
            
     
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func ActnGoEditProfile(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVc") as? EditProfileVc
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}


