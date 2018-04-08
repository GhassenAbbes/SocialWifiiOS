//
//  Wifi.swift
//  
//
//  Created by Ahmed BHD on 3/29/18.
//

import Foundation

class Wifi  {
    var id_loc :Int
    var desc_loc :String
    var wifi_pass :String
    var lat :String
    var lng :String
    var img :String
    var mac :Any

    init(id_loc:Int,desc_loc: String,wifi_pass :String, lat :String ,lng :String , img :String,  mac :Any) {
        self.id_loc = id_loc
        self.desc_loc = desc_loc
        self.wifi_pass = wifi_pass
        self.lat = lat
        self.lng = lng
        self.img = img
        self.mac = mac
    }
}
