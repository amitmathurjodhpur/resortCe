//
//  SignUpVC.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 2/2/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManager

class SignUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraAction: UIButton!
    @IBOutlet weak var cancelAction: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        //0.45 * cancelAction.bounds.size.width //
        cancelAction.layer.cornerRadius = 0.5 * cancelAction.bounds.size.width //min(cancelAction.frame.size.height, cancelAction.frame.size.width) / 2.0
        cancelAction.clipsToBounds = true
        imagePicker.delegate = self
        mobileTxt.delegate = self
        emailTxt.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if firstNameTxt.text! == "" || lastNameTxt.text! == "" || emailTxt.text! == "" || mobileTxt.text == "" || passwordTxt.text == "" {
            let alert = UIAlertController(title: "MESSAGE", message: "All fields are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.signUpCall()
        }
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func signUpCall() {
         ActivityIndicator.shared.show(self.view)
        if let firstName = firstNameTxt.text, let lastName = lastNameTxt.text, let mobileNo = mobileTxt.text, let emailId = emailTxt.text, let password = passwordTxt.text {
            let dic = ["firstname":firstName ,"lastname":lastName, "email":emailId ,"password":password, "phone":mobileNo]
            DataManager.postAPIWithParameters(urlString: API.signUp , jsonString: dic as [String : AnyObject], success: { success in
                ActivityIndicator.shared.hide()
                if let response = success as? Dictionary<String, String>, let message = response["message"] {
                    let alert = UIAlertController(title: "ResortCe", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.backAction(UIButton())
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }, failure: {
                failure in
                ActivityIndicator.shared.hide()
                print(failure)
            })
        }
    }
    
    @IBAction func profileImageAction(_ sender: Any) {
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mobileTxt {
            if mobileTxt.text == "" {
                UIAlertController.show(self, "Mobile No", "Fill Valid Phone Number")
            }
        } else if textField == emailTxt, let email = emailTxt.text {
            if isValidEmail(testStr: email) {
                print("valid")
            } else {
                UIAlertController.show(self, "Email", "Enter valid Email")
            }
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
