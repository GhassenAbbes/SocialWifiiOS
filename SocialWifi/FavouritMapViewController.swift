//
//  FavouritMapViewController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/10/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation
//import Floaty
import Toast_Swift
import GooglePlaces

class FavouritMapViewController: UIViewController {

    @IBOutlet weak var viewformap: UIView!
    
    @IBOutlet weak var mapView: GMSMapView!
    var currentlocation:CLLocation?
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    var desc_loc :String?
    var wifi_pass :String?
    var lat :String?
    var lng :String?
    var img :String?
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //   self.title = "Home"
        //self.view.backgroundColor = UIColor.white
        
        
        
        //
        mapView.settings.allowScrollGesturesDuringRotateOrZoom=true
        mapView.settings.myLocationButton=true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        //
        setupViews()
      
        var style = ToastStyle()
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        
        
        //        initGoogleMaps()
        //
        //        txtFieldSearch.delegate=self
    }
    func showMarker(){
       
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image:#imageLiteral(resourceName: "freewifi"), borderColor: UIColor.darkGray, tag: 0)
            marker.iconView=customMarker
        marker.position = CLLocationCoordinate2D(latitude: Double(self.lat! )!, longitude: Double(self.lng!)!)
        marker.title = self.desc_loc
        marker.snippet = self.wifi_pass
            marker.map = mapView
       
    }
    
   
    
    
    var locationPreviewView: LocationPreviewView = {
        let v=LocationPreviewView()
        return v
    }()
    
    @objc func locationTapped(pos: CLLocationCoordinate2D) {
     
        print("marker info window tapped \(pos)")
        if (currentlocation != nil){
            self.drawPath(startLocation: currentlocation!, endLocation: CLLocation(latitude: pos.latitude, longitude: pos.longitude))
        }else{
            self.view.makeToast("You need your GPS ON to get directions!")
            
        }
    }

    
    func setupViews() {
        let camera = GMSCameraPosition.camera(withLatitude:  Double(self.lat! )!, longitude: Double(self.lng!)!, zoom:15)
        
        //self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.camera = camera
        self.mapView.delegate=self
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // self.mapView.settings.myLocationButton=true
        self.mapView.isMyLocationEnabled=true
        self.viewformap.addSubview(self.mapView)
        showMarker()
        
        locationPreviewView = LocationPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        
       
    }
   
    
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "toAddViewControllerSegue" {
    //            let popup = segue.destination as! AddPopupViewController
    //            popup.lat=String(describing: self.currentlocation?.coordinate.latitude)
    //            popup.lng=String(describing: self.currentlocation?.coordinate.longitude)
    //        }
    //    }
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath (startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        print (origin)
        print (destination)
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON  { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let optjson = try? JSON(data: response.data!)
            guard let json = optjson else {
                return
            }
            let routes = json["routes"].arrayValue
            if routes.count>0 {
                // print route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.mapView
                }
            }else {
                self.view.makeToast("No direction available 😞")
                
            }
            
        }
    }
}

// maps functions
extension FavouritMapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        //guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
       
        locationPreviewView.setData(title: self.desc_loc!,img: self.img! ,price: self.wifi_pass!)
        
        
        return locationPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        marker.tracksInfoWindowChanges = true
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        _ = customMarkerView.tag
        locationTapped(pos: marker.position)
        //self.drawPath(startLocation: currentlocation, endLocation: marker.)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
}



//location functions
extension FavouritMapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last?.coordinate
        self.currentlocation=locations.last
        print("locations = \(String(describing: location?.latitude)) \(String(describing: location?.longitude))")
//        let lat = (location?.latitude)!
//        let long = (location?.longitude)!
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
//        
//        self.mapView.animate(to: camera)
        
        //showPartyMarkers(lat: lat, long: long)
    }
}
