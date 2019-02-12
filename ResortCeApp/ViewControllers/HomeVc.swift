//
//  HomeVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellHome: UITableViewCell
{
    @IBOutlet weak var LblDetailsType: UILabel!
    @IBOutlet weak var ImgVwIcon: UIImageView!
}

class HomeVc: UIViewController, NewUserDelegate {
    @IBOutlet weak var tableView: UITableView!
    
//    var MenuArray : [String] = ["Find Lectures","Lectures In Progress","Locker"]
//    var imageArray : [UIImage] = [#imageLiteral(resourceName: "FindLecturesIcon"),#imageLiteral(resourceName: "LectProgIcon"),#imageLiteral(resourceName: "LockerIcon")]
    
    var MenuArray : [String] = []
    var imageArray : [UIImage] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        userprofile()
        /*self.MenuArray.append("Plan A Trip")
        self.MenuArray.append("Trip Tacker")
        self.MenuArray.append("CE Tracker")
        self.MenuArray.append("Resortce Concierge")
        
        self.imageArray.append(#imageLiteral(resourceName: "tripicon"))
        self.imageArray.append(#imageLiteral(resourceName: "trackerIcon"))
        self.imageArray.append(#imageLiteral(resourceName: "CEtracker"))
        self.imageArray.append(#imageLiteral(resourceName: "Resortceicon"))
        self.tableView.reloadData()*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
   func OkAction(action: UIAlertAction) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVc") as? EditProfileVc
    vc?.newUserDelegate = self
    self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func newUserCompleted() {
       MenuArray.append("Plan A Trip")
       imageArray.append(#imageLiteral(resourceName: "tripicon"))
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ActnMenuOpen(_ sender: Any)
    {
        let menuVC : HomeMenuVc = self.storyboard!.instantiateViewController(withIdentifier: "HomeMenuVc") as! HomeMenuVc
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func userprofile() {
         if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.userProfileDetail, jsonString: Request.setauthKey(authKey) as [String : AnyObject], success: { [weak self]
                sucess in
                ActivityIndicator.shared.hide()
                if let user_dict = sucess.value(forKey: "body") as? [String:Any] {
                    var isUserProfileCompleted = true
                    
                    if let user_Profession = user_dict["Profession_name"] as? String, user_Profession.isEmpty {
                        isUserProfileCompleted = false
                    }
                    if let user_firstName = user_dict["firstname"] as? String, user_firstName.isEmpty {
                        isUserProfileCompleted = false
                    }
                    if let user_address = user_dict["address"] as? String, user_address.isEmpty {
                        isUserProfileCompleted = false
                    }
                    if let user_phone = user_dict["phone"] as? String, user_phone.isEmpty {
                        isUserProfileCompleted = false
                    }
                    if let user_email = user_dict["email"] as? String, user_email.isEmpty {
                        isUserProfileCompleted = false
                    }
                    if UserDefaults.standard.value(forKey: "First") as? String == "1" && !isUserProfileCompleted {
                        let alert = UIAlertController(title: "MESSAGE", message: "COMPLETE PROFILE FIRST", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:self?.OkAction))
                        self?.present(alert, animated: true, completion: nil)
                    } else {
                        self?.MenuArray.append("Plan A Trip")
                        self?.MenuArray.append("Trip Tacker")
                        self?.MenuArray.append("CE Tracker")
                        self?.MenuArray.append("Resortce Concierge")
                        
                        self?.imageArray.append(#imageLiteral(resourceName: "tripicon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "trackerIcon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "CEtracker"))
                        self?.imageArray.append(#imageLiteral(resourceName: "Resortceicon"))
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                    print("User Completed \(isUserProfileCompleted)")
                }
                }, failure: {
                    fail in
                    ActivityIndicator.shared.hide()
            })
        }
       
    }
}

extension HomeVc : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MenuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHome") as? CellHome
        cell?.ImgVwIcon.image = imageArray[indexPath.row]
        cell?.LblDetailsType.text = MenuArray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       /* if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "FindLocationVc") as? FindLocationVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else  if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LecturesInProgressVc") as? LecturesInProgressVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else*/ if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "plantripvc") as? PlanTripViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }  else if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
            vc?.shouldShowCurrent = true
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
            vc?.shouldShowCurrent = false
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "resortcevc") as? ResortceViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
