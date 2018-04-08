//
//  ViewController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 3/21/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import UIKit

import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation
import Floaty

class ViewController: UIViewController,CLLocationManagerDelegate , GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var floaty: Floaty!
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    //var mapView : GMSMapView?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ///floaty
//        floaty.addItem(title: "Add WIFI")
//        self.view.addSubview(floaty)
        
        /// Google Maps
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        //loadview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
   
    
     func loadview() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6. ,
        let camera = GMSCameraPosition.camera(withLatitude: 36.086449, longitude: 10.294640, zoom: 6.0)
        //(self.mapView!.frame.size.width), height: (self.mapView!.frame.size.height)), camera: camera)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        //Alamofire
        Alamofire.request("http://41.226.11.243:10080/socialwifi/android/services.php?action=selectloc").responseJSON{ response in
            
            if let locationsJSON = response.result.value {
                //let locationArray:Dictionary = locationsJSON as! Dictionary<String,Any>
                let json =  locationsJSON as! NSArray
                for locationOBJECT in json{
                    
                    
                    let marker = GMSMarker()
                    let Slocation = locationOBJECT as! Dictionary<String, Any>
                    let slat = Slocation["lat"] as! String
                    let slng = Slocation["lng"] as! String
                    
                    marker.position = CLLocationCoordinate2D(latitude: Double(slat)!, longitude: Double(slng)!)
                    marker.title = Slocation["desc_loc"] as? String
                    marker.snippet = Slocation["wifi_pass"] as? String
                    marker.map = mapView
                    print (slat)
                    print("hhhh")
                }
                
            }
        }
        // Creates a marker in the center of the map.
        
    }
    
}

