//
//  NotificationVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 02/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellNotify: UITableViewCell
{
    @IBOutlet weak var LblMenuName: UILabel!
    @IBOutlet weak var NotifyImg: UIImageView!
}
class NotificationVc: UIViewController {
    var nameArray :[[String:Any]] = []
    @IBOutlet weak var TableVwNotify: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postNotify()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func ActnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func postNotify()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.Notifications, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.nameArray  = sucess.value(forKey: "body") as! [[String:Any]]
            print(self.nameArray)
            self.TableVwNotify.reloadData()
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
}
extension NotificationVc: UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if nameArray.count != 0 {
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No Notifications"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let values = nameArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotify") as? CellNotify
        cell?.LblMenuName.text = (values["message"] as! String)
        
        let photo = values["course_image"] as? String
        if (photo != ""){
            cell?.NotifyImg.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named: "Bed"))
        }
                return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let values = nameArray[indexPath.item]
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLectVc") as? AvailableLectVc
        let courseId = values["course_id"] as! String
        vc?.detail = courseId
        vc?.shouldShowBuyBtn = true
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}
