//
//  ViewController.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import Alamofire
import GoogleSignIn
import Toaster

class LoginVc : UIViewController,GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var loginIdTxt: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    var DeviceToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
    }
    
    func configure() {
        if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String  {
            self.DeviceToken = deviceToken
        } else {
            self.DeviceToken = ""
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadviewfornotifications), name: NSNotification.Name(rawValue: "styleUser1"), object: nil)
        loginIdTxt.setLeftPaddingPoints(10)
        passwordTxtField.setLeftPaddingPoints(10)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc func loadviewfornotifications(_ notification: Notification)
    {
        let ve = storyboard?.instantiateViewController(withIdentifier: "NotificationVc") as? NotificationVc
        navigationController?.pushViewController(ve ?? UIViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
         if  (UserDefaults.standard.value(forKey: AppKey.LoginStatus) as? String  == "1")
         {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc") as? HomeVc
            self.navigationController?.pushViewController(vc!, animated: true)
         }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
    if let error = error {
    print("\(error.localizedDescription)")
    } else {
    // Perform any operations on signed in user here.
    let userId = user.userID                  // For client-side use only!
    let idToken = user.authentication.idToken // Safe to send to the server
    let fullName = user.profile.name
       
        let fullNameArr = fullName?.components(separatedBy: " ")
        let fname    = fullNameArr![0]
        let lname = fullNameArr![1]
    
    
    let givenName = user.profile.givenName
    let familyName = user.profile.familyName
    let email = user.profile.email
    // ...
        let dic = ["social_id": userId ,"social_type" : "2","email":email ,"firstname":fname, "lastname" : lname ,"device_type":"1","device_token":DeviceToken]
        DataManager.postAPIWithParameters(urlString: API.socialLogin , jsonString: dic as [String : AnyObject], success: {
            success in
            print(success)
            let dict_sucess = success.value(forKey: "body") as! [String :Any]
            let auth_key =  dict_sucess["authorization_key"] as! String
            UserDefaults.standard.set(auth_key, forKey: "auth_key")
            if let userId = dict_sucess["uid"] as? String  {
                 UserDefaults.standard.set(userId, forKey: "userid")
            }
            print(dict_sucess)
            print(auth_key)
            
//
//            let dict = ["image":values!["image"]as! String ,"email":values!["email"]as! String,"name":values!["firstname"]as! String,"authKey":values!["authorization_key"]as! String ,"id": values!["id"] as! String]
//
//
//            UserDefaults.standard.setValue(dict, forKey: "userInfo")
            UserDefaults.standard.setValue(auth_key, forKey: "authKey")
            UserDefaults.standard.set("1", forKey: AppKey.LoginStatus )
             User.iswhichUser = "1"
            UserDefaults.standard.set("1", forKey: "First")
             UserDefaults.standard.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc") as? HomeVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }, failure: {
    failure in
    print(failure)
    })
    }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBAction func ActnconnctFB(_ sender: Any)
    {
        appDelegate.loginStr = "FACEBOOK"
         if (NetworkReachabilityManager()?.isReachable)!
         {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self)
        { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        let fbAccessToken = FBSDKAccessToken.current().tokenString
                        print(fbAccessToken ?? "")
                        //UserProfile.current.accessToken = fbAccessToken
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                    else {
                        Utilities.hideProgressView(view: self.view)
                        Utilities.alertView(controller: self, title: "Try Again", msg: "Please try again")
                    }
                }
                else {
                    Utilities.hideProgressView(view: self.view)
                }
            }
            else {
                Utilities.hideProgressView(view: self.view)
            }
        }
        }
        else
         {
            Toast(text: "No Internet Connection").show()
        }
      
    }
    // MARK:- Get FB User Data
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                   
                    if dict["id"] != nil{
                        let id = dict["id"] as? String
                        let email = dict["email"] as? String
                        _ = dict["name"] as? String
                        let fname = dict["first_name"] as? String
                        let lname =  dict ["last_name"] as? String
                        _ = dict["picture.type(large)"]
                        let dic = ["social_id": id ?? "" ,"social_type" : "1","email":email ?? "" ,"firstname":fname ?? "", "lastname" :lname ?? "","device_type":"1","device_token":self.DeviceToken]
                        DataManager.postAPIWithParameters(urlString: API.socialLogin , jsonString: dic as [String : AnyObject], success: {
                            success in
                            let dict_sucess = success.value(forKey: "body") as! [String :Any]
                            let auth_key =  dict_sucess["authorization_key"] as! String
                            UserDefaults.standard.set(auth_key, forKey: "auth_key")
                            if let userId = dict_sucess["uid"] as? String  {
                                UserDefaults.standard.set(userId, forKey: "userid")
                            }
                            print(dict_sucess)
                            print(auth_key)
                            
                            //
                            //            let dict = ["image":values!["image"]as! String ,"email":values!["email"]as! String,"name":values!["firstname"]as! String,"authKey":values!["authorization_key"]as! String ,"id": values!["id"] as! String]
                            //
                            //
                            //            UserDefaults.standard.setValue(dict, forKey: "userInfo")
                            UserDefaults.standard.setValue(auth_key, forKey: "authKey")
                            UserDefaults.standard.set("1", forKey: AppKey.LoginStatus )
                             User.iswhichUser = "1"
                             UserDefaults.standard.set("1", forKey: "First")
                           UserDefaults.standard.synchronize()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc") as? HomeVc
                                    self.navigationController?.pushViewController(vc!, animated: true)
                        }, failure: {
                            failure in
                            print(failure)
                        })
                    }
                }
            })
        }
    }

    @IBAction func ActnGoogleBtn(_ sender: Any)
    {
         if (NetworkReachabilityManager()?.isReachable)!
        {
        GIDSignIn.sharedInstance().signOut()
        appDelegate.loginStr = "GOOGLEPLUS"
        GIDSignIn.sharedInstance().signIn()
        }
        else
        {
            Toast(text: "No Internet Connection").show()
        }
    }
}

extension LoginVc {
    @IBAction func LoginAction(_ sender: Any) {
        if let loginTxt = loginIdTxt.text, loginTxt.isEmptyOrWhitespace() {
            UIAlertController.show(self, "Error", "Email is mandatory")
            return
        } else if let passwordTxtField = passwordTxtField.text, passwordTxtField.isEmptyOrWhitespace() {
            UIAlertController.show(self, "Error", "Password is incorrect")
            return
        } else if let loginTxt = loginIdTxt.text, !isValidEmail(testStr: loginTxt) {
            UIAlertController.show(self, "Error", "Invalid Email Id.")
            return
        } else {
            self.view.endEditing(true)
            ActivityIndicator.shared.show(self.view)
            let dic = ["email":loginIdTxt.text ,"password":passwordTxtField.text]
            DataManager.postAPIWithParameters(urlString: API.logIn , jsonString: dic as [String : AnyObject], success: {
                success in
                print(success)
                if let responseArr = success as? [Dictionary<String, AnyObject>], responseArr.count > 0, let response = responseArr.first {
                    print(response)
                    ActivityIndicator.shared.hide()
                    // Authorisation User
                    if let auth_Token = response["auth"] as? Bool, auth_Token {
                        if let Token = response["token"] as? Int, let userId = response["uid"] as? String  {
                            let myToken = String(Token)
                            UserDefaults.standard.set(myToken, forKey: "authKey")
                            UserDefaults.standard.set(userId, forKey: "userid")
                            UserDefaults.standard.set("1", forKey: AppKey.LoginStatus )
                            User.iswhichUser = "1"
                            UserDefaults.standard.set("1", forKey: "First")
                            UserDefaults.standard.synchronize()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc") as? HomeVc
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Invalid Authorization", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                        self.present(alert, animated: true, completion: {[weak self] in
                            self?.loginIdTxt.text = ""
                            self?.passwordTxtField.text = ""
                        })
                        return
                    }
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })
        }
       
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signupvc") as? SignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
