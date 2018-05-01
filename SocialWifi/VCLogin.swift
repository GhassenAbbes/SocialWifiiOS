//
//  VCLogin.swift
//  SocialWifi
//
//  Created by Ghassen on 4/4/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON
import Toast_Swift
class VCLogin: UIViewController{
    var dictData = Dictionary <String,Any>()
    var fbuser = FBUser()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (result != nil){
            print("Logged in ")
            getFBUserData()
        }
    }

    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, gender, picture.type(large), email, currency"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let fbDetails = result as! Dictionary<String, Any>
                    print(fbDetails)
                    let picture = fbDetails["picture"] as! Dictionary<String, Any>
                    print(picture)
                    var picturedata = picture["data"] as! Dictionary<String, Any>
                    self.fbuser.fb_profile_pic = picturedata["url"] as! String
                    self.fbuser.fb_id = fbDetails["id"] as! String
                    self.fbuser.fb_first_name = fbDetails["first_name"] as! String
                    self.fbuser.fb_last_name = fbDetails["last_name"] as! String
                    self.fbuser.fb_gender = fbDetails["gender"] as! String
                    self.fbuser.fb_email = fbDetails["email"] as! String
                    self.fbuser.fb_access_token = FBSDKAccessToken.current().tokenString
                    FBUserShare.putFB(FB: self.fbuser)
                    self.AddUser(fbuser: self.fbuser)
                    self.performSegue(withIdentifier: "Main", sender: self)
                    
                }
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func BTLogin(_ sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if((FBSDKAccessToken.current()) != nil){
            self.getFBUserData()
          
        }else {
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) -> Void in
                if error != nil {
                    NSLog("Process error")
                }
                else if (result?.isCancelled)! {
                    NSLog("Cancelled")
                }
                else {
                    NSLog("Logged in")
                    self.getFBUserData()
                }
            })
        }
    }
    
    func sharedFB (FB:FBUser){
        let preferences = UserDefaults.standard
        
        _ = preferences.setValue(FB.fb_email, forKey: "id")
        _ = preferences.setValue(FB.fb_email, forKey: "email")
        _ = preferences.setValue(FB.fb_first_name, forKey: "name")
        _ = preferences.setValue(FB.fb_last_name, forKey: "lastname")
        _ = preferences.setValue(FB.fb_profile_pic, forKey: "photo")
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Couldn't save (I've never seen this happen in real world testing")
        }
    }
    
    func AddUser(fbuser:FBUser){
        
        let url = "http://41.226.11.243:10080/socialwifi/android/services.php?action=updateFBUser&fb_id=\(fbuser.fb_id )&fb_first_name=\(fbuser.fb_first_name )&fb_last_name=\(fbuser.fb_last_name )&fb_email=\(fbuser.fb_email)&fb_gender=\(fbuser.fb_gender)&fb_profile_pic=\(fbuser.fb_profile_pic.replacingOccurrences(of: "&", with: "%26"))&fb_access_token=\(fbuser.fb_access_token)"
        print(url)
        Alamofire.request(url).responseString{ response in
            print (response.result.isSuccess)
            if response.result.isSuccess {
                self.showToast(message: "User Added")
            }else{
                self.showToast(message: "the user couldn't be added 😞")
            }
            
        }
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
