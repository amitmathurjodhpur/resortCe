//
//  HomeMenuVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//
import UIKit
class CellMenu: UITableViewCell
{
    @IBOutlet weak var MenuIconImgVw: UIImageView!
    @IBOutlet weak var LblMenuName: UILabel!
    @IBOutlet weak var NotifyImg: UILabel!
}
class HomeMenuVc: UIViewController {
    @IBOutlet weak var TableVw: UITableView!
    var MenuArray : [String] = ["Home","Settings","My Account","My lectures","Notification","My Pdf","Log Out"]
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "MyAccount"),#imageLiteral(resourceName: "mylect"),#imageLiteral(resourceName: "NotificationBell"),#imageLiteral(resourceName: "edit"),#imageLiteral(resourceName: "Logout")]
    @IBOutlet weak var Userimage: UIImageView!
    var TotalCredits = ""
    var TotalNotifications = ""
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Userimage.layer.cornerRadius = Userimage.frame.height/2
      //  self.PostTotalCredits()
        //self.PostTotalNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userprofile()
        //self.PostTotalCredits()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userprofile() {
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            print("authkey: \(authKey)")
            print(API.userProfileDetail)
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.userProfileDetail, jsonString: Request.setauthKey(authKey) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let user_dict = sucess.value(forKey: "body") as? [String:Any], let userObj = user_dict["User"] as? [String:Any] {
                    let fname = userObj["firstname"] as? String
                    let lname = userObj["lastname"] as? String
                    self.username.text = (fname ?? "") + " " + (lname ?? "")
                    self.userEmail.text = userObj["email"] as? String
                    let photo = userObj["image"] as? String
                    self.Userimage.sd_setImage(with: URL(string: photo ?? ""), placeholderImage: #imageLiteral(resourceName: "DefaultImage"))
                }
               
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostTotalCredits()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.total_credits, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
             let Body = sucess["body"] as! [String:Any]
            self.TotalCredits = String(Body["total_credit"] as! Int)
            self.TableVw.reloadData()
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func PostTotalNotification()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.total_notifications, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            let Body = sucess["body"] as! [String:Any]
            self.TotalNotifications = String(Body["total_notification"] as! Int)
            self.TableVw.reloadData()
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func postLogout() {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.logout, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            UserDefaults.standard.set("0", forKey: "auth_key")
            UserDefaults.standard.set("0", forKey: AppKey.LoginStatus)
            User.iswhichUser = "0"
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            UIApplication.shared.keyWindow?.rootViewController = navigationController
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    @IBAction func ActnCrossBtn(_ sender: Any)
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
}
extension HomeMenuVc : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MenuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMenu") as? CellMenu
        
       if indexPath.row == 4
        {
            cell?.MenuIconImgVw.image = imageArray[indexPath.row]
            cell?.LblMenuName.text = MenuArray[indexPath.row]
            cell?.NotifyImg.layer.cornerRadius = (cell?.NotifyImg.frame.height)!/2
            cell?.NotifyImg.isHidden = false
            cell?.NotifyImg.text = TotalNotifications
            return cell!
        }
        else{
        cell?.MenuIconImgVw.image = imageArray[indexPath.row]
        cell?.LblMenuName.text = MenuArray[indexPath.row]
        cell?.NotifyImg.isHidden = true
        return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {

            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        }
        if indexPath.row == 1
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SettingVc") as? SettingVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.row == 2
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVc") as? ProfileVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.row == 3
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyLecturesVc") as? MyLecturesVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        if indexPath.row == 4
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVc") as? NotificationVc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.row == 5
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DocumentsVC") as? DocumentsVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.row == 6
        {
            UserDefaults.standard.set("0", forKey: "auth_key")
            UserDefaults.standard.set("0", forKey: AppKey.LoginStatus)
            User.iswhichUser = "0"
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            UIApplication.shared.keyWindow?.rootViewController = navigationController
            postLogout()
        }
    }
}
