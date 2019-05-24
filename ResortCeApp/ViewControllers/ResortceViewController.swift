//
//  ResortceViewController.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 1/13/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit

class ResortceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var groupArr: [GroupLecture] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
        self.title = "Resortce Concierge"
        self.getNearByGroups()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "resortcecell") {
            if indexPath.row == 0 {
               cell.textLabel?.text = "Find CE Courses"
               cell.imageView?.image = UIImage(named: "findCE")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Track Trip Expenses"
                cell.imageView?.image = UIImage(named: "expense")
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "In progress courses"
                cell.imageView?.image = UIImage(named: "LectProgIcon")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0, self.groupArr.count > 0 {
            /*let vc = storyboard?.instantiateViewController(withIdentifier: "FindLocationVc") as? FindLocationVc
            self.navigationController?.pushViewController(vc!, animated: true)
            let vc = storyboard?.instantiateViewController(withIdentifier: "hotellistvc") as? HotelListViewController
            self.navigationController?.pushViewController(vc!, animated: true) */
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LecturesAvailableVc") as? LecturesAvailableVc {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let hotelObj = appDelegate.currentHotel {
                    let dataDictHotel: [String:Any] = ["HotelId":hotelObj.hotelId,"HotelName": hotelObj.hotelName,"HotelAddress":hotelObj.hotelName,"HotelLatitude": hotelObj.hotelLat ,"HotelLongitude":hotelObj.hotelLong, "HotelPhone": hotelObj.hotelPhoneNo, "HotelWebsite": hotelObj.hotelWebsite]
                    vc.GethotelDict = dataDictHotel
                    vc.getGroupId = self.groupArr[indexPath.row].groupId
                    vc.shouldShowBuyBtn = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else  if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            vc?.shouldShowTrips = false
            self.navigationController?.pushViewController(vc!, animated: true)
        } else  if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            vc?.shouldShowTrips = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func getNearByGroups() {
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            DataManager.postAPIWithParameters(urlString: API.getnearbygroups, jsonString: Request.GetNearGroups(authKey, appDelegate.currentHotel?.hotelLat ?? "0.0", appDelegate.currentHotel?.hotelLong ?? "0.0", "1000") as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let groups = sucess["body"] as? [[String:Any]], groups.count > 0 {
                    for groupObj in groups {
                        if let course = groupObj as Dictionary<String, AnyObject>?, let groupId = course["id"] as? String, let groupName = course["name"] as? String, let groupAddress = course["address"] as? String, let dt = course["date"] as? String, let groupLat = course["latitude"] as? String, let groupLong = course["longitude"] as? String, let groupImage = course["image"] as? String, let groupDesc = course["description"] as? String {
                            let course = GroupLecture.init(groupId: groupId, groupName: groupName, groupAddress: groupAddress, groupLat: groupLat, groupLong: groupLong, groupDate: dt, groupImage: groupImage, groupDesc: groupDesc)
                            self.groupArr.append(course)
                        }
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
