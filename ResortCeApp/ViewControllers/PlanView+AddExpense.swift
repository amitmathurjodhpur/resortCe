//
//  PlanView+AddExpense.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 1/13/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import Foundation
import UIKit

/* This Extension is for Add Expense View */
extension PlanTripViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func receiptAction(_ sender: Any) {
       
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        // Add the actions
        // photoPicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
  
    @IBAction func saveAction(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
       self.postExpense(type: "1")
    }
    
    @IBAction func addNewAction(_ sender: Any) {
        self.postExpense(type: "3")
    }
    
    @IBAction func skipAction(_ sender: Any) {
        self.postExpense(type: "2")
    }
    
    func postExpense(type: String) {
        if let nameText = expenseName.text, !nameText.isEmpty, let startDate = expenseDate.text, !startDate.isEmpty, let expType = expenseTypeTxt.text, !expType.isEmpty, let expAmount = expenseAmountTxt.text, !expAmount.isEmpty {
            self.view.endEditing(true)
            ActivityIndicator.shared.show(self.view)
            
            var dic: [String:Any] = [:]
            var urlStr = ""
            if self.isEditMode {
                dic =  ["trip_id": currentTripId ,"expensis_name": nameText, "expensis_date": startDate, "expensis_type": expType, "expensis_amount":expAmount, "id": self.expenseID]
                urlStr = API.editExpense
            } else {
                dic =  ["trip_id": currentTripId ,"expensis_name": nameText, "expensis_date": startDate, "expensis_type": expType, "expensis_amount":expAmount]
                urlStr = API.addTripExpenses
            }
            print("Dict: \n\(dic)")
             if let currImage = currentImage, let imageData = UIImageJPEGRepresentation(currImage, 0.5) as NSData? {
                DataManager.postMultipartDataWithParameters(urlString: urlStr, imageData: ["expensis_image": imageData] as [String : Data], params: dic as [String : AnyObject], success: {
                    success in
                    print(success)
                    ActivityIndicator.shared.hide()
                    if type == "1" || type == "2" {
                        self.moveToTrips()
                    } else if type == "3" {
                        if let imagePath = success["image"] as? String {
                            self.expenseImagePath = imagePath
                        } else {
                            self.expenseImagePath = ""
                        }
                        if self.isEditMode {
                             if let index = self.expenseArr.index(where: {$0.expenseId == self.expenseID}) {
                                self.expenseArr[index].expenseName = nameText
                                self.expenseArr[index].expenseType = expType
                                self.expenseArr[index].expenseAmount = expAmount
                                self.expenseArr[index].expenseDate = startDate
                                self.expenseArr[index].receiptPath = self.expenseImagePath
                            }
                        } else {
                            let expense = Expense.init(expenseId: "", expenseName: self.expenseName.text ?? "", expenseType: self.expenseTypeTxt.text ?? "", expenseAmount: self.expenseAmountTxt.text ?? "", expenseDate: self.expenseDate.text ?? "", receiptPath: self.expenseImagePath)
                            self.expenseArr.append(expense)
                        }
                        self.expenseName.text = ""
                        self.expenseTypeTxt.text = ""
                        self.expenseAmountTxt.text = ""
                        self.expenseDate.text = ""
                        self.expenseImagePath = ""
                        self.currentImage = nil
                        self.expenseID = ""
                        self.viewDidLayoutSubviews()
                    }
                     }, failure: {
                    fail in
                    ActivityIndicator.shared.hide()
                })
            } else {
                print("Dict: \n\(dic)")
                DataManager.postAPIWithParameters(urlString: API.addTripExpenses , jsonString: dic as [String : AnyObject], success: {
                    success in
                    print(success)
                    ActivityIndicator.shared.hide()
                    if type == "1" || type == "2" {
                        self.moveToTrips()
                    } else if type == "3" {
                        if !self.isEditMode {
                            let expense = Expense.init(expenseId: "", expenseName: self.expenseName.text ?? "", expenseType: self.expenseTypeTxt.text ?? "", expenseAmount: self.expenseAmountTxt.text ?? "", expenseDate: self.expenseDate.text ?? "", receiptPath: "")
                            self.expenseArr.append(expense)
                        } else {
                            if let index = self.expenseArr.index(where: {$0.expenseId == self.expenseID}) {
                                self.expenseArr[index].expenseName = nameText
                                self.expenseArr[index].expenseType = expType
                                self.expenseArr[index].expenseAmount = expAmount
                                self.expenseArr[index].expenseDate = startDate
                                self.expenseArr[index].receiptPath = ""
                            }
                        }
                        self.expenseName.text = ""
                        self.expenseTypeTxt.text = ""
                        self.expenseAmountTxt.text = ""
                        self.expenseDate.text = ""
                        self.expenseImagePath = ""
                        self.currentImage = nil
                        self.expenseID = ""
                        self.viewDidLayoutSubviews()
                    }
                }, failure: {
                    failure in
                    ActivityIndicator.shared.hide()
                    print(failure)
                })
            }
        } else {
            if type == "2" {
                self.moveToTrips()
            } else {
                UIAlertController.show(self, "Warning", "Please enter all fields")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        } else  {
            UIAlertController.show(self, "Warning", "You don't have camera")
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func moveToCreatetrip() {
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                self?.clearAll()
                self?.tipNameView.isHidden = false
                self?.courseView.isHidden = true
                self?.expenseScrollView.isHidden = true
                self?.segmentView.selectedSegmentIndex = 0
            })
        }
    }
    
    func moveToTrips() {
        /*let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
        vc?.shouldShowCurrent = true
        vc?.showTripsOnly = true
        self.navigationController?.pushViewController(vc!, animated: true)*/
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                self?.tipNameView.isHidden = true
                self?.courseView.isHidden = false
                self?.expenseScrollView.isHidden = true
                self?.segmentView.selectedSegmentIndex = 2
                self?.nextBtn.isHidden = true
                self?.addgroups()
            })
        }
    }
   
    func clearAll() {
        endDatetxt.text = ""
        startDatetxt.text = ""
        hotelNametxt.text = ""
        tipNameTxt.text = ""
        expenseName.text = ""
        expenseTypeTxt.text = ""
        expenseAmountTxt.text = ""
        expenseDate.text = ""
        hotelCurrentLat = 0.0
        hotelCurrentLong = 0.0
        hotelPhoneNumber = ""
        expenseImagePath = ""
        hotelID = ""
        hotelName = ""
        expenseID = ""
        if isEditMode == false {
            currentTripId = ""
        }
        currentImage = nil
        //courseArr.removeAll()
        groupArr.removeAll()
        selectedCourses.removeAll()
        expenseArr.removeAll()
    }
    
    func addgroups() {
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.getnearbygroups, jsonString: Request.GetNearGroups(authKey, hotelCurrentLat.toString(), hotelCurrentLong.toString(), "50") as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let groups = sucess["body"] as? [[String:Any]], groups.count > 0 {
                    for groupObj in groups {
                        if let course = groupObj as Dictionary<String, AnyObject>?, let groupId = course["id"] as? String, let groupName = course["name"] as? String, let groupAddress = course["address"] as? String, let dt = course["date"] as? String, let groupLat = course["latitude"] as? String, let groupLong = course["longitude"] as? String, let groupImage = course["image"] as? String, let groupDesc = course["description"] as? String {
                             let course = GroupLecture.init(groupId: groupId, groupName: groupName, groupAddress: groupAddress, groupLat: groupLat, groupLong: groupLong, groupDate: dt, groupImage: groupImage, groupDesc: groupDesc)
                            self.groupArr.append(course)
                        }
                    }
                        DispatchQueue.main.async {
                            self.courseTableView.reloadData()
                        }
                }
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
}
extension PlanTripViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.expenseTypeTxt.text = pickerData[row]
    }
}
