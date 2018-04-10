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
//import Floaty
import Toast_Swift
import GooglePlaces

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
    var img : UIImage
}

class MapViewController: UIViewController, UITextFieldDelegate{
    
    
    
    
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
        LoadLocations()
        var style = ToastStyle()
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        
        
        //        initGoogleMaps()
        //
        //        txtFieldSearch.delegate=self
    }
    func showMarker(){
        for i in 0..<self.previewDemoData.count {
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image:#imageLiteral(resourceName: "freewifi"), borderColor: UIColor.darkGray, tag: i)
            marker.iconView=customMarker
            marker.position = CLLocationCoordinate2D(latitude: Double(self.previewDemoData[i].lat)!, longitude: Double(self.previewDemoData[i].lng)!)
            marker.title = self.previewDemoData[i].desc_loc
            marker.snippet = self.previewDemoData[i].wifi_pass
            marker.map = mapView
        }
    }
    
    ///Alamofire
    func LoadLocations(){
        let cm = ConnectionManager(action :"selectloc")
        Alamofire.request(cm.getURL()).responseJSON{ response in
            
            if let locationsJSON = response.result.value {
                //let locationArray:Dictionary = locationsJSON as! Dictionary<String,Any>
                let json =  locationsJSON as! NSArray
                for locationOBJECT in json{
                    
                    print (locationOBJECT)
                    let Slocation = locationOBJECT as! Dictionary<String, Any>
                    let slat = Slocation["lat"] as! String
                    let slng = Slocation["lng"] as! String
                    let wifi_pass = Slocation["wifi_pass"] as! String
                    let desc_loc = Slocation["desc_loc"] as! String
                    let img = Slocation["img"] as! String
                    let MAC = Slocation["MAC"] as Any
                    let id = Slocation["id_loc"] as! String
                    //print(id)
                    let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC)
                    
                    self.previewDemoData.append(w)
                    
                    print("hhhh")
                }
                print(self.previewDemoData)
                self.showMarker()
            }
        }
    }
    
    func AddFav(tag: Int){
        let cm = ConnectionManager(action :"addfavourite&id_user=1828686040530623&id_loc=\(self.previewDemoData[tag].id_loc )")
        let cmcheck = ConnectionManager(action :"checkfav&id_user=1828686040530623&id_loc=\(self.previewDemoData[tag].id_loc )")
        //let url = "http://192.168.1.7/android/services.php?action=addloc&desc=\(self.SSIDText.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=null"
        print ("url = \(cm.getURL())")
        
        
        
        Alamofire.request(cmcheck.getURL()).responseJSON{ response in
            
            if let locationsJSON = response.result.value {
                //let locationArray:Dictionary = locationsJSON as! Dictionary<String,Any>
                let json =  locationsJSON as! NSArray
                if json.count > 0 {
                    self.view.makeToast("this favourite already exists")
                }else{
                    Alamofire.request(cmcheck.getURL()).responseString{ response in
                        print (response.result.isSuccess)
                        if     response.result.isSuccess{
                            self.view.makeToast("the favourite has been added")
                        }else{
                            self.view.makeToast("the favourite couldn't be added :(")
                        }
                        
                    }
                }
                
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
            marker.tracksInfoWindowChanges = true
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
    var locationPreviewView: LocationPreviewView = {
        let v=LocationPreviewView()
        return v
    }()
    @objc func locationTapped(pos: CLLocationCoordinate2D) {
        //        let v=DetailsVC()
        //        v.passedData = previewDemoData[tag]
        //        self.navigationController?.pushViewController(v, animated: true)
        print("marker info window tapped \(pos)")
        if (currentlocation != nil){
            self.drawPath(startLocation: currentlocation!, endLocation: CLLocation(latitude: pos.latitude, longitude: pos.longitude))
        }else{
            self.view.makeToast("You need your GPS ON to get directions!")
            
        }
    }
    
    //    func setupTextField(textField: UITextField, img: UIImage){
    //        textField.leftViewMode = UITextFieldViewMode.always
    //        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
    //        imageView.image = img
    //        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
    //        paddingView.addSubview(imageView)
    //        textField.leftView = paddingView
    //    }
    
    
    
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
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // self.mapView.settings.myLocationButton=true
        self.mapView.isMyLocationEnabled=true
        view.addSubview(self.mapView)
        self.mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        self.mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        self.mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        self.mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        locationPreviewView = LocationPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        
        
        self.view.addSubview(btnAdd)
        btnAdd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive=true
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
    
    
    
    @objc func AddTapped() {
        
        print("save tapped")
        if self.currentlocation != nil {
            print ( self.currentlocation?.coordinate.latitude ?? "null")
            //self.navigationController?.pushViewController(v, animated: true)
            let sb = UIStoryboard(name: "AddPopupControllerView", bundle: nil)
            let popup = sb.instantiateInitialViewController()! as! AddPopupViewController
            
            popup.lat = String(self.currentlocation!.coordinate.latitude)
            popup.lng = String(self.currentlocation!.coordinate.longitude)
            
            print(popup.lat ?? "null")
            
            self.present(popup, animated: true)
        }else{
            self.view.makeToast("You can't add a wifi without its SSID or password!")
        }
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
                self.view.makeToast("No direction available :(")
                
            }
            
        }
    }
}

// maps functions
extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = previewDemoData[customMarkerView.tag]
        locationPreviewView.setData(title: data.desc_loc,img: #imageLiteral(resourceName: "restaurant1") ,price: data.wifi_pass)
        
        
        return locationPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        marker.tracksInfoWindowChanges = true
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        //locationTapped(pos: marker.position)
        AddFav(tag: tag)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
}



//location functions
extension MapViewController: CLLocationManagerDelegate {
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
        let lat = (location?.latitude)!
        let long = (location?.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
        
        self.mapView.animate(to: camera)
        
        //showPartyMarkers(lat: lat, long: long)
    }
}



