//
//  PlanTripViewController.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 1/12/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import CoreLocation

class PlanTripViewController: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate, UITextFieldDelegate {
     @IBOutlet weak var tipNameView: UIView!
     @IBOutlet weak var courseView: UIView!
     @IBOutlet weak var addExpenseView:  UIView!
     @IBOutlet weak var expenseScrollView:  UIScrollView!
     @IBOutlet weak var segmentView: UISegmentedControl!
     @IBOutlet weak var endDatetxt: UITextField!
     @IBOutlet weak var startDatetxt: UITextField!
     @IBOutlet weak var hotelNametxt: UITextField!
     @IBOutlet weak var tipNameTxt: UITextField!
     @IBOutlet weak var courseTableView: UITableView!
     @IBOutlet weak var expenseName: UITextField!
     @IBOutlet weak var expenseTypeTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expenseAmountTxt: UITextField!
    @IBOutlet weak var expenseDate: UITextField!
    @IBOutlet weak var pageTitle: UILabel!

    @IBOutlet weak var expenseTitle: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
   
    let datePicker = UIDatePicker()
    var expensePicker = UIPickerView()
    var locationManager = CLLocationManager()
    var tableDataSource: GMSAutocompleteTableDataSource?
    var userCurrentLat = 0.0
    var userCurrentLong = 0.0
    var imagePicker = UIImagePickerController()
    var hotelCurrentLat = 0.0
    var hotelCurrentLong = 0.0
    var type = 1
    var hotelPhoneNumber: String = ""
    var hotelwebsite: String = ""
    var hotelID: String = ""
    var expenseID: String = ""
    var hotelName: String = ""
    var currentTripId: String = ""
    var expenseImagePath: String = ""
    var currentImage: UIImage?
    //var courseArr: [Course] = []
    var groupArr: [GroupLecture] = []
    var expenseArr: [Expense] = []
    var selectedCourses: [String] = []
    var pickerData = ["Lodging" , "Transportation/Airfare" , "Meals" , "Other"]
    let scrollViewContentHeight = 1200 as CGFloat
    var isEditMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if isEditMode == true {
            segmentView.isUserInteractionEnabled = true
            pageTitle.text = "Edit Trip"
            expenseTitle.text = "Edit Expenses"
            getTripData()
        } else {
            segmentView.isUserInteractionEnabled = false
            pageTitle.text = "Add Trip"
            expenseTitle.text = "Add Expenses"
        }
    }
    
    @IBAction func tripValueChanged(_ sender: UISegmentedControl) {
        if isEditMode == true {
            if sender.selectedSegmentIndex == 0 {
                UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                    self?.tipNameView.isHidden = false
                    self?.courseView.isHidden = true
                    self?.nextBtn.isHidden = true
                    self?.expenseScrollView.isHidden = true
                    self?.segmentView.selectedSegmentIndex = 0
                })
            } else if sender.selectedSegmentIndex == 1 {
                UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                    self?.tipNameView.isHidden = true
                    self?.courseView.isHidden = true
                    self?.nextBtn.isHidden = true
                    self?.expenseScrollView.isHidden = false
                    self?.expenseScrollView.delegate = self
                    self?.segmentView.selectedSegmentIndex = 1
                })
            } else if sender.selectedSegmentIndex == 2 {
                self.segmentView.selectedSegmentIndex = 1
                self.moveToTrips()
            }
        }
    }
    
    func getTripData() {
        if let userId = UserDefaults.standard.value(forKey: "userid") as? String {
            ActivityIndicator.shared.show(self.view)
            let dic = ["user_id": userId, "trip_id": currentTripId]
            print("Dict: \n\(dic)")
            DataManager.postAPIWithParameters(urlString: API.getTripDeatils, jsonString: dic as [String : AnyObject], success: {
                success in
                ActivityIndicator.shared.hide()
                if let response = success as? [Dictionary<String, AnyObject>], response.count > 0, let responseObj = response.first?["trip_data"] {
                    self.expenseArr.removeAll()
                    print(response.count)
                    if let expensearr = responseObj["expenses"] as? [[String:Any]], expensearr.count > 0 {
                        print(expensearr)
                        for expObj in expensearr {
                            let expense = Expense.init(expenseId: expObj["id"] as? String ?? "", expenseName: expObj["expensis_name"] as? String ?? "", expenseType: expObj["expensis_type"] as? String ?? "", expenseAmount: expObj["expensis_amount"] as? String ?? "", expenseDate: expObj["expensis_date"] as? String ?? "", receiptPath: expObj["expensis_image"] as? String ?? "")
                            self.expenseArr.append(expense)
                        }
                        self.viewDidLayoutSubviews()
                    }
                    if self.expenseArr.count > 0, let expObj = self.expenseArr.first {
                        self.expenseName.text = expObj.expenseName
                        self.expenseTypeTxt.text = expObj.expenseType
                        self.expenseAmountTxt.text = expObj.expenseAmount
                        self.expenseDate.text = expObj.expenseDate
                        self.expenseImagePath = expObj.receiptPath
                        self.expenseID = expObj.expenseId
                    }
                    self.tipNameTxt.text = responseObj["trip_name"] as? String
                    self.startDatetxt.text = responseObj["start_date"] as? String
                    self.endDatetxt.text = responseObj["end_date"] as? String
                    self.hotelNametxt.text = responseObj["hotel_name"] as? String
                    if let hotelLatStr = responseObj["hotel_latitude"] as? String, let hotelLat = Double(hotelLatStr) {
                        self.hotelCurrentLat = hotelLat
                    }
                    if let hotelLongStr = responseObj["hotel_longitude"] as? String, let hotelLong = Double(hotelLongStr) {
                        self.hotelCurrentLong = hotelLong
                    }
                    self.hotelPhoneNumber = responseObj["hotel_phone"] as? String ?? "0"
                    self.hotelwebsite = responseObj["hotel_website"] as? String ?? ""
                    self.hotelID = responseObj["hotel_Id"] as? String ?? ""
                    self.hotelName = responseObj["hotel_name"] as? String ?? ""
                } else {
                    UIAlertController.show(self, "ResortCe", "No Results Found")
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })
        }
    }
    
    func configureView() {
        clearAll()
        self.navigationController?.isNavigationBarHidden = false
       // self.tableView.register(ExpenceTableViewCell.self, forCellReuseIdentifier: "expensecell")
        self.tableView.register(UINib.init(nibName: "ExpenceTableViewCell", bundle: nil), forCellReuseIdentifier: "expensecell")
        self.tableView.register(UINib(nibName: "NAME_OF_THE_CELL_CLASS", bundle: nil), forCellReuseIdentifier: "REUSE_IDENTIFIER");

        self.title = "Resortcee"
        nextBtn.isHidden = true
        self.tipNameView.isHidden = false
        self.courseView.isHidden = true
        self.expenseScrollView.isHidden = true
        self.segmentView.selectedSegmentIndex = 0
        
        getCurrentLocation()
        hotelNametxt.delegate = self
        endDatetxt.delegate = self
        startDatetxt.delegate = self
        expenseDate.delegate = self
        expenseTypeTxt.delegate = self
        
        expenseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: scrollViewContentHeight)
        expenseScrollView.delegate = self
        tableView.delegate = self
        expenseScrollView.bounces = false
       // tableView.bounces = false
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.isScrollEnabled = false
  }
    
    @IBAction func nextClick(_ sender: Any) {
      if let tipText = tipNameTxt.text, !tipText.isEmpty, !hotelName.isEmpty, let startDate = startDatetxt.text, !startDate.isEmpty, let endDate = endDatetxt.text, !endDate.isEmpty, let hotelAddress = hotelNametxt.text {
            self.view.endEditing(true)
            ActivityIndicator.shared.show(self.view)
            let userID = UserDefaults.standard.value(forKey: "userid")
            var dic: [String:Any] = [:]
            var urlStr = ""
            if self.isEditMode {
                dic = ["trip_name": tipText ,"hotel_name": hotelName, "hotel_address": hotelAddress, "hotel_latitude": hotelCurrentLat.toString(), "hotel_longitude":hotelCurrentLong.toString() ,"start_date":startDate,"end_date":endDate, "hotel_phone":hotelPhoneNumber, "hotel_Id":hotelID, "user_id": userID ?? "", "id": currentTripId]
                urlStr = API.editTrip
            } else {
                dic = ["trip_name": tipText ,"hotel_name": hotelName, "hotel_address": hotelAddress, "hotel_latitude": hotelCurrentLat.toString(), "hotel_longitude":hotelCurrentLong.toString() ,"start_date":startDate,"end_date":endDate, "hotel_phone":hotelPhoneNumber, "hotel_Id":hotelID, "user_id": userID ?? ""]
                urlStr = API.createTrip
            }
            print("Dict: \n\(dic)")
            DataManager.postAPIWithParameters(urlString: urlStr , jsonString: dic as [String : AnyObject], success: {
                success in
                print(success)
                ActivityIndicator.shared.hide()
                   if let response = success as? Dictionary<String, AnyObject> {
                    if let status = response["status"] as? Int, status == 1 {
                        if let tripId = response["trip_id"] as? Int {
                            self.currentTripId = String(tripId)
                        }
                        UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                            self?.tipNameView.isHidden = true
                            self?.courseView.isHidden = true
                            self?.nextBtn.isHidden = true
                            self?.expenseScrollView.isHidden = false
                            self?.expenseScrollView.delegate = self
                            self?.segmentView.selectedSegmentIndex = 1
                        //self?.getCourseList()
                         })
                    } else {
                        if self.isEditMode {
                            if let message = response["message"] as? String, message == "Trip Updated Successfully" {
                                UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                                    self?.tipNameView.isHidden = true
                                    self?.courseView.isHidden = true
                                    self?.nextBtn.isHidden = true
                                    self?.expenseScrollView.isHidden = false
                                    self?.expenseScrollView.delegate = self
                                    self?.segmentView.selectedSegmentIndex = 1
                                    //self?.getCourseList()
                                })
                            }
                        } else {
                            if let message = response["message"] as? String {
                                UIAlertController.show(self, "Error", message)
                            }
                        }
                    }
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })

        } else {
            UIAlertController.show(self, "Error", "All Fields are mandatory")
        }
       /* UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
            self?.tipNameView.isHidden = true
            self?.courseView.isHidden = true
            self?.nextBtn.isHidden = true
            self?.expenseScrollView.isHidden = false
            self?.expenseScrollView.delegate = self
            self?.segmentView.selectedSegmentIndex = 1
           //self?.getCourseList()
        })*/
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y:  self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: CGFloat((self.expenseArr.count) * 62))
            self.expenseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat((self.expenseArr.count + 7) * 62))
            self.tableView.reloadData()
        }
    }
   /* func getCourseList() {
        if let userId = UserDefaults.standard.value(forKey: "userid") as? String {
            ActivityIndicator.shared.show(self.view)
          let dic = ["user_id": userId]
            print("Dict: \n\(dic)")
            DataManager.postAPIWithParameters(urlString: API.getCourses , jsonString: dic as [String : AnyObject], success: {
                success in
                print(success)
                ActivityIndicator.shared.hide()
                if let response = success as? [Dictionary<String, AnyObject>], response.count > 0 {
                    print(response.count)
                    for courseObj in response {
                        if let course = courseObj as Dictionary<String, AnyObject>?, let courseId = course["course_id"] as? String, let courseName = course["course_name"] as? String, let status = course["status"] as? String, let dt = course["date"] as? String {
                            let course = Course.init(courseId: courseId, courseName: courseName, status: status, courseDate: dt)
                            self.courseArr.append(course)
                        }
                    }
                    print(self.courseArr)
                    DispatchQueue.main.async {
                        self.courseTableView.reloadData()
                    }
                } else {
                    UIAlertController.show(self, "ResortCe", "No Results Found")
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })
        }
    }*/
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
    
    //MARK: - SEARCH LOCATION ON MAP
    func searchBarBtnPressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
     func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func didRequestAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    //MARK: - Date Picker Data Source & Delegate
    func datePickerVw() {
        datePicker.datePickerMode = .date
        //datePicker.minimumDate = NSDate() as Date
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        startDatetxt.inputAccessoryView = toolbar
        startDatetxt.inputView = datePicker
        endDatetxt.inputAccessoryView = toolbar
        endDatetxt.inputView = datePicker
        expenseDate.inputAccessoryView = toolbar
        expenseDate.inputView = datePicker
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.expensePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.expensePicker.delegate = self
        self.expensePicker.dataSource = self
        self.expensePicker.backgroundColor = UIColor.white
        textField.inputView = self.expensePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PlanTripViewController.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PlanTripViewController.cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        if type == 1 {
           startDatetxt.text = formatter.string(from: datePicker.date)
        } else if type == 2 {
            endDatetxt.text = formatter.string(from: datePicker.date)
        } else if type == 3 {
            expenseDate.text = formatter.string(from: datePicker.date)
        }
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == hotelNametxt {
            searchBarBtnPressed(self)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == startDatetxt {
            type = 1
            self.datePickerVw()
         } else if textField == endDatetxt {
            type = 2
            self.datePickerVw()
         } else if textField == expenseDate {
            type = 3
            self.datePickerVw()
         } else if textField == expenseTypeTxt {
             self.pickUp(textField)
        }
   }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Address Picker Extension
extension PlanTripViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(place)
        hotelCurrentLat = place.coordinate.latitude
        hotelCurrentLong = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
        
        if let contactNo = place.phoneNumber {
            hotelPhoneNumber = contactNo
        }
        if let hotel_ID = place.placeID {
            hotelID = hotel_ID
        }
        
        if let hotel_name = place.name {
            hotelName = hotel_name
        }
        
        if let hotel_web = place.website {
            hotelwebsite = hotel_web.absoluteString
        }
        
        hotelNametxt.text = place.formattedAddress
        
        /*let coordinate1 = CLLocation(latitude: userCurrentLat, longitude:userCurrentLong)
        let coordinate2 = CLLocation(latitude: hotelCurrentLat, longitude: hotelCurrentLong)
        
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        // 50 miles = 80467.2 meter
        if(distanceInMeters <= 80467.2) {
            // under 1 mile
            print("In 50 miles")
            hotelNametxt.text = ""
            UIAlertController.show(self, "Error", "All Trips must be 50 miles from your home.")
        } else {
             print("out of 50 miles")
            if let contactNo = place.phoneNumber {
                hotelPhoneNumber = contactNo
            }
            if let hotel_ID = place.placeID {
                hotelID = hotel_ID
            }
            
            if let hotel_name = place.name {
                hotelName = hotel_name
            }
            hotelNametxt.text = place.formattedAddress
        }*/
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension PlanTripViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == courseTableView {
            return groupArr.count
        }
        return expenseArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == courseTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "groupcell") {
                cell.textLabel?.text = groupArr[indexPath.row].groupName
                cell.detailTextLabel?.text = groupArr[indexPath.row].groupDesc
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.imageView?.sd_setImage(with: URL(string: groupArr[indexPath.row].groupImage), placeholderImage: UIImage(named: "Bed"))
                
                /*if selectedCourses.contains(courseArr[indexPath.row].courseId) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }*/
                return cell
            }
        } else if tableView == tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "expensecell") as? ExpenceTableViewCell {
                cell.hotelName.text = expenseArr[indexPath.row].expenseType
                cell.expenseAmount.text = expenseArr[indexPath.row].expenseAmount
                cell.travelDate.text = expenseArr[indexPath.row].expenseDate
                cell.receiptBtn.tag = indexPath.row
                cell.receiptBtn.setBackgroundImage(UIImage(named: "attachmentIcon"), for: .normal)
                cell.receiptBtn.addTarget(self, action:#selector(self.openReceipt), for: .touchUpInside)
                if expenseArr[indexPath.row].receiptPath != "" {
                    cell.receiptBtn.isHidden = false
                } else {
                    cell.receiptBtn.isHidden = true
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func openReceipt(sender: UIButton) {
        let expObj = expenseArr[sender.tag]
        if expObj.receiptPath != "", let vc = storyboard?.instantiateViewController(withIdentifier: "receiptvc") as? ReceiptViewController {
            let expObj = expenseArr[sender.tag]
            vc.imagePath = expObj.receiptPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*let courseId = courseArr[indexPath.row].courseId
        if selectedCourses.contains(courseId), let index = selectedCourses.index(of: courseId) {
            selectedCourses.remove(at: index)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            selectedCourses.append(courseId)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }*/
        if tableView == self.tableView {
            let expObj = expenseArr[indexPath.row]
            self.expenseName.text = expObj.expenseName
            self.expenseTypeTxt.text = expObj.expenseType
            self.expenseAmountTxt.text = expObj.expenseAmount
            self.expenseDate.text = expObj.expenseDate
            self.expenseID = expObj.expenseId
        } else  if tableView == courseTableView {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LecturesAvailableVc") as? LecturesAvailableVc {
                let dataDictHotel: [String:Any] = ["HotelId":hotelID,"HotelName": hotelName,"HotelAddress":hotelName,"HotelLatitude": hotelCurrentLat.toString() ,"HotelLongitude":hotelCurrentLong.toString(), "HotelPhone": hotelPhoneNumber, "HotelWebsite": hotelwebsite]
                vc.GethotelDict = dataDictHotel
                vc.getGroupId = self.groupArr[indexPath.row].groupId
                vc.shouldShowBuyBtn = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableView {
           return 62.0
        } else  if tableView == courseTableView {
            return 44.0
        }
        return 44.0
    }
    
   @IBAction func addCourses(_ sender: Any) {
        let tripID = self.currentTripId
        ActivityIndicator.shared.show(self.view)
        let dic = ["trip_id": tripID, "course_id": selectedCourses.joined(separator:",")]
        DataManager.postAPIWithParameters(urlString: API.addCourse , jsonString: dic as [String : AnyObject], success: {
            success in
            ActivityIndicator.shared.hide()
            self.moveToExpense()
        }, failure: {
            failure in
            ActivityIndicator.shared.hide()
            self.moveToExpense()
            print(failure)
        })
    }
    
    func moveToExpense() {
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                self?.tipNameView.isHidden = true
                self?.courseView.isHidden = true
                self?.expenseScrollView.isHidden = false
                self?.segmentView.selectedSegmentIndex = 2
                self?.nextBtn.isHidden = true
            })
        }
    }
}
