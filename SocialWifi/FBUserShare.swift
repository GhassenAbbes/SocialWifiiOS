//
//  DownloadImage.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/15/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import Foundation

class FBUserShare {
    
    class func putFB (FB:FBUser){
        let preferences = UserDefaults.standard
        
        _ = preferences.setValue(FB.fb_id, forKey: "id")
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
    
    class func putToken(token:String){
        let preferences = UserDefaults.standard
        
        _ = preferences.setValue(token, forKey: "token")
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Couldn't save (I've never seen this happen in real world testing")
        }
    }
    
    class func putLoc(ssid:String, password:String){
        let preferences = UserDefaults.standard
        
        _ = preferences.setValue(ssid, forKey: "ssid")
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Couldn't save (I've never seen this happen in real world testing")
        }
    }
    class func getSSID() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "ssid")!
    }
    class func getTokenDevice() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "token")!
    }
    class func getFBName() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "name")!
    }
    
    class func getFBLast() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "lastname")!
    }
    class func getFBEmail() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "email")!
    }
    class func getFBPhotoUrl() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "photo")!
    }
    class func getFBId() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: "id")!
    }
   
}

