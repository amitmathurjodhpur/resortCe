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
            let dic = ["trip_id": currentTripId ,"expensis_name": nameText, "expensis_date": startDate, "expensis_type": expType, "expensis_amount":expAmount]
            if let currImage = currentImage, let imageData = UIImageJPEGRepresentation(currImage, 0.5) as NSData? {
                DataManager.postMultipartDataWithParameters(urlString: API.addTripExpenses, imageData: ["expensis_image": imageData] as [String : Data], params: dic as [String : AnyObject], success: {
                    success in
                    ActivityIndicator.shared.hide()
                    if type == "1" || type == "2" {
                        self.moveToTrips()
                    } else if type == "3" {
                        self.expenseName.text = ""
                        self.expenseTypeTxt.text = ""
                        self.expenseAmountTxt.text = ""
                        self.expenseDate.text = ""
                        self.currentImage = nil
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
                        self.expenseName.text = ""
                        self.expenseTypeTxt.text = ""
                        self.expenseAmountTxt.text = ""
                        self.expenseDate.text = ""
                        self.currentImage = nil
                    }
                }, failure: {
                    failure in
                    ActivityIndicator.shared.hide()
                    print(failure)
                })
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
                self?.addExpenseView.isHidden = true
                self?.segmentView.selectedSegmentIndex = 0
            })
        }
    }
    
    func moveToTrips() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "triptrackervc") as? TripTrackerViewController
        vc?.shouldShowCurrent = true
        vc?.showTripsOnly = true
        self.navigationController?.pushViewController(vc!, animated: true)
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
        hotelID = ""
        hotelName = ""
        currentTripId = ""
        currentImage = nil
        courseArr.removeAll()
        selectedCourses.removeAll()
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

