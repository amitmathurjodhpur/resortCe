//
//  EditTrip.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/08/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit

class EditTrip: UIViewController {
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var DateExpensesTF: UITextField!
    @IBOutlet weak var AttachmentTF: UITextField!
    @IBOutlet weak var TypeOfExpensis: UITextField!
    @IBOutlet weak var ExpenseAmountTF: UITextField!
    @IBOutlet weak var ImageVwAttachment: UIImageView!
     @IBOutlet weak var LblHeading: UILabel!
    
    
    var ExpensesDateInStamp = ""
    var datePicker = UIDatePicker()
    var picker = UIPickerView()
    var imagePicker = UIImagePickerController()
    var ExpensesTypes : [String] = ["Lodging" , "Transportation/Airfare" , "Meals" , "Other"]
    var ExpensesAmounts : [String] = ["0","0","0","0"]
    var tripId = ""
    var ExpenseId = ""
    
    var GetDataTrip = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        TypeOfExpensis.delegate = self
        ExpenseAmountTF.delegate = self
        DateExpensesTF.delegate = self
        AttachmentTF.delegate = self
        if tripId == "" {
            FillData()
         LblHeading.text = "Edit Expense"
        } else {
        LblHeading.text = "Add Expense"
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden  = false
    }
    
    func FillData() {
        tripId = GetDataTrip["trip_id"] as? String ?? ""
        ExpenseId = GetDataTrip["id"] as? String ?? ""
        NameTF.text = GetDataTrip["expensis_name"] as? String
        TypeOfExpensis.text = GetDataTrip["expensis_type"] as? String
        DateExpensesTF.text = GetDataTrip["expensis_date"] as? String ?? ""
        ExpensesDateInStamp = GetDataTrip["expensis_date"] as? String ?? ""
        ExpenseAmountTF.text = GetDataTrip["expensis_amount"] as? String
        let image = GetDataTrip["expensis_image"] as? String
        if let img = image {
           ImageVwAttachment.sd_setImage(with: URL(string: img), placeholderImage: #imageLiteral(resourceName: "Bed"))
        }
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
    // date Picker
    func datePickerVw(_ sender: UITextField) {
        datePicker.datePickerMode = .date
       // datePicker.maximumDate = NSDate() as Date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        sender.inputAccessoryView = toolbar
        sender.inputView = datePicker
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        DateExpensesTF.text = formatter.string(from: datePicker.date)
        let somedate = datePicker.date
        ExpensesDateInStamp = String(somedate.timeIntervalSince1970)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    // PickerView
    func pickerVw(_ sender: UITextField) {
        picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sender.inputView = picker
        sender.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        self.view.endEditing(true)
    }
    
    @IBAction func ActnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActnSaveBtn(_ sender: Any) {
        if GetDataTrip.count > 0 {
            self.postExpense(type: "1")
        } else {
            if NameTF.text == "" {
                UIAlertController.show(self, "Name", "Enter Name")
            } else if DateExpensesTF.text == "" {
                 UIAlertController.show(self, "Date", "Enter Date")
            } else if TypeOfExpensis.text == "" {
                 UIAlertController.show(self, "Type of expense", "Enter Type")
            } else if ExpenseAmountTF.text == "" {
                 UIAlertController.show(self, "Amount", "Enter Amount")
            } else if AttachmentTF.text == "" {
                 UIAlertController.show(self, "Image", "Select Any Image")
            } else {
                self.postExpense(type: "2")
            }
        }
    }
    
    func ActnImagePickerCamera(_ sender: Any) {
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
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"Cancel")
            alertWarning.show()
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ////////////////
   /* func PostEditExpenses() {
        if let imageObj = self.ImageVwAttachment.image, let imageData = UIImageJPEGRepresentation(imageObj, 0.5) as NSData?, let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            let data = imageData
            DataManager.postMultipartDataWithParameters(urlString: API.EditExpenses, imageData: ["image": data] as [String : Data], params: Request.EditExpenses(authKey, ExpenseId,tripId,NameTF.text ?? "",ExpensesDateInStamp,TypeOfExpensis.text ?? "",ExpenseAmountTF.text ?? "") as [String : AnyObject], success: {
                success in
                ActivityIndicator.shared.hide()
                if let navController = self.navigationController {
                    let viewControllers: [UIViewController] = navController.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is LockerVc {
                            navController.popToViewController(aViewController, animated: true)
                        }
                    }
                }
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostAddExpenses() {
         if let imageObj = self.ImageVwAttachment.image, let imageData = UIImageJPEGRepresentation(imageObj, 0.5) as NSData?, let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            let data = imageData
            DataManager.postMultipartDataWithParameters(urlString: API.AddExpenses, imageData: ["image": data] as [String : Data], params: Request.AddExpenses(authKey, tripId,NameTF.text ?? "",ExpensesDateInStamp,TypeOfExpensis.text ?? "", ExpenseAmountTF.text ?? "") as [String : AnyObject], success: {
                success in
                ActivityIndicator.shared.hide()
                if let navController = self.navigationController {
                    let viewControllers: [UIViewController] = navController.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is LockerVc {
                            navController.popToViewController(aViewController, animated: true)
                        }
                    }
                }
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }*/
    
    func postExpense(type: String) {
        if let nameText = NameTF.text, !nameText.isEmpty, let startDate = DateExpensesTF.text, !startDate.isEmpty, let expType = TypeOfExpensis.text, !expType.isEmpty, let expAmount = ExpenseAmountTF.text, !expAmount.isEmpty {
            self.view.endEditing(true)
            ActivityIndicator.shared.show(self.view)
            
            var dic: [String:Any] = [:]
            var urlStr = ""
            if type == "1" {
                dic =  ["trip_id": tripId ,"expensis_name": nameText, "expensis_date": startDate, "expensis_type": expType, "expensis_amount":expAmount, "id": self.ExpenseId]
                urlStr = API.editExpense
            } else {
                dic =  ["trip_id": tripId ,"expensis_name": nameText, "expensis_date": startDate, "expensis_type": expType, "expensis_amount":expAmount]
                urlStr = API.addTripExpenses
            }
            
           print("Dict: \n\(dic)")
            if let currImage = self.ImageVwAttachment.image, let imageData = UIImageJPEGRepresentation(currImage, 0.5) as NSData? {
                DataManager.postMultipartDataWithParameters(urlString: urlStr, imageData: ["expensis_image": imageData] as [String : Data], params: dic as [String : AnyObject], success: {
                    success in
                    print(success)
                    ActivityIndicator.shared.hide()
                    if let navController = self.navigationController {
                        let viewControllers: [UIViewController] = navController.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is LockerVc {
                                navController.popToViewController(aViewController, animated: true)
                            }
                        }
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
                    if let navController = self.navigationController {
                        let viewControllers: [UIViewController] = navController.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is LockerVc {
                                navController.popToViewController(aViewController, animated: true)
                            }
                        }
                    }
                }, failure: {
                    failure in
                    ActivityIndicator.shared.hide()
                    print(failure)
                })
            }
        }
    }
}

extension EditTrip : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return ExpensesTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return ExpensesTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            TypeOfExpensis.text = ExpensesTypes[row]
    }
}
extension EditTrip: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageVwAttachment.image = image
            AttachmentTF.text = info.description
            AttachmentTF.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
      
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TypeOfExpensis {
            self.pickerVw(textField)
        } else if textField == AttachmentTF {
            textField.resignFirstResponder()
            self.ActnImagePickerCamera(self)
        } else if textField == DateExpensesTF {
            self.datePickerVw(textField)
        }
    }
}
