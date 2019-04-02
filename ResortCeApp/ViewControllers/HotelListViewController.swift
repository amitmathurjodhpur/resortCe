//
//  HotelListViewController.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 2/24/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit
import CoreLocation

class HotelListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var courseTableView: UITableView!
    var hotelsArr: [Hotel] = []
    var userCurrentLat = 0.0
    var userCurrentLong = 0.0
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
         self.title = "Resortcee"
        getCurrentLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getHotelsNearBy()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
    func getHotelsNearBy() {
        if let userId = UserDefaults.standard.value(forKey: "userid") as? String {
            //let dic = ["user_id": userId ,"current_lat": userCurrentLat.toString(), "current_long": userCurrentLong.toString(), "onlycount": "0"]
            let dic = ["user_id": "255" ,"current_lat": "12.932979", "current_long": "77.612367", "onlycount": "0"]
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.getHotels, jsonString: dic as [String : AnyObject], success: { [weak self] sucess in
                ActivityIndicator.shared.hide()
                print("Hotels near by: \n \(sucess)")
                if let count = sucess.value(forKey: "count") as? Int {
                    if count > 0, let hotelsObj = sucess.value(forKey: "hotels") as? [Dictionary<String, Any>] {
                        self?.parseData(hotelData: hotelsObj)
                    } else {
                        print("No hotels")
                        DispatchQueue.main.async {
                            self?.courseTableView.reloadData()
                        }
                    }
                }
                }, failure: {
                    fail in
                    ActivityIndicator.shared.hide()
            })
        }
    }
    
    func parseData(hotelData: [Dictionary<String, Any>]) {
       
        for hotelObj in hotelData {
            if let hotel = hotelObj as Dictionary<String, AnyObject>?, let hotelId = hotel["hotel_Id"] as? String, let hotelName = hotel["hotel_name"] as? String, let hotelAddress = hotel["hotel_address"] as? String, let hotelLat = hotel["hotel_latitude"] as? String, let hotelLong = hotel["hotel_longitude"] as? String, let hotelPhoneNo = hotel["hotel_phone"] as? String, let hotelWebsite = hotel["hotel_website"] as? String, let courses = hotel["courses"] as? [Dictionary<String, Any>] {
                 var tmpCourseArr: [Course] = []
                for courseObj in courses {
                    if let course = courseObj as Dictionary<String, AnyObject>?, let courseId = course["course_id"] as? String, let courseName = course["course_name"] as? String, let status = course["status"] as? String, let dt = course["date"] as? String {
                        let course = Course.init(courseId: courseId, courseName: courseName, status: status, courseDate: dt)
                        tmpCourseArr.append(course)
                    }
                }
                
               let hotelObj = Hotel.init(hotelId: hotelId, hotelName: hotelName, hotelAddress: hotelAddress, hotelLat: hotelLat, hotelLong: hotelLong, hotelPhoneNo: hotelPhoneNo, hotelWebsite: hotelWebsite, coursesInHotel: tmpCourseArr)
                self.hotelsArr.append(hotelObj)
            }
        }
        DispatchQueue.main.async {
            self.courseTableView.reloadData()
        }
        print(self.hotelsArr)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hotelsArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsArr[section].coursesInHotel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "coursecell") {
            cell.textLabel?.text = hotelsArr[indexPath.section].coursesInHotel[indexPath.row].courseName
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return hotelsArr[section].hotelName
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44))
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-20, height: headerView.frame.height-10)
        label.text = hotelsArr[section].hotelName.capitalized
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        headerView.backgroundColor = UIColor.lightGray
        headerView.addSubview(label)
        
        let button:UIButton = UIButton(frame: CGRect(x: headerView.frame.width-30, y: 15, width: 20, height: 20))
        button.setTitle("", for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        button.tag = section
        button.setBackgroundImage(UIImage(named: "right_arrow"), for: .normal)

        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        headerView.addSubview(button)
        headerView.backgroundColor = hexStringToUIColor(hex: "#11AABF")
        return headerView
    }
    @objc func buttonClicked(sender: UIButton) {
        print("Button Clicked: \(sender.tag)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "LecturesInProgressVc") as? LecturesInProgressVc
       
        let hotelObj = hotelsArr[sender.tag]
        var tmpDatahotelDict : [String:Any] = [:]
        tmpDatahotelDict["HotelName"] = hotelObj.hotelName
        tmpDatahotelDict["HotelAddress"] = hotelObj.hotelAddress
        tmpDatahotelDict["HotelLatitude"] = hotelObj.hotelLat
        tmpDatahotelDict["HotelLongitude"] = hotelObj.hotelLong
        tmpDatahotelDict["HotelWebsite"] = hotelObj.hotelWebsite
        tmpDatahotelDict["HotelPhone"] = hotelObj.hotelPhoneNo
        tmpDatahotelDict["HotelId"] = hotelObj.hotelId
        
        vc?.DatahotelDict = tmpDatahotelDict
        self.navigationController?.pushViewController(vc!, animated: true)
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
        
        locationManager.stopUpdatingLocation()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
