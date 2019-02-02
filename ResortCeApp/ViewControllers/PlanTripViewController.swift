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
     @IBOutlet weak var segmentView: UISegmentedControl!
     @IBOutlet weak var endDatetxt: UITextField!
     @IBOutlet weak var startDatetxt: UITextField!
     @IBOutlet weak var hotelNametxt: UITextField!
     @IBOutlet weak var tipNameTxt: UITextField!
     @IBOutlet weak var courseTableView: UITableView!
     @IBOutlet weak var expenseName: UITextField!
     @IBOutlet weak var expenseTypeTxt: UITextField!
    
    @IBOutlet weak var expenseAmountTxt: UITextField!
    @IBOutlet weak var expenseDate: UITextField!
    
    let datePicker = UIDatePicker()
    var locationManager = CLLocationManager()
    var tableDataSource: GMSAutocompleteTableDataSource?
    var userCurrentLat = 0.0
    var userCurrentLong = 0.0
    var imagePicker = UIImagePickerController()
    var hotelCurrentLat = 0.0
    var hotelCurrentLong = 0.0
    var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Resortcee"
        
        self.tipNameView.isHidden = false
        self.courseView.isHidden = true
        self.addExpenseView.isHidden = true
        self.segmentView.selectedSegmentIndex = 0
        
        getCurrentLocation()
        hotelNametxt.delegate = self
        endDatetxt.delegate = self
        startDatetxt.delegate = self
        expenseDate.delegate = self
    }

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
    
    @IBAction func nextClick(_ sender: Any) {
        if let tipText = tipNameTxt.text, !tipText.isEmpty, let hotelName = hotelNametxt.text, !hotelName.isEmpty, let startDate = startDatetxt.text, !startDate.isEmpty, let endDate = endDatetxt.text, !endDate.isEmpty {
            self.view.endEditing(true)
            UIView.transition(with: view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
                self?.tipNameView.isHidden = true
                self?.courseView.isHidden = false
                self?.addExpenseView.isHidden = true
                self?.segmentView.selectedSegmentIndex = 1
            })
        } else {
            UIAlertController.show(self, "Error", "All Fields are mandatory")
        }
    }

    //MARK: - Location Manager
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
        datePicker.minimumDate = NSDate() as Date
        //ToolBar
        let toolbar = UIToolbar();
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
         } else if textField == endDatetxt {
            type = 2
         } else if textField == expenseDate {
            type = 3
        }
        self.datePickerVw()
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
        let coordinate1 = CLLocation(latitude: userCurrentLat, longitude:userCurrentLong)
        let coordinate2 = CLLocation(latitude: hotelCurrentLat, longitude: hotelCurrentLong)
        
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        // 50 miles = 80467.2 meter
        if(distanceInMeters <= 80467.2) {
            // under 1 mile
            print("In 50 miles")
            hotelNametxt.text = place.formattedAddress
        } else {
             print("out of 50 miles")
            hotelNametxt.text = ""
            UIAlertController.show(self, "Error", "All Trips must be 50 miles from your home.")
        }

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
extension PlanTripViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "coursecell") {
            cell.textLabel?.text = "iOS Swift"
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        UIView.transition(with: view, duration: 0.5, options: .preferredFramesPerSecond60, animations: {[weak self] in
            self?.tipNameView.isHidden = true
            self?.courseView.isHidden = true
            self?.addExpenseView.isHidden = false
            self?.segmentView.selectedSegmentIndex = 2
        })
    }
}