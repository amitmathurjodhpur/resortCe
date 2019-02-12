//
//  TripTrackerViewController.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 1/13/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit

class TripTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let kHeaderSectionTag: Int = 6900
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionNames: Array<Any> = []
    var shouldShowCurrent: Bool = false
    var currentTrips: [Trip] = []
    var inProgressTrips: [Trip] = []
    var completedTrips: [Trip] = []
    var inProgressCourses: [Course] = []
    var completedCourses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden  = false
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        if shouldShowCurrent {
             self.title = "Trip Tracker"
            getTripList()
        } else {
             self.title = "CE Tracker"
            getCourseList()
        }
       
        self.tableView!.tableFooterView = UIView()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
    
    func getTripList() {
        if let userId = UserDefaults.standard.value(forKey: "userid") as? String {
            ActivityIndicator.shared.show(self.view)
             let dic = ["user_id": userId]
           // let dic = ["user_id": "184"]
            print("Dict: \n\(dic)")
            DataManager.postAPIWithParameters(urlString: API.getTrips , jsonString: dic as [String : AnyObject], success: {
                success in
                print(success)
                ActivityIndicator.shared.hide()
                if let response = success as? [Dictionary<String, AnyObject>], response.count > 0 {
                    print(response.count)
                    self.sectionNames = [ "Current Trips","In Progress Trips", "Completed Trips"]
                    for tripObj in response {
                        if let trip = tripObj as Dictionary<String, AnyObject>?, let tripId = trip["id"] as? String, let tripName = trip["name"] as? String, let status = trip["status"] as? String, let tDate = trip["date"] as? String {
                            let trip = Trip.init(tripeId: tripId, tripName: tripName, status: status, tripDate: tDate)
                            if status == "1" {
                                self.inProgressTrips.append(trip)
                            } else if status == "0" {
                                self.currentTrips.append(trip)
                            } else if status == "2" {
                                self.completedTrips.append(trip)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    //UIAlertController.show(self, "ResortCe", "No Results Found")
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })
        }
        
    }
    
    func getCourseList() {
        if let userId = UserDefaults.standard.value(forKey: "userid") as? String {
            ActivityIndicator.shared.show(self.view)
             let dic = ["user_id": userId]
            //let dic = ["user_id": "184"]
            print("Dict: \n\(dic)")
            DataManager.postAPIWithParameters(urlString: API.getCourses , jsonString: dic as [String : AnyObject], success: {
                success in
                print(success)
                ActivityIndicator.shared.hide()
                if let response = success as? [Dictionary<String, AnyObject>], response.count > 0 {
                    self.sectionNames = [ "In Progress Courses", "Completed Courses"]
                    for courseObj in response {
                        if let course = courseObj as Dictionary<String, AnyObject>?, let courseId = course["course_id"] as? String, let courseName = course["course_name"] as? String, let status = course["status"] as? String {
                            let course = Course.init(courseId: courseId, courseName: courseName, status: status)
                            if status == "0" {
                                self.inProgressCourses.append(course)
                            } else if status == "1" {
                                self.completedCourses.append(course)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    //UIAlertController.show(self, "ResortCe", "No Results Found")
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            //messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.text = "No Results Found"
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            if shouldShowCurrent {
                if section == 0 {
                    return currentTrips.count
                } else if section == 1 {
                    return inProgressTrips.count
                } else if section == 2 {
                    return completedTrips.count
                }
            } else {
                if section == 0 {
                    return inProgressCourses.count
                } else if section == 1 {
                    return completedCourses.count
                }
            }
           return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.lightGray
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        header.textLabel?.text = header.textLabel?.text?.capitalized
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18))
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(TripTrackerViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "triptrackcell", for: indexPath) as? TripTrackCell {
            if shouldShowCurrent {
                if indexPath.section == 0 {
                    cell.tripTitleLabel?.text = currentTrips[indexPath.row].tripName
                    cell.tripTimeLabel?.text = currentTrips[indexPath.row].tripDate
                    cell.tripStatusLabel.isHidden = true
                    cell.tripStatusLabel?.text = ""
                } else if indexPath.section == 1 {
                    cell.tripTitleLabel?.text = inProgressTrips[indexPath.row].tripName
                    cell.tripTimeLabel?.text = inProgressTrips[indexPath.row].tripDate
                    cell.tripStatusLabel.isHidden = false
                    cell.tripStatusLabel?.text = "In Progress"
                    cell.tripStatusLabel?.textColor = UIColor.orange
                } else if indexPath.section == 2 {
                    cell.tripTitleLabel?.text = completedTrips[indexPath.row].tripName
                    cell.tripTimeLabel?.text = completedTrips[indexPath.row].tripDate
                    cell.tripStatusLabel.isHidden = false
                    cell.tripStatusLabel?.text = "Completed"
                    cell.tripStatusLabel?.textColor = UIColor.green
                }
            } else {
                if indexPath.section == 0 {
                    cell.tripTitleLabel?.text = inProgressCourses[indexPath.row].courseName
                    cell.tripTimeLabel?.text = "2019-02-08 21:21:14"
                    cell.tripStatusLabel.isHidden = false
                    cell.tripStatusLabel?.text = "In Progress"
                    cell.tripStatusLabel?.textColor = UIColor.orange
                    
                } else if indexPath.section == 1 {
                    cell.tripTitleLabel?.text = completedCourses[indexPath.row].courseName
                    cell.tripTimeLabel?.text = "2019-02-08 21:21:14"
                    cell.tripStatusLabel.isHidden = false
                    cell.tripStatusLabel?.text = "Completed"
                    cell.tripStatusLabel?.textColor = UIColor.orange
                   
                }
            }
            
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        self.expandedSectionHeaderNumber = -1
        if shouldShowCurrent {
             var sectionData: [Trip] = []
            if section == 0 {
                sectionData = currentTrips
            } else if section == 1 {
                sectionData = inProgressTrips
            } else if section == 2 {
                sectionData = completedTrips
            }
            if (sectionData.count == 0) {
                return
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.tableView!.beginUpdates()
                self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
                self.tableView!.endUpdates()
            }
        } else {
             var sectionData: [Course] = []
             if section == 0 {
                sectionData = inProgressCourses
            } else if section == 1 {
                sectionData = completedCourses
            }
            if (sectionData.count == 0) {
                return
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.tableView!.beginUpdates()
                self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
                self.tableView!.endUpdates()
            }
        }
        
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        
        if shouldShowCurrent {
            var sectionData: [Trip] = []
            if section == 0 {
                sectionData = currentTrips
            } else if section == 1 {
                sectionData = inProgressTrips
            } else if section == 2 {
                sectionData = completedTrips
            }
            if (sectionData.count == 0) {
                self.expandedSectionHeaderNumber = -1
                return
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.expandedSectionHeaderNumber = section
                self.tableView!.beginUpdates()
                self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
                self.tableView!.endUpdates()
            }
        } else {
            var sectionData: [Course] = []
            if section == 0 {
                sectionData = inProgressCourses
            } else if section == 1 {
                sectionData = completedCourses
            }
            if (sectionData.count == 0) {
                self.expandedSectionHeaderNumber = -1
                return
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.expandedSectionHeaderNumber = section
                self.tableView!.beginUpdates()
                self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
                self.tableView!.endUpdates()
            }
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
