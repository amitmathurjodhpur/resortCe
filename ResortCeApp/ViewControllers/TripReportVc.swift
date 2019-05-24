
//
//  TripReportVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 29/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellReport:UITableViewCell
{
    @IBOutlet weak var LblTripName: UILabel!
    @IBOutlet weak var LblTripDate: UILabel!
}
class CellCoursesReport:UITableViewCell
{
    @IBOutlet weak var lblCourseName: UILabel!
    @IBOutlet weak var LblCousreDate: UILabel!
}
class CellReportImage:UITableViewCell
{
    @IBOutlet weak var imagevw: UIImageView!
    @IBOutlet weak var LblExpenseName: UILabel!
    @IBOutlet weak var LblExpenseDate: UILabel!
    @IBOutlet weak var LblExpenseType: UILabel!
    @IBOutlet weak var LblExpenseAmount: UILabel!
}

class TripReportVc: UIViewController {
 var GetReportTrip :[String:Any] = [:]
    var dataArray = ["Tripname","Totalcourse","Trip Date",]
    var PlaceholderArray : [String] = ["","","","","","","","",""]
    var RecieptImageArray : [String] = []
    var ExpenseArray :[[String:Any]] = []
    var CoursesArray  = [[String:Any]]()
    @IBOutlet weak var tblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(GetReportTrip)
        PlaceholderArray[0] = GetReportTrip["trip_name"] as? String ?? ""
        PlaceholderArray[1] = GetReportTrip["total_course"] as? String ?? ""
        PlaceholderArray[2] = GetReportTrip["trip_date"] as? String ?? ""
        ExpenseArray = GetReportTrip["expensis"] as? [[String : Any]] ?? []
        CoursesArray = GetReportTrip["courses"] as? [[String : Any]] ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
    
    func dateConvert(_ TimeStamp:String) -> String {
        let unixTimestamp = TimeStamp
        if let timeStamp = Double(unixTimestamp) {
            let date = Date(timeIntervalSince1970: timeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ActnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ActnSave(_ sender: Any) {
        postTripReportPDF()
    }
    
    func load(_ StrURL: String,_ Name:String) {
        // Create destination URL
        if let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let destinationFileUrl = documentsUrl.appendingPathComponent("Trip\(Name).pdf")
            //Create URL to the source file you want to download
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
                            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                            UIAlertController.show(self, "Pdf", "Saved successfully")
                        } catch (let writeError) {
                            UIAlertController.show(self, "Pdf", "AlreadyExists")
                            print("Error creating a file \(destinationFileUrl) : \(writeError)")
                        }
                    } else {
                        print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "")
                    }
                }
                task.resume()
            }
        }
    }
    
    func postTripReportPDF() {
        if let TripId = GetReportTrip["id"] as? String, let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.create_pdf_for_expenses, jsonString: Request.CreatePdfCertificateOfTrips(authKey,TripId,"") as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let body = sucess["body"] as? String, let reportTrip = self.GetReportTrip["trip_name"] as? String {
                    self.load(body,"\(reportTrip)\(TripId)")
                }
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func DeleteExpense(_ ExpenseId:String) {
        if let TripId = GetReportTrip["id"] as? String, let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.DeleteExpenses, jsonString: Request.DeleteExpenses(authKey,TripId,ExpenseId) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                self.navigationController?.popViewController(animated: true)
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
        
    }
}

extension TripReportVc:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
             return CoursesArray.count
        } else {
            return ExpenseArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReport", for: indexPath) as? CellReport
        cell?.LblTripName.text = GetReportTrip["trip_name"] as? String
        cell?.LblTripDate.text = (GetReportTrip["trip_date"] as? String ?? "") + " - " + (GetReportTrip["end_date"] as? String ?? "")
        return cell!
        } else if indexPath.section == 1 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "CellCoursesReport", for: indexPath) as? CellCoursesReport
            let values = CoursesArray[indexPath.row]
            cell?.lblCourseName.text = values["name"] as? String
            cell?.LblCousreDate.text = dateConvert((values["created"] as? String)!)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellReportImage", for: indexPath) as? CellReportImage
            let values = ExpenseArray[indexPath.row]
            cell?.LblExpenseName.text = values["expensis_name"] as? String
            cell?.LblExpenseDate.text = values["expensis_date"] as? String ?? ""
            cell?.LblExpenseType.text = values["expensis_type"] as? String
            cell?.LblExpenseAmount.text = "$" + (values["expensis_amount"] as? String)!
            
            if let image = values["expensis_image"] as? String {
                cell?.imagevw.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "Bed"))
            }
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 430
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        header.backgroundColor = UIColor.white
        header.textColor = UIColor.black
        if section == 0 {
            header.text = ""
        } else if section == 1 {
            header.text = "Total Courses Completed"
        } else {
            header.text = "Trip Expenses"
        }
        return header
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let alert:UIAlertController=UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let EditAction = UIAlertAction(title: "Edit Expense", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditTrip") as? EditTrip
                vc?.GetDataTrip = self.ExpenseArray[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            let DeleteAction = UIAlertAction(title: "Delete Expense", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let Values = self.ExpenseArray[indexPath.row]
                let expenseId = Values["id"] as! String
                self.DeleteExpense(expenseId)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alert.addAction(EditAction)
            alert.addAction(DeleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.section == 0  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditTrip") as? EditTrip
            vc?.tripId = self.GetReportTrip["id"] as! String
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool  {
        if indexPath.section == 0 {
            return false
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        if editActionsForRowAt.section == 2 {
            let Edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditTrip") as? EditTrip
            vc?.GetDataTrip = self.ExpenseArray[editActionsForRowAt.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        Edit.backgroundColor = UIColor.gray
        return [Edit]
        } else {
            let AddNew = UITableViewRowAction(style: .normal, title: "Add New Expenses") { action, index in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditTrip") as? EditTrip
                vc?.tripId = self.GetReportTrip["id"] as! String
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            AddNew.backgroundColor = UIColor.gray
            return [AddNew]
        }
    }
    
}
