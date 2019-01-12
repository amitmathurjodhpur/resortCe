//
//  FindLocationVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class FindLocationVc: UIViewController {
   
    var userCurrentLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    @IBOutlet var googleMapView: GMSMapView!
    
    var lat = 0.0 //30.7046
    var long = 0.0//76.7179
    var currentLat = 0.0
    var currentLong = 0.0
    var nameArray : [[String:Any]] = []
    var postGroupId = ""
    var placesClient: GMSPlacesClient!
    
    let kMapHotelStyle = "[" +
        "{" +
        "\"featureType\": \"poi\"," +
        "\"stylers\": [" +
        "{ \"visibility\": \"off\" }" +
        "]},{" +
        "\"featureType\": \"poi.business\"," +
        "\"stylers\": [" +
        "{ \"visibility\": \"on \" }" +
        "]" +
        "}" +
    "]"
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        googleMapView.delegate = self
        googleMapCam()
    }
    
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func ActnFindLocation(_ sender: Any)
    {
        self.googleMapCam()
    }
   
    @IBAction func ActnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    func googleMapCam()
    {
        let camera = GMSCameraPosition.camera(withLatitude:currentLat, longitude: currentLong, zoom: 15.0)
        self.googleMapView.camera = camera
        googleMapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        googleMapView.delegate = self
        placesClient = GMSPlacesClient.shared()
        do {
            googleMapView.mapStyle = try GMSMapStyle(jsonString: kMapHotelStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    func addgroups(lati:Double,longi:Double,DataDict:[String:Any])
    {
        ActivityIndicator.shared.show(self.view)
        DataManager.postAPIWithParameters(urlString: API.getnearbygroups, jsonString: Request.GetNearGroups((UserDefaults.standard.value(forKey: "authKey") as? String)!, String(lati), String(longi)) as [String : AnyObject], success: {
            sucess in
            ActivityIndicator.shared.hide()
            self.nameArray = (sucess["body"] as? [[String:Any]])!
            let values = self.nameArray[0]
            self.postGroupId = values["id"] as! String
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LecturesAvailableVc") as? LecturesAvailableVc
            vc?.GethotelDict = DataDict
            vc?.getGroupId = self.postGroupId
            self.navigationController?.pushViewController(vc!, animated: true)
        }, failure: {
            fail in
            ActivityIndicator.shared.hide()
        })
    }
   
}
extension FindLocationVc : MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
        userCurrentLocation = locationManager.location!.coordinate
        currentLat = (location?.latitude)!
        currentLong = (location?.longitude)!
        googleMapView.isMyLocationEnabled = false
         locationManager.stopUpdatingLocation()
    }
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            self.googleMapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15.0)
        }
    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D){
        userCurrentLocation = location
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                NSLog("lookup place id query error: \(error.localizedDescription)")
                return
            }
            guard let place = place else {
                NSLog("No place details for \(placeID)")
                return
            }
            if (place.types.contains("lodging"))
            {
                let dataDictHotel :[String:Any] = ["HotelId":place.placeID,"HotelName":place.name,"HotelAddress":place.formattedAddress ?? "","HotelLatitude": place.coordinate.latitude.description ,"HotelLongitude":place.coordinate.longitude.description  ,"HotelPhone":place.phoneNumber ?? "","HotelWebsite":place.website?.absoluteString ?? ""]
                print(dataDictHotel)
                self.addgroups(lati: location.latitude, longi: location.longitude,DataDict: dataDictHotel)
            }
        })
    }
    
}
