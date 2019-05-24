//
//  ProfileVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit

class ProfileVc: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var TxtLocation: UITextField!
    
    var userCurrentLat = 0.0
    var userCurrentLong = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserImage.layer.cornerRadius = UserImage.frame.height/2
        TxtDob.isHidden = true
        TxtLocation.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postUserProfile()
    }
    
    func postUserProfile() {
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.userProfileDetail, jsonString: Request.setauthKey(authKey) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            print(sucess)
            if let userObj = sucess.value(forKey: "body") as? [String:Any] /*, let userObj = user_dict["User"] as? [String:Any]*/ {
                let fname = userObj["firstname"] as? String
                let lname = userObj["lastname"] as? String
                self.UserName.text = (fname ?? "") + " " + (lname ?? "")
                self.UserEmail.text = userObj["email"] as? String
                let photo = userObj["image"] as? String
                self.UserImage.sd_setImage(with: URL(string: photo ?? ""), placeholderImage: #imageLiteral(resourceName: "DefaultImage"))
                self.TxtAddress.text = userObj["address"] as? String
                self.TxtMobile.text = (userObj["phone"] as? String)
                self.TxtProfession.text = (userObj["Profession_name"] as? String)
                self.TxtSecondProfession.text = (userObj["secondary_profession"] as? String)
                
                self.TxtRenewalcycle.text = (userObj["renewal_cycle"] as? String)
                self.TxtSpecialInSecond.text = (userObj["secondary_profession_subspecialty"] as? String)
                
                self.TxtSpecialIn.text = (userObj["profession_subspecialty"] as? String)
                self.TxtNextREnewalData.text = (userObj["next_renewal_date"] as? String)
                self.TxtStateOflicensure.text = (userObj["license"] as? String)
                self.TxtLicenseNumber.text = (userObj["license_number"] as? String)
                if let addressKey = UserDefaults.standard.value(forKey: "useraddress") as? String {
                    self.TxtLocation.text = addressKey
                } else {
                    self.TxtLocation.text = ""
                }
            }
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
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
