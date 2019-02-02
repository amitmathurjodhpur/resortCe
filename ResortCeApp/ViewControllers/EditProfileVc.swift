//
//  EditProfileVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SDWebImage
import IQKeyboardManager

protocol NewUserDelegate: class {
    func newUserCompleted()
}

class EditProfileVc: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    @IBOutlet weak var UserImage:   UIImageView!
    @IBOutlet weak var TxtUserName: UITextField!
    @IBOutlet weak var TxtLastNAme: UITextField!
    @IBOutlet weak var TxtProfession: UITextField!
    @IBOutlet weak var TxtDOB: UITextField!
    @IBOutlet weak var TxtAddress: UITextField!
    @IBOutlet weak var TxtMobileNo: UITextField!
    @IBOutlet weak var TxtEmail: UITextField!
     @IBOutlet weak var TxtSecondProfession: UITextField!
     @IBOutlet weak var TxtSpecialIn: UITextField!
     @IBOutlet weak var TxtSpecialInSecond: UITextField!
     @IBOutlet weak var TxtStateOflicensure: UITextField!
     @IBOutlet weak var TxtLicenseNumber: UITextField!
     @IBOutlet weak var TxtNextREnewalData: UITextField!
     @IBOutlet weak var TxtRenewalcycle: UITextField!
    let datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var userCurrentLocation: CLLocationCoordinate2D?
    var searchMapDisplayController: UISearchDisplayController?
    var tableDataSource: GMSAutocompleteTableDataSource?
    var CurrentLati = 0.0
    var CurrentLongi = 0.0
    var ProfessionArray : [[String:Any]] = [[:]]
    var RenewalCyleArray = [String]()
    var RenewalCycleIds = ["1","2","3"]
    var RenewalCyleValueFroAPI = "0"
    weak var newUserDelegate: NewUserDelegate?
    var profid = ""
    var ProfId2 = ""
    let picker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        TxtMobileNo.delegate = self
        TxtEmail.delegate = self
        TxtAddress.delegate = self
        imagePicker.delegate = self
        UserImage.layer.cornerRadius = UserImage.frame.height/2
        self.postUserProfile()
        self.postProfessionListing()
        TxtDOB.isHidden = true
        
            RenewalCyleArray = ["Annually","Every 2 years","Every 3 years"]
    }
    func searchBarBtnPressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        CurrentLati = (location?.latitude)!
        CurrentLongi = (location?.longitude)!
        userCurrentLocation = locationManager.location!.coordinate
    }
   
    //SEARCH LOCATION ON MAP
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func datePickerVw()
    {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = NSDate() as Date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        TxtDOB.inputAccessoryView = toolbar
        TxtDOB.inputView = datePicker
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        TxtDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    func pickerVw(_ sender:UITextField)
    {
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
    @objc func donePicker()
    {
        self.view.endEditing(true)
       
    }
    func postUserProfile() {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.userProfileDetail, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            let user_dict = sucess.value(forKey: "body") as! [String:Any]
            print(user_dict)
            self.TxtEmail.text = (user_dict["email"] as! String)
            self.TxtUserName.text = (user_dict["firstname"] as! String)
            self.TxtMobileNo.text = (user_dict["phone"] as! String)
            self.TxtAddress.text = (user_dict["address"] as! String)
            self.TxtProfession.text = (user_dict["Profession_name"] as! String)
            self.TxtLastNAme.text =  (user_dict["lastname"] as! String)
            
            self.TxtSecondProfession.text = (user_dict["secondary_profession"] as! String)
            self.TxtSpecialInSecond.text = (user_dict["secondary_profession_subspecialty"] as! String)
            self.TxtRenewalcycle.text = (user_dict["renewal_cycle"] as! String)
            self.TxtSpecialIn.text = (user_dict["profession_subspecialty"] as! String)
            self.TxtNextREnewalData.text = (user_dict["next_renewal_date"] as! String)
            self.TxtStateOflicensure.text = (user_dict["license"] as! String)
            self.TxtLicenseNumber.text = (user_dict["license_number"] as! String)
            if UserDefaults.standard.value(forKey: "dob") == nil
           {
            self.TxtDOB.text = ""
           }
            else
           {
            self.TxtDOB.text = (UserDefaults.standard.value(forKey: "dob")  as! String)
            }
            let photo = user_dict["image"] as? String
            self.UserImage.sd_setImage(with: URL(string: photo!), placeholderImage:#imageLiteral(resourceName: "DefaultImage"))
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func postProfessionListing()
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.profession_listing, jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.ProfessionArray  = sucess.value(forKey: "body") as! [[String:Any]]
            print(self.ProfessionArray)
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    
    func postEditUserProfile()
    {
        ActivityIndicator.shared.show(self.view)
        let data : NSData = UIImageJPEGRepresentation(self.UserImage.image!, 0.5)! as NSData
        DataManager.postMultipartDataWithParameters(urlString: API.edituserprofiledetails, imageData: ["image": data] as [String : Data], params: Request.editProfile(UserDefaults.standard.value(forKey: "authKey") as! String, self.TxtUserName.text!, self.TxtEmail.text!, self.TxtMobileNo.text!, self.TxtAddress.text!, self.profid , self.TxtLastNAme.text!,String(CurrentLati),String(CurrentLongi),TxtStateOflicensure.text!,self.ProfId2,TxtSpecialIn.text!,TxtSpecialInSecond.text!,TxtLicenseNumber.text!,TxtNextREnewalData.text!,RenewalCyleValueFroAPI) as [String : AnyObject], success:
            {
                sucess in
                ActivityIndicator.shared.hide()
                let user_dict = sucess.value(forKey: "body") as! [String:Any]
                print(user_dict)
               
             //   UserDefaults.standard.set(self.TxtDOB.text, forKey: "dob")
                User.iswhichUser = ""
                self.newUserDelegate?.newUserCompleted()
                self.navigationController?.popViewController(animated: true)
                UserDefaults.standard.set("0", forKey: "First")
                
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
           
        })
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    @IBAction func ActnImagePickerCamera(_ sender: Any)
    {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        // photoPicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        UserImage.image = imageOrientation(image)
        dismiss(animated: true, completion: nil)
    }
    func openCamera()
    {
 if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"Cancel")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func ActnBack(_ sender: UIButton)
    {
        self.ActnTickBtnSave(sender)
    }
    @IBAction func ActnTickBtnSave(_ sender: UIButton)
    {
        if TxtProfession.text! == "" || TxtUserName.text! == "" || TxtAddress.text! == "" || TxtMobileNo.text == "" || TxtEmail.text! == ""
        {
            let alert = UIAlertController(title: "MESSAGE", message: "All fields are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            User.iswhichUser = "0"
            self.postEditUserProfile()
        }
    }
    
    
}
extension EditProfileVc :UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if picker.tag == 0 || picker.tag == 1
        {
        return ProfessionArray.count
        }else
        {
            return RenewalCyleArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if picker.tag == 0 || picker.tag == 1
        {
        let value = ProfessionArray[row]
        return (value["name"] as? String)
        }else
        {
            return RenewalCyleArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if picker.tag == 0
        {
        let value = ProfessionArray[row]
        profid = value["id"] as! String
        TxtProfession.text = (value["name"] as! String)
        }else if picker.tag == 1
        {
            let value = ProfessionArray[row]
            ProfId2 = value["id"] as! String
            TxtSecondProfession.text = (value["name"] as! String)
        }else
        {
            TxtRenewalcycle.text = RenewalCyleArray[row]
            RenewalCyleValueFroAPI = RenewalCycleIds[row]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == TxtProfession
        {
            picker.tag = 0
            self.pickerVw(textField)
        }else if textField == TxtDOB
        {
              self.datePickerVw()
        }else if textField == TxtAddress
        {
            searchBarBtnPressed(self)
        }else if textField == TxtSecondProfession
        {
           picker.tag = 1
           self.pickerVw(textField)
        }else if textField == TxtRenewalcycle {
            picker.tag = 2
            self.pickerVw(textField)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == TxtMobileNo
        {
            if TxtMobileNo.text == ""
            {
                
                UIAlertController.show(self, "Mobile No", "Fill Valid Phone Number")
            }
        }else if textField == TxtEmail
            {
                if isValidEmail(testStr: TxtEmail.text!)
                {
                  print("valid")
                }
                else
                {
                    UIAlertController.show(self, "Email", "Enter valid Email")
                }
            }
    }
}

//MARK: - Address Picker Extension
extension EditProfileVc: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(place)
        userCurrentLocation = place.coordinate
        TxtAddress.text = place.formattedAddress
        CurrentLati = place.coordinate.latitude
        CurrentLongi = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
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
