//
//  DownloadImage.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/15/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import Foundation

class DownloadImage  {
   
    class func getFBID() -> String{
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "idFacebook"
        var currentLevel:String = ""
        if preferences.object(forKey: currentLevelKey) == nil {
            //  Doesn't exist
        } else {
            currentLevel = preferences.value(forKey: currentLevelKey) as! String
            //print ("Faceboook Id : \(currentLevel)")
        }
        return currentLevel
    }
   
}

