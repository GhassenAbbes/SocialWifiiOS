//
//  ViewController.swift
//  googlMapTutuorial2
//
//  Created by Muskan on 12/17/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation
import Floaty

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class ViewController2: UIViewController, UITextFieldDelegate{
   
    
    @IBOutlet weak var mapView: GMSMapView!
    var currentlocation:CLLocation?
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    var previewDemoData = [Wifi]()
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.title = "Home"
        self.view.backgroundColor = UIColor.white
        
        
       
//        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
//
        setupViews()
        LoadLocations()

     
       
//        initGoogleMaps()
//        
//        txtFieldSearch.delegate=self
    }
    func showMarker(){
        for w in previewDemoData{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(w.lat)!, longitude: Double(w.lng)!)
            marker.title = w.desc_loc
            marker.snippet = w.wifi_pass
            marker.map = mapView
        }
    }
    
        ///Alamofire
        func LoadLocations(){
            //Alamofire
            Alamofire.request("http://41.226.11.243:10080/socialwifi/android/services.php?action=selectloc").responseJSON{ response in
    
            if let locationsJSON = response.result.value {
            //let locationArray:Dictionary = locationsJSON as! Dictionary<String,Any>
                let json =  locationsJSON as! NSArray
                for locationOBJECT in json{
    
    
                    let Slocation = locationOBJECT as! Dictionary<String, Any>
                    let slat = Slocation["lat"] as! String
                    let slng = Slocation["lng"] as! String
                    let wifi_pass = Slocation["wifi_pass"] as! String
                    let desc_loc = Slocation["desc_loc"] as! String
                    let img = Slocation["img"] as! String
                    let MAC = Slocation["MAC"] as Any
                    let id = Int(Slocation["id_loc"] as! String)
                    print(id)
                    let w = Wifi(id_loc: id!, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC)
                    
                    self.previewDemoData.append(w)

                    print("hhhh")
                }
                print(self.previewDemoData)
                self.showMarker()
            }
         }
        }
    
   
//    func initGoogleMaps() {
//        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
//        self.mapView.camera = camera
//        self.mapView.delegate = self
//        self.mapView.isMyLocationEnabled = true
//    }

    // MARK: CLLocation Manager Delegate

    

    // MARK: GOOGLE MAP DELEGATE
    

    func showPartyMarkers(lat: Double, long: Double) {
        mapView.clear()
        for i in 0..<3 {
            let randNum=Double(arc4random_uniform(30))/10000
            let marker=GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: #imageLiteral(resourceName: "restaurant1") , borderColor: UIColor.darkGray, tag: i)
            marker.iconView=customMarker
            let randInt = arc4random_uniform(4)
            if randInt == 0 {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long-randNum)
            } else if randInt == 1 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long+randNum)
            } else if randInt == 2 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long-randNum)
            } else {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long+randNum)
            }
            marker.map = self.mapView
        }
    }

    @objc func btnMyLocationAction() {
        let location: CLLocation? = mapView.myLocation
        if location != nil {
            mapView.animate(toLocation: (location?.coordinate)!)
        }
    }

    @objc func restaurantTapped(tag: Int) {
//        let v=DetailsVC()
//        v.passedData = previewDemoData[tag]
//        self.navigationController?.pushViewController(v, animated: true)
    }

    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }

 

//    let myMapView: GMSMapView = {
//        let v=GMSMapView()
//        v.translatesAutoresizingMaskIntoConstraints=false
//        return v
//    }()

    func setupViews() {
        let camera = GMSCameraPosition.camera(withLatitude: 36.086449, longitude: 10.294640, zoom: 6.0)
        
        //self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.camera = camera
        self.mapView.delegate=self
       // self.mapView.settings.myLocationButton=true
        self.mapView.isMyLocationEnabled=true
        view.addSubview(self.mapView)
        self.mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        self.mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        self.mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        self.mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        
       // self.view.addSubview(floaty)
        
//        self.view.addSubview(floaty)
//        floaty.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
//        floaty.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
//        floaty.widthAnchor.constraint(equalToConstant: 50).isActive=true
//        floaty.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
//
      
        self.view.addSubview(btnAdd)
        btnAdd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnAdd.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnAdd.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnAdd.heightAnchor.constraint(equalTo: btnAdd.widthAnchor).isActive=true
    }
    
//    let txtFieldSearch: UITextField = {
//        let tf=UITextField()
//        tf.borderStyle = .roundedRect
//        tf.backgroundColor = .white
//        tf.layer.borderColor = UIColor.darkGray.cgColor
//        tf.placeholder="Search for a location"
//        tf.translatesAutoresizingMaskIntoConstraints=false
//        return tf
//    }()

    
    let btnAdd: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(AddTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    var locationPreviewView: LocationPreviewView = {
        let v=LocationPreviewView()
        return v
    }()
    
    @objc func AddTapped() {
        let v=AddPopupViewController()
        v.lat=String(describing: currentlocation?.coordinate.latitude)
        v.lng=String(describing: currentlocation?.coordinate.longitude)
        print("save tapped")
        //self.navigationController?.pushViewController(v, animated: true)
        let sb = UIStoryboard(name: "AddPopupControllerView", bundle: nil)
        let popup = sb.instantiateInitialViewController()!
        self.present(popup, animated: true)
    }
}

  extension ViewController2: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }


    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = previewDemoData[customMarkerView.tag]
        locationPreviewView.setData(title: data.desc_loc, price: data.wifi_pass)
        return locationPreviewView
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        restaurantTapped(tag: tag)
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
}

extension ViewController2: CLLocationManagerDelegate {
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
        print("locations = \(location?.latitude) \(location?.longitude)")
        let lat = (location?.latitude)!
        let long = (location?.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.mapView.animate(to: camera)
        
        //showPartyMarkers(lat: lat, long: long)
    }
}


