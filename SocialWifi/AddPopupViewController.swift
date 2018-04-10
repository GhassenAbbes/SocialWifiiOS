//
//  AddPopupViewController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 3/31/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
class AddPopupViewController: UIViewController {
    
    var lat:String?
    var lng:String?
    
    
    
    
    @IBOutlet weak var SSIDText: UITextField!
    
    @IBOutlet weak var PWText: UITextField!
    
    @IBAction func CancelAction(_ sender: UIButton) {
         dismiss(animated: true)
    }
    
    @IBOutlet weak var SaveBtn: UIButton!
    let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction))
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("cancel tapped")
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        print("save taped")
        print (self.lat ?? "null")
        var style = ToastStyle()
        
        // this is just one of many style options
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        //print (self.SSIDText.text!)
        print (self.lat)
        
        
        if ( self.SSIDText.text!=="" || self.PWText.text!=="" ){
            self.view.makeToast("You can't add a wifi without its SSID or password!") // now uses the shared style
        }else{
            print("here")
            self.AddWifi()
        }
        //dismiss(animated: true)
    }
   
    
    
    ///Alamofire
    func AddWifi(){
        let cm = ConnectionManager(action :"addloc&desc=\(self.SSIDText.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=null")
        
        //let url = "http://192.168.1.7/android/services.php?action=addloc&desc=\(self.SSIDText.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=null"
        print ("url = \(cm.getURL())")
        Alamofire.request(cm.getURL()).responseString{ response in
            print (response.result.isSuccess)
            if     response.result.isSuccess{
                self.dismiss(animated: true)
            }else{
                self.view.makeToast("the wifi couldn't be added :(")
            }
            
        }
    }
    
}

