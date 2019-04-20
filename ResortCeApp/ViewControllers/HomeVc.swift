//
//  HomeVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import CoreLocation

class CellHome: UITableViewCell
{
    @IBOutlet weak var LblDetailsType: UILabel!
    @IBOutlet weak var ImgVwIcon: UIImageView!
}

class HomeVc: UIViewController, NewUserDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
//    var MenuArray : [String] = ["Find Lectures","Lectures In Progress","Locker"]
//    var imageArray : [UIImage] = [#imageLiteral(resourceName: "FindLecturesIcon"),#imageLiteral(resourceName: "LectProgIcon"),#imageLiteral(resourceName: "LockerIcon")]
    
    var MenuArray : [String] = []
    var imageArray : [UIImage] = []
    var locationManager = CLLocationManager()
    var userCurrentLat = 0.0
    var userCurrentLong = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.userprofile()
        }
        
      }
    
    func getHotelsNearBy() {
         if let userId = UserDefaults.standard.value(forKey: "userid") as? String {
            //let dic = ["user_id": userId ,"current_lat": userCurrentLat.toString(), "current_long": userCurrentLong.toString(), "onlycount": "1"]
             let dic = ["user_id": "255" ,"current_lat": "12.932979", "current_long": "77.612367", "onlycount": "1"]
            ActivityIndicator.shared.show(self.view)
            //API.getHotels
            DataManager.postAPIWithParameters(urlString:API.getHotels, jsonString: dic as [String : AnyObject], success: { [weak self] sucess in
                ActivityIndicator.shared.hide()
                print("Hotels near by: \n \(sucess)")
                if let count = sucess.value(forKey: "count") as? Int {
                    if count > 0 {
                        self?.MenuArray.append("Resortce Concierge")
                        self?.MenuArray.append("Plan A Trip")
                        self?.MenuArray.append("Trip Tacker")
                        self?.MenuArray.append("CE Tracker")
                       
                        self?.imageArray.append(#imageLiteral(resourceName: "Resortceicon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "tripicon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "trackerIcon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "CEtracker"))
                    } else {
                        //self?.MenuArray.append("Resortce Concierge")
                        self?.MenuArray.append("Plan A Trip")
                        self?.MenuArray.append("Trip Tacker")
                        self?.MenuArray.append("CE Tracker")
                        
                       // self?.imageArray.append(#imageLiteral(resourceName: "Resortceicon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "tripicon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "trackerIcon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "CEtracker"))
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
                }, failure: {
                    fail in
                    ActivityIndicator.shared.hide()
            })
        }
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
        MenuArray.append("Trip Tacker")
        MenuArray.append("CE Tracker")
        
        imageArray.append(#imageLiteral(resourceName: "trackerIcon"))
        imageArray.append(#imageLiteral(resourceName: "CEtracker"))
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
    
    @IBAction func ActnBack(_ sender: Any) {
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
                        /*self?.MenuArray.append("Plan A Trip")
                        self?.MenuArray.append("Trip Tacker")
                        self?.MenuArray.append("CE Tracker")
                        self?.MenuArray.append("Resortce Concierge")
                        
                        self?.imageArray.append(#imageLiteral(resourceName: "tripicon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "trackerIcon"))
                        self?.imageArray.append(#imageLiteral(resourceName: "CEtracker"))
                        self?.imageArray.append(#imageLiteral(resourceName: "Resortceicon"))
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }*/
                        self?.getHotelsNearBy()
                    }
                    print("User Completed \(isUserProfileCompleted)")
                }
                }, failure: {
                    fail in
                    ActivityIndicator.shared.hide()
            })
        }
    }
    
//    func configureHotelData() {
//        if let count = sucess.value(forKey: "count") as? Int {
//            if count > 0 {
//            }
//        }
//    }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "FindLocationVc") as? FindLocationVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else  if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LecturesInProgressVc") as? LecturesInProgressVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LockerVc") as? LockerVc
            self.navigationController?.pushViewController(vc!, animated: true)
        } else*/
        if MenuArray.count == 4 {
            if indexPath.row == 1 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "plantripvc") as? PlanTripViewController
                vc?.isEditMode = false
                self.navigationController?.pushViewController(vc!, animated: true)
               /* let vc = storyboard?.instantiateViewController(withIdentifier: "LecturesInProgressVc") as? LecturesInProgressVc
                self.navigationController?.pushViewController(vc!, animated: true)*/
            }  else if indexPath.row == 2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
                vc?.shouldShowCurrent = true
                vc?.showTripsOnly = false
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 3 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
                vc?.shouldShowCurrent = false
                vc?.showTripsOnly = false
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "resortcevc") as? ResortceViewController
                self.navigationController?.pushViewController(vc!, animated: true)
//                let vc = storyboard?.instantiateViewController(withIdentifier: "FindLocationVc") as? FindLocationVc
//                self.navigationController?.pushViewController(vc!, animated: true)
            }
        } else  if MenuArray.count == 3 {
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "plantripvc") as? PlanTripViewController
                vc?.isEditMode = false
                self.navigationController?.pushViewController(vc!, animated: true)
            }  else if indexPath.row == 1 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
                vc?.shouldShowCurrent = true
                vc?.showTripsOnly = false
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
                vc?.shouldShowCurrent = false
                vc?.showTripsOnly = false
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
    }
    
    //MARK: - Location Manager
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                break
            case .authorizedAlways, .authorizedWhenInUse:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let location = manager.location?.coordinate
        userCurrentLat = (location?.latitude) ?? 0.0
        userCurrentLong = (location?.longitude) ?? 0.0
        //userCurrentLocation = locationManager.location!.coordinate
        locationManager.stopUpdatingLocation()
    }
}
