//
//  LocationsVC.swift
//  ResortCeApp
//
//  Created by AJ12 on 04/06/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
class  CellLocation: UITableViewCell
{
    @IBOutlet weak var imagevw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var TxtsubVw: UITextView!
}


class LocationsVC: UIViewController {
    @IBOutlet var mapView: UIView!
    @IBOutlet var googleMapView: GMSMapView!
    var locationManager = CLLocationManager()
    var userCurrentLocation: CLLocationCoordinate2D?
    let locManager = CLLocationManager()
    var markers = [GMSMarker]()
    @IBOutlet weak var TblVwList: UITableView!
    var lat = 0.0 //30.7046
    var long = 0.0//76.7179
    var currentLat = 0.0
    var currentLong = 0.0
    var nameArray : [[String:Any]] = []
    var LatLongArray : [String] = []
    var titlearray : [String] = []
   
    
    var postGroupId = ""
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        TblVwList.isHidden = true
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        googleMapView.delegate = self
        googleMapCam()

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // web services
    
    func addgroups(lati:Double,longi:Double)
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.getnearbygroups, jsonString: Request.GetNearGroups((UserDefaults.standard.value(forKey: "authKey") as? String)!, String(lati), String(longi)) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.nameArray = (sucess["body"] as? [[String:Any]])!
            self.TblVwList.reloadData()
            self.latlong()
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
    //MARK: - Google Map Camera
    
    func googleMapCam()
     {
        let camera = GMSCameraPosition.camera(withLatitude: 30.7333, longitude: 76.7794, zoom: 13.0)
        self.googleMapView.camera = camera
        googleMapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        googleMapView.delegate = self
        // markerOnMap()
    }
    func markerOnMap(){
        googleMapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (userCurrentLocation?.latitude)!, longitude: (userCurrentLocation?.longitude)!)
        marker.icon = UIImage(named:"map_Location")
        markers.append(marker)
        marker.map = googleMapView
    }
    func markers(lat:Double,Long:Double,name:String)
    {
        //googleMapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude:Long)
        marker.icon = UIImage(named:"map_Location")
        marker.title = name
        markers.append(marker)
        marker.map = googleMapView
    }
    
    


}
extension LocationsVC:CLLocationManagerDelegate,GMSMapViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate
{
    //MARK: - Google Map Delegates
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
        userCurrentLocation = locationManager.location!.coordinate
        googleMapView.isMyLocationEnabled = false
        //markerOnMap()
        
        locationManager.stopUpdatingLocation()
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            self.googleMapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    
    //MARK: - Add Marker On Map
    
    
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
    
    
    //MARK:- SELECT LOCATION ON MAP
    
  //  func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // let index = markers.index(of: marker)
//        let customInfoWindow = Bundle.main.loadNibNamed("CustomeMapInfoView", owner: self, options: nil)?[0] as! CustomeMapInfoView
//        DispatchQueue.main.async
//            {
//                customInfoWindow.frame = CGRect(x: 10, y: 0, width: 100, height: 50)
//        }
//        customInfoWindow.locationNameLbl.text = marker.title
//        return customInfoWindow
   // }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //let index = markers.index(of: marker)
    }
    
}
//MARK: - Address Picker Extension
extension LocationsVC: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        searchDisplayController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
      //  tableDataSource?.sourceTextHasChanged(searchString)
        return false
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // TODO: Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}

//MARK: - Address Picker Extension
extension LocationsVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
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

