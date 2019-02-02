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
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    var shouldShowCurrent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden  = false
       
        if shouldShowCurrent {
             self.title = "Trip Tracker"
            sectionNames = [ "Current Courses","In Progress Courses", "Completed Courses"]
            sectionItems = [ ["Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective"],
                             ["Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective"], ["Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective"] ]
        } else {
             self.title = "CE Tracker"
            sectionNames = [ "In Progress Courses", "Completed Courses"]
            sectionItems = [ ["Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective"], ["Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective", "Achieving Scale with the Reach Objective"] ]
        }
       
        self.tableView!.tableFooterView = UIView()
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
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
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "triptrackcell", for: indexPath) as! TripTrackCell
        let section = self.sectionItems[indexPath.section] as! NSArray
        
        cell.textLabel?.textColor = UIColor.black
        cell.tripTitleLabel?.text = section[indexPath.row] as? String
        cell.tripTimeLabel?.text = "14 Jan 2018"
        if indexPath.row % 2 == 0 {
             cell.tripStatusLabel?.text = "Completed"
             cell.tripStatusLabel?.textColor = UIColor.green
        } else {
             cell.tripStatusLabel?.text = "In Progress"
            cell.tripStatusLabel?.textColor = UIColor.orange
        }
       
        return cell
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
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1
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
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
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
