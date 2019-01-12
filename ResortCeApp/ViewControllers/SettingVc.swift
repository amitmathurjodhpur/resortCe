//
//  SettingVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import SafariServices
import Social
import FBSDKShareKit
import FacebookShare



class CellSetting: UITableViewCell
{
    @IBOutlet weak var MenuIconImgVw: UIImageView!
    
    @IBOutlet weak var LblMenuName: UILabel!
    @IBOutlet weak var NotifyImg: UIImageView!
}


class SettingVc: UIViewController,SFSafariViewControllerDelegate {
    var MenuArray : [String] = ["Connect to Facebook","Connect to Twitter","Connect to Instagram"]
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "facebook"),#imageLiteral(resourceName: "twitter"),#imageLiteral(resourceName: "instagram")]

    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserEmail: UILabel!
   
    @IBOutlet weak var UserImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postUserProfile()
        UserImage.layer.cornerRadius = UserImage.frame.height/2
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
            self.UserName.text = fname + lname
            self.UserEmail.text = user_dict["email"] as? String
            let photo = user_dict["image"] as? String
            self.UserImage.sd_setImage(with: URL(string: photo!), placeholderImage: #imageLiteral(resourceName: "DefaultImage"))
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
        
    }
    
     func BtnShareOnFB()
    {
        // import SafariServices   and  Use (SFSafariViewControllerDelegate)
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.add(URL(string: "http:www.ResortCe.com"))
        vc?.setInitialText("ResortCe")
        self.present(vc!, animated: true, completion: nil)
    }
    
     func BtnShareOnTwitter()
    {
        let tweetText = "ResortCe"
        let tweetUrl = "http:www.ResortCe.com"
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        // cast to an url
        let url = URL(string: escapedShareString)
        // open in safari
        UIApplication.shared.openURL(url!)
    }
    func shareOnInstagram()
    {
        let instagramHooks = "instagram://user?username=johndoe"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
        
    }
    func Share()
    {
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ActnGoProfile(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVc") as? ProfileVc
       
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
extension SettingVc : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSetting") as? CellSetting
        cell?.MenuIconImgVw.image = imageArray[indexPath.row]
        cell?.LblMenuName.text = MenuArray[indexPath.row]
        return cell!
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            self.BtnShareOnFB()
        }
        if indexPath.row == 1
        {
            self.BtnShareOnTwitter()
        }
        if indexPath.row == 2
        {
           self.shareOnInstagram()

        }
        
    }
    
}
