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
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewAction(_ sender: Any) {
    }
    
    @IBAction func skipAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
       // let image = info[UIImagePickerControllerOriginalImage] as! UIImage
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
}
