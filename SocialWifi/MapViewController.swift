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
import GooglePlacePicker

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
    var img : UIImage
}

class MapViewController: UIViewController, UITextFieldDelegate , UISearchBarDelegate{
    
    @IBOutlet weak var viewformap: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var currentlocation:CLLocation?
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    var selectedWifi:Wifi?
    var previewDemoData = [Wifi]()
    var descTable = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   self.title = "Home"
        //self.view.backgroundColor = UIColor.white
        
        
        
        //
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        //
        setupViews()
        //LoadLocations()
        var style = ToastStyle()
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        
        setUpSearchBar()
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
            marker.title = self.previewDemoData[i].ssid
            marker.snippet = self.previewDemoData[i].wifi_pass
            marker.map = mapView
        }
    }
    func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    
    //MARK: searchar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            let camera = GMSCameraPosition.camera(withLatitude: self.mapView.camera.target.latitude ,longitude: self.mapView.camera.target.longitude , zoom: 6.0)
            self.mapView.animate(to: camera)
            return
        }
        let currentplace = self.previewDemoData.filter({place -> Bool in
            place.desc_loc.lowercased().contains(searchText.lowercased())
            
        })
        print(searchText)
        print (currentplace)
        if !currentplace.isEmpty {
            let camera = GMSCameraPosition.camera(withLatitude: Double(currentplace.first!.lat)!, longitude: Double(currentplace.first!.lng)!, zoom: 15.0)
            self.mapView.animate(to: camera)
            return
        }
        
        let currentplacetype = self.previewDemoData.filter({place -> Bool in
            place.loc_name.lowercased().contains(searchText.lowercased())
            
        })
        print(searchText)
        print (currentplace)
        if !currentplacetype.isEmpty {
            let camera = GMSCameraPosition.camera(withLatitude: Double(currentplacetype.first!.lat)!, longitude: Double(currentplacetype.first!.lng)!, zoom: 15.0)
            self.mapView.animate(to: camera)
            return
        }
        
    }
    
    ///Alamofire
    func LoadLocations(){
        
        let cm = ConnectionManager(action :"selectloc")
        Alamofire.request(cm.getURL()).responseJSON{ response in
            print(cm.getURL())
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
                    let nblike = Slocation["nblike"] as! String
                    let nbdislike = Slocation["nbdislike"] as! String
                    let ssid = Slocation["ssid"] as! String
                    let loc_name = Slocation["loc_name"] as! String
                    //print(id)
                    let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC , nblike: nblike , nbdislike: nbdislike,ssid: ssid , loc_name:loc_name)
                    
                    self.previewDemoData.append(w)
                    self.descTable.append(desc_loc)
                    print("hhhh")
                }
                print(self.previewDemoData)
                self.showMarker()
                
                
            }
        }
    }
    
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        
        let url:URL = URL(string: url_str)!
        let session = URLSession(configuration: .default)
        
        let getImageFromUrl = session.dataTask(with: url) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        imageView.image = image
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        getImageFromUrl.resume()
    }
    
    //    func initGoogleMaps() {
    //        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
    //        self.mapView.camera = camera
    //        self.mapView.delegate = self
    //        self.mapView.isMyLocationEnabled = true
    //    }
    
    // MARK: CLLocation Manager Delegate
    
    
    
    // MARK: GOOGLE MAP DELEGATE
    
    
    //    func showPartyMarkers(lat: Double, long: Double) {
    //        mapView.clear()
    //        for i in 0..<3 {
    //            let randNum=Double(arc4random_uniform(30))/10000
    //            let marker=GMSMarker()
    //            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: #imageLiteral(resourceName: "restaurant1") , borderColor: UIColor.darkGray, tag: i)
    //            marker.iconView=customMarker
    //            marker.tracksInfoWindowChanges = true
    //            let randInt = arc4random_uniform(4)
    //            if randInt == 0 {
    //                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long-randNum)
    //            } else if randInt == 1 {
    //                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long+randNum)
    //            } else if randInt == 2 {
    //                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long-randNum)
    //            } else {
    //                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long+randNum)
    //            }
    //            marker.map = self.mapView
    //        }
    //    }
    
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
            //self.drawPath(startLocation: currentlocation!, endLocation: CLLocation(latitude: pos.latitude, longitude: pos.longitude))
            print ("location tapped where there was drawpath in map")
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
        //self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.mapView.settings.myLocationButton=true
        self.mapView.isMyLocationEnabled=true
        mapView.settings.allowScrollGesturesDuringRotateOrZoom=true
        self.viewformap.addSubview(self.mapView)
        //        self.mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        //        self.mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        //        self.mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        //        self.mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
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
        btn.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(AddTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.clear()
        LoadLocations()
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdetailswifi" {
            let popup = segue.destination as! VCWifiDetail
            popup.lat=self.selectedWifi?.lat
            popup.lng=self.selectedWifi?.lng
            popup.nbdislike=self.selectedWifi?.nbdislike
            popup.nblike=self.selectedWifi?.nblike
            popup.id=self.selectedWifi?.id_loc
            popup.img=self.selectedWifi?.img
            popup.ssid=self.selectedWifi?.ssid
            popup.pw=self.selectedWifi?.wifi_pass
            popup.loc_name=self.selectedWifi?.loc_name
            popup.disc=self.selectedWifi?.desc_loc
        }
    }
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    
//    func drawPath (startLocation: CLLocation, endLocation: CLLocation)
//    {
//        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
//        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
//
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
//
//        Alamofire.request(url).responseJSON  { response in
//
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // HTTP URL response
//            print(response.data as Any)     // server data
//            print(response.result as Any)   // result of response serialization
//
//            let optjson = try? JSON(data: response.data!)
//            guard let json = optjson else {
//                return
//            }
//            let routes = json["routes"].arrayValue
//            if routes.count>0 {
//                // print route using Polyline
//                for route in routes
//                {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//                    let polyline = GMSPolyline.init(path: path)
//                    polyline.strokeWidth = 4
//                    polyline.strokeColor = UIColor.red
//                    polyline.map = self.mapView
//                }
//            }else {
//                self.view.makeToast("No direction available :(")
//
//            }
//
//        }
//    }
//
    
    
    
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
        locationPreviewView.setData(title: data.ssid,img: data.img ,price: data.wifi_pass)
        
        
        return locationPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        marker.tracksInfoWindowChanges = true
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        //locationTapped(pos: marker.position)
        //AddFav(tag: tag)
        self.selectedWifi = self.previewDemoData[tag]
        self.performSegue(withIdentifier: "showdetailswifi", sender: self)
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



