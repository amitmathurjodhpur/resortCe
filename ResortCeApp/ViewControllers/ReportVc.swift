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
class CellCourseTaken : UITableViewCell {
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
        if CompletedCourseArray.count > 0 {
        stackVw.isHidden = false
         courseName.append(CompletedCourseArray["course_name"] as! String)
        self.LblGroupName.text = (self.CompletedCourseArray["hotel_name"] as? String)! + ", " + (self.CompletedCourseArray["hotel_address"] as? String)!
         LblAuthorName.text = self.CompletedCourseArray["author_name"] as? String
         LblRegistrationNumbver.text = self.CompletedCourseArray["author_reg_number"] as? String
            LblAmountPaid.text =  "$" + (self.CompletedCourseArray["course_fee"] as? String)!
         LblUNitsEarned.text = self.CompletedCourseArray["course_credit"] as? String
        } else {
            if let courses = tripdata["courses"] as? NSArray {
                for i in 0..<courses.count {
                    let values = courses[i] as? [String:Any]
                    let coursename = values!["name"] as! String
                    courseName.append(coursename)
                }
            }
            stackVw.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActnPrint(_ sender: Any) {
        if CompletedCourseArray.count > 0 {
            postCertiFicatePdf()
        } else {
            postTripCertificatePdf()
        }
    }
    
    func load(_ StrURL: String,_ name:String) {
         // Create destination URL
        if let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(name).pdf")
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            if let fileURL = URL(string: StrURL) {
                let request = URLRequest(url: fileURL)
                let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                    if let tempLocalUrl = tempLocalUrl, error == nil {
                        // Success
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                            print("Successfully downloaded. Status code: \(statusCode)")
                        }
                        do {
                            //try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                            _ = try FileManager.default.replaceItemAt(destinationFileUrl, withItemAt: tempLocalUrl)
                            //UIAlertController.show(self, "Pdf", "Saved successfully")
                            self.shareDocument(filePath: destinationFileUrl)
                        } catch (let writeError) {
                            //UIAlertController.show(self, "Pdf", "AlreadyExists")
                            print("Error creating a file: AlreadyExists \(destinationFileUrl) : \(writeError)")
                            self.shareDocument(filePath: destinationFileUrl)
                        }
                    } else {
                        print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any)
                    }
                }
                task.resume()
            }
        }
    }
    
    func shareDocument(filePath: URL) {
        print("File URL: \(filePath.relativePath)")
        let url =  NSURL.fileURL(withPath: filePath.relativePath)
        let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func postCertiReport() {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.CertificateReport, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            if let body = sucess["body"] as? [String:Any] {
                self.LblUserNAme.text = body["username"] as? String
                if self.CompletedCourseArray.count > 0 {
                    self.LblGroupName.text = (self.CompletedCourseArray["hotel_name"] as? String ?? "") + ", " + (self.CompletedCourseArray["hotel_address"] as? String ?? "")
                } else {
                    self.LblGroupName.text = (body["hotel_name"] as? String ?? "") + ", " + (body["hotel_address"] as? String ?? "")
                    self.HotelNameAndAddress = (body["hotel_name"] as? String ?? "") + ", " + (body["hotel_address"] as? String ?? "")
                }
               if let unixTimestamp = body["completed_date"] as? String, let timeStamp = Double(unixTimestamp) {
                    let date = Date(timeIntervalSince1970: timeStamp)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let strDate = dateFormatter.string(from: date)
                    self.LblComletionDate.text = strDate
                } else {
                    self.LblComletionDate.text = ""
                }
                 self.TblVw.reloadData()
            }
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    
    func postCertiFicatePdf() {
        if let auth_key = UserDefaults.standard.value(forKey: "authKey") as? String, let courseId = CompletedCourseArray["course_id"] as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.create_pdf_for_certificate, jsonString: Request.CreatePdfCertificateOfCourses(auth_key, courseId) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let body = sucess["body"] as? String, let courseName = self.CompletedCourseArray["course_name"] as? String {
                    self.load(body,courseName)
                }
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func postTripCertificatePdf() {
        if let auth_key = UserDefaults.standard.value(forKey: "authKey") as? String, let TripId = tripdata["id"] as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.create_pdf_for_trip_certificate, jsonString: Request.CreatePdfCertificateOfTrips(auth_key,TripId,HotelNameAndAddress) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let body = sucess["body"] as? String, let courseName =  self.tripdata["trip_name"] as? String {
                    self.load(body,courseName)
                }
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
}

extension ReportVc: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCourseTaken") as! CellCourseTaken
        cell.LblCourseName.text = courseName[indexPath.row]
        return cell
    }
}
