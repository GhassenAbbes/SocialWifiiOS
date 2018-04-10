//
//  ConnectionManager.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/5/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import Foundation

class ConnectionManager  {
    let ip = "http://192.168.1.4/"
    let path =  "android/services.php?action="
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

