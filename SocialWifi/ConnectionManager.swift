//
//  ConnectionManager.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/5/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import Foundation

class ConnectionManager  {
//    let ip = "http://41.226.11.243:10080/"
//    let path =  "socialwifi/android/services.php?action="
    
    let ip = "https://social-wifi.000webhostapp.com/"
    let path =  "services.php?action="
    var action :String
    
    
    init(action:String) {
        self.action = action
    }
    
    func getURL() -> String{
        return ip + path + action
    }
    
    init (){
        self.action = ""
    }
}

