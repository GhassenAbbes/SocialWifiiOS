//
//  VCWifiDetail.swift
//  SocialWifi
//
//  Created by Ghassen on 4/13/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import GooglePlacePicker
import GooglePlaces
import SwiftyJSON
import FBSDKShareKit
class VCWifiDetail: UIViewController ,GMSPlacePickerViewControllerDelegate{
    let userid = FBUserShare.getFBId()
    @IBOutlet weak var UIWifiImage: UIImageView!
    
    @IBOutlet weak var laWifiName: UILabel!
    @IBOutlet weak var laWifiPassword: UILabel!
    
    @IBOutlet weak var laUnlike: UILabel!
    @IBOutlet weak var laLikes: UILabel!
    @IBOutlet weak var laLocName: UILabel!
    @IBOutlet weak var laWifiDesc: UILabel!
    @IBOutlet weak var AddFav: UIButton!
    
    @IBAction func AddFav(_ sender: Any) {
        AddFavourit()
    }
    
    @IBAction func BackBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func NearBy(_ sender: Any) {
        let center = CLLocationCoordinate2D(latitude: Double(self.lat!)!, longitude: Double(self.lng!)!)
                let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.0001,
                                                       longitude: center.longitude + 0.0001)
                let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.0001,
                                                       longitude: center.longitude - 0.0001)
                let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                let config = GMSPlacePickerConfig(viewport: viewport)
        
                let placePicker = GMSPlacePickerViewController(config: config)
                placePicker.delegate = self
                self.present(placePicker, animated: true, completion: nil)
    }
    var lat:String?
    var lng:String?
    var id:String?
    var img:String?
    var ssid:String?
    var pw:String?
    var nblike:String?
    var nbdislike:String?
    var loc_name:String?
    var disc:String?
    lazy var lazyImage:LazyImage = LazyImage()
    @IBOutlet weak var btnChangePassword: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnChangePassword.isHidden = true
        var style = ToastStyle()
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        laWifiName.text = self.ssid
        laWifiPassword.text = self.pw
        laUnlike.text = self.nbdislike
        laLikes.text = self.nblike
        laLocName.text = self.loc_name
        laWifiDesc.text = self.disc
        
        let a:Int! = Int(laLikes.text!) // firstText is UITextField
        let b:Int! = Int(laUnlike.text!) // secondText is UITextField
        
        if a<b {
            btnChangePassword.isHidden = false
        }
        if self.img! != "null"{
            self.lazyImage.showWithSpinner(imageView:UIWifiImage, url:self.img!)
        }else{
            UIWifiImage.image = #imageLiteral(resourceName: "wifihotspot")
        }
    }
    @IBAction func btChangePassword(_ sender: Any) {
        self.performSegue(withIdentifier: "UpdatePassword", sender: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btLike(_ sender: Any) {
        self.AddVote(tag: 1)
    }
    
    @IBAction func btUnlike(_ sender: Any) {
        self.AddVote(tag: -1)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdatePassword" {
            let popup = segue.destination as! VCUpdatePassword
            popup.id=self.id
            
        }
    }
    
    
//    func showToast(message : String) {
//
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress ?? "" )")
        print("Place attributions \(place.attributions )")
       self.view.makeToast("You can Connect to this wifi from \(place.name)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
         print("No place selected")
        viewController.dismiss(animated: true, completion: nil)
        
       
    }
    
//    @objc func locationTapped(pos: CLLocationCoordinate2D) {
//
//        print("marker info window tapped \(pos)")
//        if (currentlocation != nil){
//            self.drawPath(startLocation: currentlocation!, endLocation: CLLocation(latitude: pos.latitude, longitude: pos.longitude))
//        }else{
//            self.view.makeToast("You need your GPS ON to get directions!")
//
//        }
//    }
    
    
//    func get_image(_ url_str:String, _ imageView:UIImageView)
//    {
//
//        let url:URL = URL(string: url_str)!
//        let session = URLSession(configuration: .default)
//
//        let getImageFromUrl = session.dataTask(with: url) { (data, response, error) in
//
//            //if there is any error
//            if let e = error {
//                //displaying the message
//                print("Error Occurred: \(e)")
//
//            } else {
//                //in case of now error, checking wheather the response is nil or not
//                if (response as? HTTPURLResponse) != nil {
//
//                    //checking if the response contains an image
//                    if let imageData = data {
//
//                        //getting the image
//                        let image = UIImage(data: imageData)
//
//                        //displaying the image
//                        imageView.image = image
//
//                    } else {
//                        print("Image file is currupted")
//                    }
//                } else {
//                    print("No response from server")
//                }
//            }
//        }
//        getImageFromUrl.resume()
//    }
    
    
    func AddVote(tag: Int) {
        let cm = ConnectionManager(action :"addvote&id_loc=\(self.id!)&id_user=\(self.userid )&rate=\(tag)")
        print ("url = \(cm.getURL())")
        
        Alamofire.request(cm.getURL()).validate().responseJSON{ response in
            //print (response.result.value as! NSArray)
            if response.result.isSuccess {
                let array:NSArray = response.result.value as! NSArray
                self.laLikes.text = array[0] as? String
                self.laUnlike.text = array[1] as? String
                //self.showToast(message: "vote updated")
                let a:Int! = Int(self.laLikes.text!) // firstText is UITextField
                let b:Int! = Int(self.laUnlike.text!) // secondText is UITextField
                
                if a<b {
                    self.btnChangePassword.isHidden = false
                }
                self.view.makeToast("vote updated")
            }else{
                self.view.makeToast("vote couldn't be added 😞")
                //self.showToast(message: "vote couldn't be added 😞")
            }
        }
    }
    
    func AddFavourit(){
        print (self.userid)
        let cm = ConnectionManager(action :"addfavourite&id_user=\(self.userid )&id_loc=\(self.id! )")
        let cmcheck = ConnectionManager(action :"checkfav&id_user=\(self.userid )&id_loc=\(self.id! )")
        //let url = "http://192.168.1.7/android/services.php?action=addloc&desc=\(self.SSIDText.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=null"
        print ("url = \(cm.getURL())")
        
        
        
        
                    Alamofire.request(cm.getURL()).responseString{ response in
                        print (response.result.isSuccess)
                        if     response.result.isSuccess{
                            self.view.makeToast("the favourite has been added")
                        }else{
                            self.view.makeToast("the favourite couldn't be added 😞")
                        }
                        
                    }
        }
    
    
}

