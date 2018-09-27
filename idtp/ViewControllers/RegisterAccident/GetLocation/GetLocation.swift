//
//  GetLocation.swift
//  idtp
//
//  Created by Apple on 08.08.17.
//  Copyright © 2017 galley-mobile. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import SVProgressHUD

class GetLocation: UIViewController, CLLocationManagerDelegate, YMKMapViewDelegate {
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var labelAddress: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: UInt = 15
    
    var getLocationDataTask : URLSessionDataTask?
    
    var editingAccident : Accident!
    var currentPlace : Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        setDefaultLocation()
        
        currentPlace = PlaceService.createPlace()
        if editingAccident.place != nil {
            centerMapOnLocation(YMKMapCoordinate(latitude: editingAccident.place!.latitude,
                                                 longitude: editingAccident.place!.longitude))
        } else {
            if (CLLocationManager.locationServicesEnabled()) {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 50
            }
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showTraffic = false
        mapView.accessibilityElementsHidden = false
        
        buttonDone.isEnabled = false
    }
    
    func setDefaultLocation() {
        zoomLevel = 12
        let defaultLocation = YMKMapCoordinateMake(55.802182, 49.105328)
        mapView.setCenter(defaultLocation, atZoomLevel: zoomLevel, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.last!
        locationManager.stopUpdatingLocation()
        
        let location = YMKMapCoordinateMake(userLocation.coordinate.latitude,
                                            userLocation.coordinate.longitude)
        
        centerMapOnLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if editingAccident.place != nil { return }
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
            setDefaultLocation()
        case .restricted:
            print("Restricted")
            setDefaultLocation()
        case .denied:
            print("Denied")
            setDefaultLocation()
        case .authorizedAlways:
            print("AuthorizedAlways")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        }
    }
    
    func centerMapOnLocation(_ location: YMKMapCoordinate) {
        mapView.setCenter(location, atZoomLevel: zoomLevel, animated: true)
    }
    
    func mapView(_ mapView: YMKMapView!, regionWillChangeAnimated animated: Bool) {
        buttonDone.isEnabled = false
    }
    
    func mapView(_ mapView: YMKMapView!, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude,
                                  longitude: mapView.centerCoordinate.longitude)
        setAddressFromLocation(location)
    }
    
    func setAddress(_ address: String?) {
        self.labelAddress.text = address
        self.buttonDone.isEnabled = true
    }
    
    func getResponce(addressName: String, fullAddress: String) {
        self.currentPlace.placeName = addressName
        self.currentPlace.placeFull = fullAddress
        
        DispatchQueue.main.async {
            self.setAddress(addressName)
        }
    }
    
    func setAddressFromLocation(_ location: CLLocation) {
        getLocationDataTask?.cancel()
        
        getLocationDataTask = APIService.shared().geocode(
            longitude: String(location.coordinate.longitude),
            latitude: String(location.coordinate.latitude),
            completionHandler: {
                (responce: (addressName: String?, fullAddress: String?)?, error) in
                
                if let err = error as! APIErrors? {
                    if err != .cancelled {
                        SVProgressHUD.showError(withStatus: error.debugDescription)
                    }
                    return
                }
                
                self.getResponce(addressName: responce!.addressName!,
                            fullAddress: responce!.fullAddress!)
        })
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        if editingAccident.place == nil {
            editingAccident.place = PlaceService.createPlace()
        }
        self.editingAccident.place!.latitude = mapView.centerCoordinate.latitude
        self.editingAccident.place!.longitude = mapView.centerCoordinate.longitude
        self.editingAccident.place!.placeFull = currentPlace.placeFull
        self.editingAccident.place!.placeName = currentPlace.placeName
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
