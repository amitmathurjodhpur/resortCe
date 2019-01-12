//
//  LockerVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellLocker : UICollectionViewCell
{
    @IBOutlet weak var ImageVw: UIImageView!
    @IBOutlet weak var TxtVw: UILabel!
    @IBOutlet weak var BtnCertificate: UIButton!
    @IBOutlet weak var BtnReport: UIButton!
    
    @IBOutlet weak var LblDate: UILabel!
}
class CellLockerIP : UICollectionViewCell
{
    @IBOutlet weak var ImageVw: UIImageView!
    @IBOutlet weak var TxtVw: UILabel!
    @IBOutlet weak var LblCname: UILabel!
}
class CellLockerTrip : UICollectionViewCell
{
    @IBOutlet weak var ImageVw: UIImageView!
    @IBOutlet weak var LblTripname: UILabel!
    @IBOutlet weak var LblExpenses: UILabel!
    @IBOutlet weak var LblDate: UILabel!
    @IBOutlet weak var LblNuCourses: UILabel!
}
class ReuseableView: UICollectionReusableView
{
    @IBOutlet weak var label: UILabel!
}
class LockerVc: UIViewController{
    var nameArray : [[String:Any]] = []
    var ProgressArray : [[String:Any]] = []
    var TripArray : [[String:Any]] = []
    @IBOutlet weak var CollVw: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        postLectInProgress()
        PostLockerList()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        postTripListing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // web services
    func PostLockerList()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.LockerCourseListing, jsonString: Request.setauthKey(UserDefaults.standard.value(forKey: "authKey") as! String) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.nameArray = sucess["body"] as! [[String:Any]]
            self.CollVw.reloadData()
        
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()

        })
    }
    func postLectInProgress() {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.course_in_progress_listing
            , jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                
                self.ProgressArray  = (sucess["body"] as? [[String:Any]])!
                self.CollVw.reloadData()
                
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func postTripListing()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.TripListing, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.TripArray  = sucess.value(forKey: "body") as! [[String:Any]]
            self.CollVw.reloadData()
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ActnPrintReport(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReportVc") as? ReportVc
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    @IBAction func ActnCertificate(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReportVc") as? ReportVc
        vc?.CompletedCourseArray = nameArray[sender.tag]
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    @IBAction func ActnAddTrip(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateTripVcViewController") as? CreateTripVcViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                print(data)
             //self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func TripReport(_ indexPath:Int)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TripReportVc") as? TripReportVc
        vc?.GetReportTrip = TripArray[indexPath]
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func EnterTrip(_ indexPath:Int)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateTripVcViewController") as? CreateTripVcViewController
        vc?.GetDetailTrip = TripArray[indexPath]
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    func dateConvert(_ TimeStamp:String) -> String
    {
        let unixTimestamp = TimeStamp
        let date = Date(timeIntervalSince1970: Double(unixTimestamp as! String)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
        
    }
    
}
extension LockerVc : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
         return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 1
        {
        return nameArray.count
        }
        else if section == 2
        {
            return ProgressArray.count
        }
        else
        {
            return TripArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 1
        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLocker", for: indexPath) as? CellLocker
        let values = nameArray[indexPath.item]
        let photo = values["course_image"] as? String
            let unixTimestamp = values["created"] as? String
            let date = Date(timeIntervalSince1970: Double(unixTimestamp as! String)!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let strDate = dateFormatter.string(from: date)
            cell?.LblDate.text = strDate
            cell?.BtnCertificate.tag = indexPath.row
        if (photo != "")
        {
            cell?.ImageVw.sd_setImage(with: URL(string: photo!), placeholderImage:#imageLiteral(resourceName: "Bed") )
        }
            cell?.TxtVw.text = (values["course_name"] as! String)
            return cell!
        }
        else if indexPath.section == 2
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLockerIP", for: indexPath) as? CellLockerIP
            let values = ProgressArray[indexPath.row]
            let photo = values["image"] as? String
            cell?.LblCname.text = (values["name"] as! String)
            cell?.TxtVw.text = (values["overview"] as! String)
            
            if (photo != "")
            {
                cell?.ImageVw.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named: "Bed"))
            }
            return cell!
        }else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLockerTrip", for: indexPath) as? CellLockerTrip
             let values = TripArray[indexPath.row]
            cell?.LblTripname.text = values["trip_name"] as? String
            cell?.LblNuCourses.text = values["total_course"] as? String
            if values["trip_date"] as! String != "" || values["trip_end_date"] as? String != ""
            {
            let StartDate = dateConvert(values["trip_date"] as! String)
            let EndDate = dateConvert(values["trip_end_date"] as! String)
             cell?.LblDate.text = StartDate + " - " + EndDate
            }
            
            return cell!
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
        if indexPath.section == 0
        {
             return CGSize(width: (collectionView.frame.width), height: 70)
        }
        else
        {
             return CGSize(width: (collectionView.frame.width/2)-5, height: 200)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReuseableView", for: indexPath) as! ReuseableView
        if indexPath.section == 1
        {
            if nameArray.count > 0
            {
            header.label.text = "Completed Courses"
            }
            else
            {
                header.label.text = "No Completed Courses"
            }
        }
        else if indexPath.section == 2
        {
            if ProgressArray.count > 0
            {
           header.label.text = "In Progress Courses"
            }
            else
            {
                header.label.text = "No In Progress Courses"
            }
        }
        else
        {
            if TripArray.count > 0
            {
               header.label.text = "Trips"
            }
            else
            {
                header.label.text = "No Trips(Add One)"
            }
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            
            let alert:UIAlertController=UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let ReportAction = UIAlertAction(title: "Trip Report/Edit", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                self.TripReport(indexPath.row)
                
            }
            let CerificateAction = UIAlertAction(title: "Certificate", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVc") as? ReportVc
                vc?.tripdata = self.TripArray[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: false)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
            {
                UIAlertAction in
            }
            // Add the actions
            
            alert.addAction(ReportAction)
            alert.addAction(CerificateAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
       // let cell = collectionView.cellForItem(at: indexPath) as? CellLocker
       else if indexPath.section == 1
        {
            let values = nameArray[indexPath.item]
            let photo = values["course_image"] as? String
            if photo != ""
            {
                let url = URL(string: photo!)
                self.downloadImage(url:url!)
                
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: "FirstVc") as? FirstVc
            vc?.getReview = (values["course_id"] as? String)!
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        else if indexPath.section == 2
        {
            let values = ProgressArray[indexPath.row]
            let  PostLectId = values["id"] as! String
            let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLectVc") as? AvailableLectVc
            vc?.detail = PostLectId
            self.navigationController?.pushViewController(vc!, animated: true)
            let photo = values["image"] as? String
            if photo != ""
            {
                let url = URL(string: photo!)
                self.downloadImage(url:url!)
            }
        }
    }
}

