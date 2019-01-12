//
//  ReportVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 15/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import SimplePDF
import PDFKit
class CellCourseTaken : UITableViewCell
{
    
    @IBOutlet weak var LblCourseName: UILabel!
}

class ReportVc: UIViewController {

    @IBOutlet weak var LblComletionDate: UILabel!
    @IBOutlet weak var LblGroupName: UILabel!
    @IBOutlet weak var LblUserNAme: UILabel!
     @IBOutlet weak var LblUNitsEarned: UILabel!
     @IBOutlet weak var LblAuthorName: UILabel!
     @IBOutlet weak var LblRegistrationNumbver: UILabel!
     @IBOutlet weak var LblAmountPaid: UILabel!
    @IBOutlet weak var TblVw: UITableView!
    @IBOutlet weak var stackVw: UIStackView!
    var CompletedCourseArray : [String:Any] = [:]
    var tripdata : [String:Any] = [:]
    var courseName = [String]()
    var screenshotImage :UIImage?
    var HotelNameAndAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       self.postCertiReport()
        if CompletedCourseArray.count > 0
        {
            stackVw.isHidden = false
         courseName.append(CompletedCourseArray["course_name"] as! String)
            self.LblGroupName.text = (self.CompletedCourseArray["hotel_name"] as? String)! + ", " + (self.CompletedCourseArray["hotel_address"] as? String)!
         LblAuthorName.text = self.CompletedCourseArray["author_name"] as? String
         LblRegistrationNumbver.text = self.CompletedCourseArray["author_reg_number"] as? String
            LblAmountPaid.text =  "$" + (self.CompletedCourseArray["course_fee"] as? String)!
         LblUNitsEarned.text = self.CompletedCourseArray["course_credit"] as? String
        }else
        {
            let courses = tripdata["courses"] as! NSArray
            for i in 0..<courses.count
            {
                let values = courses[i] as? [String:Any]
                let coursename = values!["name"] as! String
                courseName.append(coursename)
            }
            stackVw.isHidden = true
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActnBack(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ActnPrint(_ sender: Any)
    {
        if CompletedCourseArray.count > 0
        {
            postCertiFicatePdf()
        }else
        {
            postTripCertificatePdf()
        }
      
        
    }
    func load(_ StrURL: String,_ name:String) {
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(name).pdf")
        //Create URL to the source file you want to download
        let fileURL = URL(string: StrURL)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                    
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    UIAlertController.show(self, "Pdf", "Saved successfully")
                } catch (let writeError) {
                    UIAlertController.show(self, "Pdf", "AlreadyExists")
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    func postCertiReport()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.CertificateReport, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            let body = sucess["body"] as! [String:Any]
            self.LblUserNAme.text = body["username"] as? String
            if self.CompletedCourseArray.count > 0
            {
                self.LblGroupName.text = (self.CompletedCourseArray["hotel_name"] as? String)! + ", " + (self.CompletedCourseArray["hotel_address"] as? String)!
            }else
            {
                self.LblGroupName.text = (body["hotel_name"] as? String)! + ", " + (body["hotel_address"] as? String)!
                self.HotelNameAndAddress = (body["hotel_name"] as? String)! + ", " + (body["hotel_address"] as? String)!
            }
            let unixTimestamp = body["completed_date"] as? String
            let date = Date(timeIntervalSince1970: Double(unixTimestamp as! String)!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let strDate = dateFormatter.string(from: date)
            self.LblComletionDate.text = strDate
            self.TblVw.reloadData()
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func postCertiFicatePdf()
    {
        let courseId = CompletedCourseArray["course_id"] as! String
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.create_pdf_for_certificate, jsonString: Request.CreatePdfCertificateOfCourses(UserDefaults.standard.value(forKey: "authKey") as! String, courseId) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
             let body = sucess["body"] as! String
            self.load(body,self.CompletedCourseArray["course_name"] as! String)
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func postTripCertificatePdf()
    {
        let TripId = tripdata["id"] as! String
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.create_pdf_for_trip_certificate, jsonString: Request.CreatePdfCertificateOfTrips(UserDefaults.standard.value(forKey: "authKey") as! String,TripId,HotelNameAndAddress) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            let body = sucess["body"] as! String
            self.load(body,self.tripdata["trip_name"] as! String)
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
}
extension ReportVc: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return courseName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCourseTaken") as! CellCourseTaken
        cell.LblCourseName.text = courseName[indexPath.row]
        return cell
    }
}
