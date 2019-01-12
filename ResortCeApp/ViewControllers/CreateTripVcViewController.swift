//
//  CreateTripVcViewController.swift
//  ResortCeApp
//
//  Created by AJ12 on 14/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
class CellCreateTrip : UICollectionViewCell
{
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblLine: UILabel!
}
class CreateTripVcViewController: UIViewController {
    var TripArray = ["Trip Name","Select Course","Add Expenses"]
    var selectedIndex = 0
    var datePicker = UIDatePicker()
    var picker = UIPickerView()
    var ImageVwAttachment = UIImageView()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var CollVwAddTrip: UICollectionView!
     var TotalCourseIds : [String] = []
     var ExpensesTypes : [String] = ["Travel","Meals","Lodging","Others"]
     var ExpensesAmounts : [String] = ["0","0","0","0"]
    var nameArray : [[String:Any]] = []
    var GetDetailTrip :[String:Any] = [:]
    
    @IBOutlet weak var LblHeadingTitle: UILabel!
    
    @IBOutlet weak var BtnNext1: UIButton!
    @IBOutlet weak var BtnNext2: UIButton!
    @IBOutlet weak var Btnsave: UIButton!
    @IBOutlet weak var BtnsaveAndAddNew: UIButton!
    
    //Select Course Outlets
    @IBOutlet var VwSelectCourse: UIView!
    @IBOutlet weak var selectCourseTF1: UITextField!
    @IBOutlet weak var SelectCourseTf2: UITextField!
    @IBOutlet weak var AddMoreCoursesTF: UITextField!
    
    // Add Trips Outlets
    @IBOutlet var VwAddTrip: UIView!
    @IBOutlet weak var DateTF: UITextField!
    @IBOutlet weak var EndDateTF: UITextField!
    @IBOutlet weak var NameTripTF: UITextField!
    var TripDateInStamp = ""
    var TripEndDateInStamp = ""
    
    //Add Expenses Outlets
    @IBOutlet var VwAddExpenses: UIView!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var DateExpensesTF: UITextField!
    @IBOutlet weak var AttachmentTF: UITextField!
    
     @IBOutlet weak var TypeOfExpensis: UITextField!
     @IBOutlet weak var ExpenseAmountTF: UITextField!
     var ExpensesDateInStamp = ""
     var TripId = ""
    
    @IBOutlet weak var ParentVw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCourseTF1.delegate = self
        SelectCourseTf2.delegate = self
        TypeOfExpensis.delegate = self
        ExpenseAmountTF.delegate = self
        DispatchQueue.main.async {
            self.VwAddTrip.frame = CGRect(x: 0, y: 0, width: self.ParentVw.frame.width, height: self.ParentVw.frame.height)
            self.ParentVw.addSubview(self.VwAddTrip)
        }
        self.PostCourseListing()
            LblHeadingTitle.text = "Create a Trip"
            BtnNext1.isHidden = false
            BtnNext2.isHidden = false
        
        
        
    }
    func FillData()
    {
        TripArray = ["Trip Name","Selected Course","Added Expenses"]
        NameTripTF.text = GetDetailTrip["trip_name"] as? String
        DateTF.text = dateConvert((GetDetailTrip["trip_date"] as? String)!)
        DateExpensesTF.text = dateConvert((GetDetailTrip["expensis_date"] as? String)!)
        NameTF.text = GetDetailTrip["trip_name"] as? String
      //  let FullExpenses = GetDetailTrip["expensis_amount"] as! String
//        let fullArrExp = FullExpenses.components(separatedBy: ",")
//        let travelExpenses    = fullArrExp[0]
//        let MealsExpenses = fullArrExp[1]
//        let LodgingExpenses = fullArrExp[2]
//        let OtherExpenses = fullArrExp[3]
        
        LblHeadingTitle.text = "Trip Details"
        BtnNext1.isHidden = true
        BtnNext2.isHidden = true
        Btnsave.isHidden = true
        let image = GetDetailTrip["image"] as? String
        if image != nil{
          ImageVwAttachment.sd_setImage(with: URL(string: image!), placeholderImage: #imageLiteral(resourceName: "Bed"))
        }
        AttachmentTF.text = GetDetailTrip["image"] as? String
        CollVwAddTrip.reloadData()
    }
    func dateConvert(_ TimeStamp:String) -> String
    {
        let unixTimestamp = TimeStamp
        let date = Date(timeIntervalSince1970: Double(unixTimestamp as! String)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
        
    }
    
    // date Picker
    func datePickerVw(_ sender: UITextField)
    {
        datePicker.datePickerMode = .date
       // datePicker.maximumDate = NSDate() as Date
      //  datePicker.timeZone = NSTimeZone() as TimeZone
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
       sender.inputAccessoryView = toolbar
       sender.inputView = datePicker
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        if DateTF.isEditing == true
        {
            DateTF.text = formatter.string(from: datePicker.date)
            let somedate = datePicker.date
            TripDateInStamp = String(somedate.timeIntervalSince1970)
            
        }else if EndDateTF.isEditing == true
        {
            EndDateTF.text = formatter.string(from: datePicker.date)
            let somedate = datePicker.date
            TripEndDateInStamp = String(somedate.timeIntervalSince1970)
        }
        else
        {
            DateExpensesTF.text = formatter.string(from: datePicker.date)
            let somedate = datePicker.date
            ExpensesDateInStamp = String(somedate.timeIntervalSince1970)
        }
       
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    // PickerView
    func pickerVw(_ sender: UITextField)
    {
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
    @objc func donePicker()
    {
        self.view.endEditing(true)
    }
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ActnNext1(_ sender: Any)
    {
        if NameTripTF.text == ""
        {
            UIAlertController.show(self, "Trip Name", "Please Enter Trip Name")
        }else if DateTF.text == ""
        {
             UIAlertController.show(self, "Trip Start Date", "Please Enter Trip Date")
        }else if EndDateTF.text == ""
        {
             UIAlertController.show(self, "Trip End Date", "Please Enter Trip Date")
        }
        else
        {
        self.VwAddTrip.removeFromSuperview()
        self.VwAddExpenses.removeFromSuperview()
        self.VwSelectCourse.frame = CGRect(x: 0, y: 0, width: ParentVw.frame.width, height: self.ParentVw.frame.height)
        self.ParentVw.addSubview(VwSelectCourse)
        selectedIndex = 1
        CollVwAddTrip.reloadData()
        }
    }
    @IBAction func ActnNext2(_ sender: Any)
    {
        if selectCourseTF1.text == "" && SelectCourseTf2.text == ""
        {
             UIAlertController.show(self, "Course", "Please Select a Course")
        }else
        {
          PostAddTrip()
        }
    }
    @IBAction func ActnSaveAddNext(_ sender: Any)
    {
       self.PostAddExpenses("0")
    }
    @IBAction func ActnSave(_ sender: Any)
    {
       self.PostAddExpenses("1")
    }
    
    
    //Web Services
    
    func PostAddTrip()
    {
        let joined = TotalCourseIds.joined(separator: ",")
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.AddTrip, jsonString: Request.AddTrip(UserDefaults.standard.value(forKey: "authKey") as! String, NameTripTF.text!,TripDateInStamp,TripEndDateInStamp,joined) as [String : AnyObject], success: {
            success in
            ActivityIndicator.shared.hide()
            let body = success["body"] as! [String:Any]
            self.TripId = body["id"] as! String
            self.VwAddTrip.removeFromSuperview()
            self.VwSelectCourse.removeFromSuperview()
            self.VwAddExpenses.frame = CGRect(x: 0, y: 0, width: self.ParentVw.frame.width, height: self.ParentVw.frame.height)
            self.ParentVw.addSubview(self.VwAddExpenses)
            self.selectedIndex = 2
            self.CollVwAddTrip.reloadData()
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    func PostAddExpenses(_ id: String)
    {
        ActivityIndicator.shared.show(self.view)
        let data : NSData = UIImageJPEGRepresentation(self.ImageVwAttachment.image!, 0.5)! as NSData
        DataManager.postMultipartDataWithParameters(urlString: API.AddExpenses, imageData: ["image": data] as [String : Data], params: Request.AddExpenses(UserDefaults.standard.value(forKey: "authKey") as! String, TripId,NameTF.text!,ExpensesDateInStamp,TypeOfExpensis.text!, ExpenseAmountTF.text!) as [String : AnyObject], success: {
            success in
            ActivityIndicator.shared.hide()
            if id == "1"
            {
                self.navigationController?.popViewController(animated: true)
            }else
            {
                self.NameTF.text = ""
                self.DateExpensesTF.text = ""
                self.ExpensesDateInStamp = ""
                self.TypeOfExpensis.text = ""
                self.ExpenseAmountTF.text = ""
                UIAlertController.show(self, "Expenses", "Added Successfully Add More")
            }
            
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
        
    }
    
    func PostCourseListing() {
        
        DataManager.postAPIWithParameters(urlString: API.LockerCourseListing , jsonString: Request.setauthKey((UserDefaults.standard.value(forKey: "authKey") as? String)!) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.nameArray = (sucess["body"] as? [[String:Any]])!
            self.picker.reloadAllComponents()
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    
     func ActnImagePickerCamera(_ sender: Any)
    {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CreateTripVcViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCreateTrip", for: indexPath) as! CellCreateTrip
        cell.lbltitle.text = TripArray[indexPath.item]
        if selectedIndex == indexPath.item
        {
            cell.lblLine.isHidden = false
        }else
        {
            cell.lblLine.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if indexPath.item == 0
        {
            self.VwSelectCourse.removeFromSuperview()
            self.VwAddExpenses.removeFromSuperview()
            self.VwAddTrip.frame = CGRect(x: 0, y: 0, width: ParentVw.frame.width, height: self.ParentVw.frame.height)
            selectedIndex = indexPath.item
            self.ParentVw.addSubview(VwAddTrip)
        }else if indexPath.item == 1
        {
           self.ActnNext1(self)
        }
        else
        {
             self.ActnNext2(self)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
    }
}
extension CreateTripVcViewController : UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == DateTF || textField == DateExpensesTF || textField == EndDateTF
        {
            self.datePickerVw(textField)
        }
        else if textField == selectCourseTF1 || textField == SelectCourseTf2
        {
            if nameArray.count > 0
            {
            picker.reloadAllComponents()
            self.pickerVw(textField)
            }else{
                UIAlertController.show(self, "Courses", "No Completed Courses Yet")
            }
        }else if  textField == TypeOfExpensis
        {
            picker.reloadAllComponents()
            self.pickerVw(textField)
            
        }else if textField == AttachmentTF
        {
            AttachmentTF.resignFirstResponder()
            ActnImagePickerCamera(self)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
}
extension CreateTripVcViewController : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if TypeOfExpensis.isEditing == true
        {
          return ExpensesTypes.count
        }else
        {
             return nameArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if selectCourseTF1.isEditing == true
        {
            let values = nameArray[row]
            return (values["course_name"] as! String)
        }
        else if SelectCourseTf2.isEditing == true
        {
            let values = nameArray[row]
            return (values["course_name"] as! String)
        }else
        {
            return ExpensesTypes[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if selectCourseTF1.isEditing ==  true
        {
            let values = nameArray[row]
            selectCourseTF1.text = (values["course_name"] as! String)
            TotalCourseIds.insert(values["course_id"] as! String, at: 0)
        }
        else if SelectCourseTf2.isEditing == true
        {
            let values = nameArray[row]
            SelectCourseTf2.text = (values["course_name"] as! String)
            TotalCourseIds.insert(values["course_id"] as! String, at: 1)
        }else if TypeOfExpensis.isEditing == true
        {
            TypeOfExpensis.text = ExpensesTypes[row]
        }
    }
}
extension CreateTripVcViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        ImageVwAttachment.image = image
        AttachmentTF.text = info.description
        AttachmentTF.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
